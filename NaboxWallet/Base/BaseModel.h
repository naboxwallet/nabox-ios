//
//  BaseModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 指定返回数据类型，用于数据解析使用 */
typedef enum : NSUInteger {
    ResponseTypeNormal = 1,    //正常模式，返回接口响应数据
    ResponseTypeObject,        //对象模式，返回数据会解析成对象(默认模式)
    ResponseTypeObjectArr,     //对象数组，返回数据会解析成对象数组
} ResponseType;

//基类model
@interface BaseModel : NSObject

/** 用于返回数据 */
@property (nonatomic ,strong) NSNumber *code;
@property (nonatomic ,copy) NSString *msg;
@property (nonatomic ,copy) id data;

/** 用于数据上传 */
@property (nonatomic, assign) BOOL isAdd;//为get拼接URL情况

/** 用于数据解析 */
@property (nonatomic, assign) ResponseType responseType;//解析类型
@property (nonatomic, copy) NSString *resClassStr; //用于解析的model类名 不传即默认responseType为ResponseTypeNormal

@end

NS_ASSUME_NONNULL_END
