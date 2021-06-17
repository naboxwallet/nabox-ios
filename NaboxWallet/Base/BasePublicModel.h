//
//  BaseModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//基类model
@interface BasePublicModel : NSObject

/** 用于返回数据 */
@property (nonatomic ,copy) NSString *method;
@property (nonatomic ,strong)id params;
@property (nonatomic ,copy) id result;
@property (nonatomic ,copy) id error;

/** 用于数据解析 */
@property (nonatomic, assign) ResponseType responseType;//解析类型
@property (nonatomic, copy) NSString *resClassStr; //用于解析的model类名 不传即默认responseType为ResponseTypeNormal

@end

NS_ASSUME_NONNULL_END
