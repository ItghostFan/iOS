//
//  HttpCase.m
//  iOSStudy
//
//  Created by ItghostFan on 2022/1/23.
//

#import "HttpCase.h"

#import "HttpUrlProtocol.h"

@interface HttpCase () <
NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate,
NSURLProtocolClient
>
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSOperationQueue *sessionQueue;
@end

@implementation HttpCase

- (instancetype)init {
    if ([super init]) {
        self.sessionQueue = [NSOperationQueue new];
        
        BOOL done = [NSURLProtocol registerClass:HttpUrlProtocol.class];
        NSURLSessionConfiguration *configuration = NSURLSessionConfiguration.defaultSessionConfiguration.copy;
        configuration.protocolClasses = @[HttpUrlProtocol.class];
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.sessionQueue];
        
//        self.session = NSURLSession.sharedSession;
//        NSURLSession.sharedSession.delegateQueue = self.sessionQueue;
//        NSURLSession.sharedSession.delegate = self;
    }
    return self;
}

- (void)dealloc {
    [NSURLProtocol unregisterClass:HttpUrlProtocol.class];
}

- (void)request {
    NSString *body = @"act=mbsdkevent&mbl=en-US&hdid=8c8f0de4b8ed4c3a713a3b6e8f27ebdb863593b2&appkey=dc93707ed513d11b8d42b7dcc9230f6f&time=";
    body = [body stringByAppendingString:@((NSUInteger)NSDate.date.timeIntervalSince1970).stringValue];
    body = [body stringByAppendingString:@"&guid="];
    body = [body stringByAppendingString:NSUUID.UUID.UUIDString];
    body = [body stringByAppendingString:@"&opid=8c8f0de4b8ed4c3a713a3b6e8f27ebdb863593b2&imei=8c8f0de4b8ed4c3a713a3b6e8f27ebdb863593b2&sys=0&hd_crepid=27&hd_autoid=7&net=3&mac=8c8f0de4b8ed4c3a713a3b6e8f27ebdb863593b2&ver=1.0.0.-1&sessionid=c1f2002b900f855143ef7d0be1f41596&from=AppStore&sdkver=3.7.0-dev&app=1396745405&key=5e83aaf47f3a21abedbb0c71e097a9d2&uid=123456&event=event12345%3A0%3A0%3Acustom1234%3A&hd_packid=6&hd_remain=0&hd_curpid=27"];
    NSString *domain = @"datatest.hiido.com";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://121.11.217.208/n.gif?act=mbsdkdata&EC=0&appkey=dc93707ed513d11b8d42b7dcc9230f6f&item=mbsdkevent&host_appkey=dc93707ed513d11b8d42b7dcc9230f6f&host_ver=1.0.0.-1"]];
    
    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    [request setValue:@"no-store" forHTTPHeaderField:@"Cache-Control"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [request setValue:domain forHTTPHeaderField:@"host"];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    [task resume];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
}

// MARK: Tips Https Request 为了给 NSURLSessionTaskDelegate 处理认证
//- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
// completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
//}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
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
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
                            didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
                              completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    NSLog(@"%s", __FUNCTION__);
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
    // MARK: Tips Http Request 返回
    NSLog(@"%@ %lu %lu", error, task.taskIdentifier, ((NSHTTPURLResponse *)task.response).statusCode);
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
                                 didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
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
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
                                  willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler {
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
                                           didWriteData:(int64_t)bytesWritten
                                      totalBytesWritten:(int64_t)totalBytesWritten
                              totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
                                      didResumeAtOffset:(int64_t)fileOffset
                                     expectedTotalBytes:(int64_t)expectedTotalBytes {
}

#pragma mark - NSURLProtocolClient

- (void)URLProtocol:(NSURLProtocol *)protocol wasRedirectedToRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
}

- (void)URLProtocol:(NSURLProtocol *)protocol cachedResponseIsValid:(NSCachedURLResponse *)cachedResponse {
}

- (void)URLProtocol:(NSURLProtocol *)protocol didReceiveResponse:(NSURLResponse *)response cacheStoragePolicy:(NSURLCacheStoragePolicy)policy {
}

- (void)URLProtocol:(NSURLProtocol *)protocol didLoadData:(NSData *)data {
}

- (void)URLProtocolDidFinishLoading:(NSURLProtocol *)protocol {
}

- (void)URLProtocol:(NSURLProtocol *)protocol didFailWithError:(NSError *)error {
}

- (void)URLProtocol:(NSURLProtocol *)protocol didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}

- (void)URLProtocol:(NSURLProtocol *)protocol didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}

@end
