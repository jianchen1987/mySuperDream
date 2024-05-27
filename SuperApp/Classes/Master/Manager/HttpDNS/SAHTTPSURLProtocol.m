//
//  SAHTTPSURLProtocol.m
//  SuperApp
//
//  Created by Tia on 2022/7/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAHTTPSURLProtocol.h"
#import "NSURLRequest+SABody.h"
#import "SAHttpDnsManager.h"
#import <HDKitCore/HDLog.h>
#import <objc/runtime.h>
#import "NSData+GZIP.h"

static NSString *const kSAURLProtocol = @"SAURLProtocolKey";

static void *const kSAURLProtocolHasEvaluatedStream;


@interface SAHTTPSURLProtocol () <NSStreamDelegate>
/// 网络请求对象
@property (nonatomic, strong) NSMutableURLRequest *mutableRequest;
/// 流对象
@property (nonatomic, strong) NSInputStream *inputStream;
/// runloop
@property (nonatomic, strong) NSRunLoop *runloop;

///< 响应头的备份
@property (nonatomic, strong) NSDictionary *respHeaderBak;

@end


@implementation SAHTTPSURLProtocol

#pragma mark - Override
/**
 *  是否拦截处理指定的请求
 *  @param request 指定的请求
 *  @return YES:拦截处理; NO:不拦截处理
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    // 防止无限循环
    if ([NSURLProtocol propertyForKey:kSAURLProtocol inRequest:request])
        return NO;

#ifdef DEBUG
    //开发环境，如果没有设置过的dns开关的，默认不走dns
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"kHDAuxiliaryToolHadCloseDNSKey"] boolValue])
        return NO;

    //开发环境,根据kHDAuxiliaryToolCloseDNSKey控制是否走DNS逻辑
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"kHDAuxiliaryToolCloseDNSKey"] boolValue])
        return NO;
#endif

    // 只处理https和http的url
    if (![request.URL.scheme isEqualToString:@"http"] && ![request.URL.scheme isEqualToString:@"https"])
        return NO;

    //根据管理者控制拦截
    if (![kSAHttpDnsManager canIntercept])
        return NO;

    //没有返回ip就不拦截
    return [kSAHttpDnsManager getIpByHostAsync:request.URL.host];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    // 可以直接返回request; 也可以在这里修改request，比如添加header，修改host等
    return request;
}

- (void)dealloc {
    self.inputStream = nil;
    self.runloop = nil;
    self.mutableRequest = nil;
}

- (void)startLoading {
    NSMutableURLRequest *mRequest = [self.request sa_bodyForPost];
    NSString *location = mRequest.URL.absoluteString;
    NSString *host = mRequest.URL.host;

    // 内部处理，将url中的host通过HTTPDNS转换为IP
    NSString *ip = [kSAHttpDnsManager getIpByHostAsync:host];
    if (ip) {
        NSRange hostFirstRange = [location rangeOfString:host];
        if (NSNotFound != hostFirstRange.location) {
            NSString *newUrl = [location stringByReplacingCharactersInRange:hostFirstRange withString:ip];
            mRequest.URL = [NSURL URLWithString:newUrl];
            [mRequest setValue:host forHTTPHeaderField:@"host"];
        }
    }
    self.mutableRequest = mRequest;

    // 防止无限循环,表示该请求已经被处理
    [NSURLProtocol setProperty:@(YES) forKey:kSAURLProtocol inRequest:mRequest];

    // 发送请求
    [self startRequest];
}

- (void)stopLoading {
    // 关闭inputStream
    if (self.inputStream && self.inputStream.streamStatus == NSStreamStatusOpen) {
        [self closeInputStream];
        HDLog(@"关闭InputStream");
    }
}

#pragma mark - Request
- (void)startRequest {
    // 创建请求
    CFHTTPMessageRef requestRef = [self createCFRequest];
    CFAutorelease(requestRef);
    // 添加请求头
    [self addHeadersToRequestRef:requestRef];

    // 添加请求体
    [self addBodyToRequestRef:requestRef];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    // 创建CFHTTPMessage对象的输入流
    CFReadStreamRef readStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, requestRef);
#pragma clang diagnostic pop
    self.inputStream = (__bridge_transfer NSInputStream *)readStream;

    // 设置SNI
    [self setupSNI];

    // 设置Runloop
    [self setupRunloop];

    // 打开输入流
    [self.inputStream open];
}

- (CFHTTPMessageRef)createCFRequest {
    // 创建url
    CFStringRef urlStringRef = (__bridge CFStringRef)[self.mutableRequest.URL absoluteString];
    CFURLRef urlRef = CFURLCreateWithString(kCFAllocatorDefault, urlStringRef, NULL);
    CFAutorelease(urlRef);

    // HTTP method
    CFStringRef methodRef = (__bridge CFStringRef)self.mutableRequest.HTTPMethod;

    // 创建request
    CFHTTPMessageRef requestRef = CFHTTPMessageCreateRequest(kCFAllocatorDefault, methodRef, urlRef, kCFHTTPVersion1_1);

    return requestRef;
}

- (void)addHeadersToRequestRef:(CFHTTPMessageRef)requestRef {
    // 添加header信息
    NSMutableDictionary *headFields = [[NSMutableDictionary alloc] initWithDictionary:self.mutableRequest.allHTTPHeaderFields];
    [headFields addEntriesFromDictionary:@{@"hdns": @"1"}];
    for (NSString *header in headFields) {
        if (![header isEqualToString:@"originalBody"]) {
            // 不包含POST请求时存放在header的body信息
            CFStringRef requestHeader = (__bridge CFStringRef)header;
            CFStringRef requestHeaderValue = (__bridge CFStringRef)[headFields valueForKey:header];
            CFHTTPMessageSetHeaderFieldValue(requestRef, requestHeader, requestHeaderValue);
        }
    }
}

- (void)addBodyToRequestRef:(CFHTTPMessageRef)requestRef {
    NSDictionary *headFields = self.mutableRequest.allHTTPHeaderFields;
    // 添加http post请求所附带的数据
    //    CFStringRef requestBody = CFSTR("");
    CFDataRef bodyDataRef = NULL; // = CFStringCreateExternalRepresentation(kCFAllocatorDefault, requestBody, kCFStringEncodingUTF8, 0);
    if (self.mutableRequest.HTTPBody) {
        bodyDataRef = (__bridge_retained CFDataRef)self.mutableRequest.HTTPBody;
    } else if (headFields[@"originalBody"]) {
        // 使用NSURLSession发POST请求时，将原始HTTPBody从header中取出
        bodyDataRef = (__bridge_retained CFDataRef)[headFields[@"originalBody"] dataUsingEncoding:NSUTF8StringEncoding];
    }
    CFHTTPMessageSetBody(requestRef, bodyDataRef);
    if (bodyDataRef != NULL) {
        CFRelease(bodyDataRef);
    }
    //    CFRelease(requestBody);
}

- (void)setupSNI {
    // 设置SNI host信息
    NSString *host = [self.mutableRequest.allHTTPHeaderFields objectForKey:@"host"];
    if (!host) {
        host = self.mutableRequest.URL.host;
    }
    [self.inputStream setProperty:NSStreamSocketSecurityLevelNegotiatedSSL forKey:NSStreamSocketSecurityLevelKey];
    NSDictionary *sslProperties = [[NSDictionary alloc] initWithObjectsAndKeys:host, (__bridge id)kCFStreamSSLPeerName, nil];
    [self.inputStream setProperty:sslProperties forKey:(__bridge NSString *)kCFStreamPropertySSLSettings];
    [self.inputStream setDelegate:self];
}

- (void)setupRunloop {
    if (!self.runloop) {
        // 保存当前线程的runloop，这对于重定向的请求很关键
        self.runloop = [NSRunLoop currentRunLoop];
    }
    // 将请求放入当前runloop的事件队列
    [self.inputStream scheduleInRunLoop:self.runloop forMode:NSRunLoopCommonModes];
}

#pragma mark - Response
/**
 * 响应结束
 */
- (void)endResponse {
    // 读取响应头部信息
    CFReadStreamRef readStream = (__bridge CFReadStreamRef)self.inputStream;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CFHTTPMessageRef messageRef = (CFHTTPMessageRef)CFReadStreamCopyProperty(readStream, kCFStreamPropertyHTTPResponseHeader);
#pragma clang diagnostic pop
    CFAutorelease(messageRef);

    // 头部信息不完整，关闭inputstream，通知client
    if (!CFHTTPMessageIsHeaderComplete(messageRef)) {
        [self closeInputStream];
        if (self.client && [self.client respondsToSelector:@selector(URLProtocolDidFinishLoading:)]) {
            [self.client URLProtocolDidFinishLoading:self];
        }
        return;
    }

    // 把当前请求关闭
    [self closeInputStream];
    // 通知上层响应结束
    if (self.client && [self.client respondsToSelector:@selector(URLProtocolDidFinishLoading:)]) {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)redirect:(NSDictionary *)headDict {
    NSString *location = headDict[@"Location"];
    if (!location)
        location = headDict[@"location"];
    NSURL *url = [[NSURL alloc] initWithString:location];
    self.mutableRequest.URL = url;
    if ([[self.mutableRequest.HTTPMethod lowercaseString] isEqualToString:@"post"]) {
        // 根据RFC文档，当重定向请求为POST请求时，要将其转换为GET请求
        self.mutableRequest.HTTPMethod = @"GET";
        self.mutableRequest.HTTPBody = nil;
    }

    // 内部处理，将url中的host通过HTTPDNS转换为IP
    NSString *ip = [kSAHttpDnsManager getIpByHostAsync:url.host];

    if (ip) {
        NSRange hostFirstRange = [location rangeOfString:url.host];
        if (NSNotFound != hostFirstRange.location) {
            NSString *newUrl = [location stringByReplacingCharactersInRange:hostFirstRange withString:ip];
            self.mutableRequest.URL = [NSURL URLWithString:newUrl];
            [self.mutableRequest setValue:url.host forHTTPHeaderField:@"host"];
        }
    }
    [self startRequest];
}

- (void)closeInputStream {
    [self closeStream:self.inputStream];
}

- (void)closeStream:(NSStream *)aStream {
    [aStream removeFromRunLoop:self.runloop forMode:NSRunLoopCommonModes];
    [aStream setDelegate:nil];
    [aStream close];
}

#pragma mark - NSStreamDelegate
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable: {
            // stream类型校验
            if (![aStream isKindOfClass:[NSInputStream class]]) {
                break;
            }
            NSInputStream *inputStream = (NSInputStream *)aStream;
            CFReadStreamRef readStream = (__bridge CFReadStreamRef)inputStream;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            // 响应头完整性校验
            CFHTTPMessageRef messageRef = (CFHTTPMessageRef)CFReadStreamCopyProperty(readStream, kCFStreamPropertyHTTPResponseHeader);
#pragma clang diagnostic pop
            CFAutorelease(messageRef);
            if (!CFHTTPMessageIsHeaderComplete(messageRef)) {
                return;
            }
            CFIndex statusCode = CFHTTPMessageGetResponseStatusCode(messageRef);

            // 已经https校验了，直接读取数据
            if ([self hasEvaluatedStreamSuccess:aStream]) {
                [self readInputStream:inputStream statusCode:statusCode];

            } else {
                // 添加校验标记
                objc_setAssociatedObject(aStream, kSAURLProtocolHasEvaluatedStream, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_RETAIN);

                if ([self evaluateStreamSuccess:aStream]) { // 校验成功，则读取数据
                    // 非重定向
                    if (![self isRedirectCode:statusCode]) {
                        // 第一次获取到数据
                        [self streamResponseOnce:messageRef];

                        [self readInputStream:inputStream statusCode:statusCode];

                    } else { // 重定向
                        // 关闭流
                        [self closeStream:aStream];

                        [self handleRedirect:messageRef];
                    }
                } else {
                    // 校验失败，关闭stream
                    [self closeStream:aStream];
                    if (self.client && [self.client respondsToSelector:@selector(URLProtocol:didFailWithError:)]) {
                        [self.client URLProtocol:self didFailWithError:[[NSError alloc] initWithDomain:@"fail to evaluate the server trust" code:-1 userInfo:nil]];
                    }
                }
            }
        } break;

        case NSStreamEventErrorOccurred: {
            [self closeStream:aStream];
            // 通知client发生错误了
            if (self.client && [self.client respondsToSelector:@selector(URLProtocol:didFailWithError:)]) {
                [self.client URLProtocol:self didFailWithError:[aStream streamError]];
            }
        } break;

        case NSStreamEventEndEncountered: {
            [self endResponse];
        } break;

        default:
            break;
    }
}

- (BOOL)hasEvaluatedStreamSuccess:(NSStream *)aStream {
    NSNumber *hasEvaluated = objc_getAssociatedObject(aStream, kSAURLProtocolHasEvaluatedStream);
    if (hasEvaluated && hasEvaluated.boolValue) {
        return YES;
    }
    return NO;
}

- (void)streamResponseOnce:(CFHTTPMessageRef)message {
    // 读取响应头
    CFDictionaryRef headerFieldsRef = CFHTTPMessageCopyAllHeaderFields(message);
    NSDictionary *headDict = (__bridge_transfer NSDictionary *)headerFieldsRef;
    self.respHeaderBak = [headDict copy];
    // 读取http version
    CFStringRef httpVersionRef = CFHTTPMessageCopyVersion(message);
    NSString *httpVersion = (__bridge_transfer NSString *)httpVersionRef;

    // 读取状态码
    CFIndex statusCode = CFHTTPMessageGetResponseStatusCode(message);

    // 非重定向的数据，才上报
    if (![self isRedirectCode:statusCode]) {
        if (self.client && [self.client respondsToSelector:@selector(URLProtocol:didReceiveResponse:cacheStoragePolicy:)]) {
            NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.mutableRequest.URL statusCode:statusCode HTTPVersion:httpVersion headerFields:headDict];
            [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        }
    }
}

- (BOOL)evaluateStreamSuccess:(NSStream *)aStream {
    // 证书相关数据
    SecTrustRef trust = (__bridge SecTrustRef)[aStream propertyForKey:(__bridge NSString *)kCFStreamPropertySSLPeerTrust];
    SecTrustResultType res = kSecTrustResultInvalid;
    NSMutableArray *policies = [NSMutableArray array];
    NSString *domain = [[self.mutableRequest allHTTPHeaderFields] valueForKey:@"host"];
    if (domain) {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)domain)];
    } else {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];
    }

    // 证书校验
    SecTrustSetPolicies(trust, (__bridge CFArrayRef)policies);
    if (SecTrustEvaluate(trust, &res) != errSecSuccess) {
        return NO;
    }
    if (res != kSecTrustResultProceed && res != kSecTrustResultUnspecified) {
        return NO;
    }
    return YES;
}

- (void)readInputStream:(NSInputStream *)aInputStream statusCode:(NSInteger)statusCode {
    UInt8 buffer[16 * 1024];
    UInt8 *buf = NULL;
    NSUInteger length = 0;

    if (![aInputStream getBuffer:&buf length:&length]) {
        NSInteger amount = [self.inputStream read:buffer maxLength:sizeof(buffer)];
        buf = buffer;
        length = amount;
    }
    NSData *realData = nil;
    NSData *data = [[NSData alloc] initWithBytes:buf length:length];

    // 需要在这里解压
    if (self.respHeaderBak && self.respHeaderBak.allKeys.count) {
        NSTimeInterval start = [[NSDate new] timeIntervalSince1970];
        NSString *encoding = [self.respHeaderBak valueForKey:@"content-encoding"];
        BOOL isGzip = [encoding.lowercaseString containsString:@"gzip"];
        if (isGzip) {
            HDLog(@"[%@]解压前:%zd", self, data.length);
            realData = [data gunzippedData];
            HDLog(@"[%@]解压后:%zd 耗时:%f", self, realData.length, [[NSDate new] timeIntervalSince1970] - start);
        } else {
            realData = [[NSData alloc] initWithData:data];
        }
    } else {
        realData = [[NSData alloc] initWithData:data];
    }

    // 非重定向，数据才上报
    if (![self isRedirectCode:statusCode]) {
        if (self.client && [self.client respondsToSelector:@selector(URLProtocol:didLoadData:)]) {
            [self.client URLProtocol:self didLoadData:realData];
        }
    }
}

- (BOOL)isRedirectCode:(NSInteger)statusCode {
    if (statusCode >= 300 && statusCode < 400) {
        return YES;
    }
    return NO;
}

- (void)handleRedirect:(CFHTTPMessageRef)messageRef {
    // 响应头
    CFDictionaryRef headerFieldsRef = CFHTTPMessageCopyAllHeaderFields(messageRef);
    NSDictionary *headDict = (__bridge_transfer NSDictionary *)headerFieldsRef;

    // 响应头的loction
    NSString *location = headDict[@"Location"];
    if (!location)
        location = headDict[@"location"];
    NSURL *redirectUrl = [[NSURL alloc] initWithString:location];

    // 读取http version
    CFStringRef httpVersionRef = CFHTTPMessageCopyVersion(messageRef);
    NSString *httpVersion = (__bridge_transfer NSString *)httpVersionRef;

    // 读取状态码
    CFIndex statusCode = CFHTTPMessageGetResponseStatusCode(messageRef);

    // 生成response
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.mutableRequest.URL statusCode:statusCode HTTPVersion:httpVersion headerFields:headDict];

    if (self.client && [self.client respondsToSelector:@selector(URLProtocol:wasRedirectedToRequest:redirectResponse:)]) {
        // 通知上层进行redirect
        [self.client URLProtocol:self wasRedirectedToRequest:[NSURLRequest requestWithURL:redirectUrl] redirectResponse:response];
    } else {
        // 内部进行redirect
        [self redirect:headDict];
    }
}


@end
