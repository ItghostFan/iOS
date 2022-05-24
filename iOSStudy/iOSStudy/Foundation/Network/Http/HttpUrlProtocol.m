//
//  HttpUrlProtocol.m
//  iOSStudy
//
//  Created by Itghost Fan on 2022/5/24.
//

#import "HttpUrlProtocol.h"

@interface HttpUrlProtocol () <NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>
@property (strong, nonatomic) NSURLSessionTask *task;
@property (strong, nonatomic) NSURLSession *session;
@end

@implementation HttpUrlProtocol

#pragma mark - NSURLProtocol Required

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    // 一律返回可以处理，其实这里可以根据domain，uri去单独处理。
    return YES;
}

+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
    // 一律返回可以处理，其实这里可以根据domain，uri去单独处理。
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *result = request.mutableCopy;
    if ([result.HTTPMethod isEqualToString:@"POST"]) {
        if (!result.HTTPBody) {
            NSInteger maxLength = 1024;
            uint8_t d[maxLength];
            NSInputStream *stream = result.HTTPBodyStream;
            NSMutableData *data = NSMutableData.new;
            [stream open];
            BOOL endOfStreamReached = NO;
            while (!endOfStreamReached) {
                NSInteger bytesRead = [stream read:d maxLength:maxLength];
                if (bytesRead == 0) {
                    endOfStreamReached = YES;
                } else if (bytesRead == -1) {
                    endOfStreamReached = YES;
                } else if (stream.streamError == nil) {
                    [data appendBytes:(void *)d length:bytesRead];
                }
            }
            result.HTTPBody = data.copy;
            [stream close];
        }
    }
    return result;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return NO;
}

- (void)startLoading {
    // 继续使用默认实现。
    self.task = [self.session dataTaskWithRequest:self.request];
    [self.task resume];
}

- (void)stopLoading {
    [self.task cancel];
    self.task = nil;
}

#pragma mark - NSURLProtocol Optional

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client {
    if (self = [super initWithRequest:request cachedResponse:cachedResponse client:client]) {
        NSLog(@"Init %@ With Request", NSStringFromClass(self.class));
    }
    return [self initSelf];
}

- (instancetype)initWithTask:(NSURLSessionTask *)task cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client {
    if (self = [super initWithTask:task cachedResponse:cachedResponse client:client]) {
        NSLog(@"Init %@ With Task", NSStringFromClass(self.class));
    }
    return [self initSelf];
}

- (instancetype)initSelf {
    NSURLSessionConfiguration *configuration = NSURLSessionConfiguration.defaultSessionConfiguration.copy;
    NSMutableArray *protocolClasses = configuration.protocolClasses.mutableCopy;
    [protocolClasses removeObject:self.class];
    configuration.protocolClasses = protocolClasses;
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    return self;
}

- (void)dealloc {
    NSLog(@"Release %@", NSStringFromClass(self.class));
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
                        willBeginDelayedRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLSessionDelayedRequestDisposition disposition, NSURLRequest * _Nullable newRequest))completionHandler  API_AVAILABLE(ios(11.0)) {
}

- (void)URLSession:(NSURLSession *)session taskIsWaitingForConnectivity:(NSURLSessionTask *)task {
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
                     willPerformHTTPRedirection:(NSHTTPURLResponse *)response
                                     newRequest:(NSURLRequest *)request
                              completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
                            didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
                              completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    // MARK: Tips Https Request 认证
    if (![challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        // MARK: Tips Https 没有认证
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
        return;
    }
    static NSDictionary *gHostIps = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gHostIps = @{
            @"121.11.217.208": @"datatest.hiido.com"
        };
    });
    NSString *domain = gHostIps[task.currentRequest.URL.host]?:task.currentRequest.URL.host;
    NSMutableArray *policies = [NSMutableArray array];
    [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)domain)];
    SecTrustSetPolicies(challenge.protectionSpace.serverTrust, (__bridge CFArrayRef)policies);

    SecTrustResultType trustRsult;
    if (@available(iOS 13.0, *)) {
        CFErrorRef errorRef;
        if (!SecTrustEvaluateWithError(challenge.protectionSpace.serverTrust, &errorRef)) {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
            CFRelease(errorRef);
            return;
        }
    } else {
        if (noErr != SecTrustEvaluate(challenge.protectionSpace.serverTrust, &trustRsult)) {
            if (trustRsult != kSecTrustResultUnspecified && trustRsult != kSecTrustResultProceed) {
                completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
            }
            return;
        }
    }
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    if (credential) {
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, credential);
        [self.client URLProtocol:self didReceiveAuthenticationChallenge:challenge];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * _Nullable bodyStream))completionHandler {
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
                                didSendBodyData:(int64_t)bytesSent
                                 totalBytesSent:(int64_t)totalBytesSent
                       totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    // MARK: Tips Http Request 进度
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics API_AVAILABLE(ios(10.0)) {
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
                           didCompleteWithError:(nullable NSError *)error {
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    }
    else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
                                 didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask {
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
                                  willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler {
}

@end
