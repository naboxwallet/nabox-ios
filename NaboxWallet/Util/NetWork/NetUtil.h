//
//  NetUtil.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetManager.h"

NS_ASSUME_NONNULL_BEGIN

/** 请求类型 后续有需求可再拓展 */
typedef enum : NSUInteger {
    RequestTypeGet,
    RequestTypePost,
} RequestType;

@interface NetUtil : NSObject

/**
 *  数据请求
 *
 *  @param type          请求类型
 *  @param path          请求方法地址
 *  @param dataModel     请求参数
 *  @param responseBlock 数据的回调
 *
 */
+ (void)requestWithType:(RequestType)type
                   path:(NSString *)path
              dataModel:(BaseModel *)dataModel
          responseBlock:(ResponseDataBlock)responseBlock;

/**
 *  publicServer数据请求
 *  @param method          请求方法地址
 *  @param dataModel     请求参数
 *  @param responseBlock 数据的回调
 */
+ (void)requestWithMethod:(NSString *)method
              dataModel:(BasePublicModel *)dataModel
          responseBlock:(ResponseDataBlock)responseBlock;

@end

NS_ASSUME_NONNULL_END
