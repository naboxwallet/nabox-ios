//
//  NetManager.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking.h"
#import <AFNetworking/AFHTTPSessionManager.h>

typedef void(^ResponseDataBlock)(id _Nullable dataObj, BOOL success, NSString * _Nullable message);
typedef void(^HttpRequestBlock)(id _Nullable dataObj, NSError * _Nullable error);
/** 进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void(^HttpProgressBlock)(NSProgress * _Nullable progress);

NS_ASSUME_NONNULL_BEGIN

@interface NetManager : AFHTTPSessionManager

/**
 *  外部设置请求header
 */
@property (nonatomic, strong) NSDictionary *httpHeader;


/**
 * 单例 返回该类实例
 */
+ (instancetype)shareNetManager;

/**
 取消所有HTTP请求
 */
- (void)cancelAllRequest;

/**
 取消指定path的HTTP请求
 */
- (void)cancelRequestWithPath:(NSString *)path;


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

/**
 其它方式请求，后续有需求可酌情增加
 */


@end

NS_ASSUME_NONNULL_END
