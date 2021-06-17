//
//  NetManager.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "NetManager.h"

#define TIMEOUT  10.f //超时默认10秒

@interface NetManager ()
@property (nonatomic, strong) NSMutableArray *sessionTasks;
@end

@implementation NetManager

+ (instancetype)shareNetManager
{
    static NetManager *_netManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _netManager = [[NetManager alloc] init];
    });
    return _netManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self.requestSerializer setTimeoutInterval:TIMEOUT];
        //申明请求为json类型
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        //申明响应为json类型
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                          @"application/json",
                                                          @"application/text",
                                                          @"application/xml",
                                                          @"text/json",
                                                          @"text/javascript",
                                                          @"text/html",
                                                          @"text/xml",
                                                          @"text/plain",
                                                          @"text/application",nil];
        
        
        
        //无条件的信任服务器上的证书
        AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
        // 客户端是否信任非法证书
        securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        securityPolicy.validatesDomainName = NO;
        self.securityPolicy = securityPolicy;
    }
    return self;
}

/**
 *  外部设置请求header
 */
- (void)setHttpHeader:(NSDictionary *)httpHeader
{
    for (NSString *key in httpHeader.allKeys) {
        if (key.length) {
            NSString *value = [httpHeader objectForKey:key];
            if (value) {
                [self.requestSerializer setValue:value forHTTPHeaderField:key];
            }
        }
    }
}


/**
 取消所有HTTP请求
 */
- (void)cancelAllRequest
{
    // 锁操作
    @synchronized(self)
    {
        [[self sessionTasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop)
         {
             [task cancel];
         }];
        [[self sessionTasks] removeAllObjects];
    }
}

/**
 取消指定path的HTTP请求
 */
- (void)cancelRequestWithPath:(NSString *)path
{
    if (!path.length) return;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HTTP_BASE,path];
    
    @synchronized (self)
    {
        [[self sessionTasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if ([task.currentRequest.URL.absoluteString hasPrefix:url])
             {
                 [task cancel];
                 [[self sessionTasks] removeObject:task];
                 *stop = YES;
             }
         }];
    }
}

/**
 *  GET请求
 *
 *  @param path          请求地址
 *  @param parameters    请求参数
 *  @param result        数据的回调
 *  @param httpProgress  请求进度的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
- (__kindof NSURLSessionDataTask *)getRequestWithPath:(NSString *)path
                                           parameters:(id)parameters
                                               result:(HttpRequestBlock)result
                                         httpProgress:(HttpProgressBlock)httpProgress;

{
    NSString *url = [self getWholeWithPath:path];
    if (!url.length) {
        return nil;
    }
    NSURLSessionDataTask *task = nil;
    task = [self GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        httpProgress ? httpProgress(downloadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        result ? result(responseObject,nil) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        result ? result(nil,error) : nil;
    }];
    //添加task到数组
    task ? [[self sessionTasks] addObject:task] : nil ;
    return task;
}


/**
 *  POST请求
 *
 *  @param path          请求地址
 *  @param parameters    请求参数
 *  @param result        数据的回调
 *  @param httpProgress  请求进度的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
- (__kindof NSURLSessionDataTask *)postRequestWithPath:(NSString *)path
                                            parameters:(id)parameters
                                                result:(HttpRequestBlock)result
                                          httpProgress:(HttpProgressBlock)httpProgress type:(NSInteger)type;
{
    NSString *url = type == 0 ?[self getWholeWithPath:path] : HTTP_PUBLIC;
    if (!url.length) {
        return nil;
    }
    NSURLSessionDataTask *task = nil;
    task = [self POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        httpProgress ? httpProgress(uploadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        result ? result(responseObject,nil) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        result ? result(nil,error) : nil;
    }];
    //添加task到数组
    task ? [[self sessionTasks] addObject:task] : nil ;
    return task;
}



- (NSString *)getWholeWithPath:(NSString *)path
{
    if (!path.length) {
        return nil;
    }
    // 测试环境费率有误 使用正式环境
    NSString *baseUrl = HTTP_BASE;
    if ([path containsString:API_NULS_BALANCE]) {
        baseUrl = @"http://api.nabox.io/nabox-api/";
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,path];
    return url;
}


- (NSMutableArray *)sessionTasks
{
    if (!_sessionTasks) {
        _sessionTasks = [NSMutableArray array];
    }
    return _sessionTasks;
}

@end
