//
//  PageQueryAccountTokenModel.h
//  NaboxWallet
//
//  Created by nuls on 2019/11/13.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//


#import "BaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PageQueryAccountTokenModel : BaseModel

//钱包地址
@property(nonatomic,strong) NSString  *address;

//链id
@property(nonatomic,strong) NSNumber  *chainId;

//当前页码
@property(nonatomic,strong) NSNumber  *current;

//每页条数
@property(nonatomic,strong) NSNumber  *size;

@end

NS_ASSUME_NONNULL_END
