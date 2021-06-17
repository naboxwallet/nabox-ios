//
//  CoinDetailModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"
#import "TransferModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoinDetailModel : BaseModel
/**
 * 页码
 */
@property (nonatomic, assign) NSInteger current;
/**
 * 每页的条数
 */
@property (nonatomic, assign) NSInteger size;
/**
 * 每页的条数
 */
@property (nonatomic, strong) NSArray *list;

@end

NS_ASSUME_NONNULL_END
