//
//  TradeListModel.h
//  NaboxWallet
//
//  Created by Admin on 2021/2/28.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TradeListModel : NSObject
@property (nonatomic ,strong) NSNumber *amount;
@property (nonatomic ,assign ) int decimals;
@property (nonatomic ,strong) NSString *createTime;
@property (nonatomic ,strong) NSString *froms;
@property (nonatomic ,strong) NSString *tos;
@property (nonatomic ,assign) NSInteger  transType;
@property (nonatomic ,strong) NSString *status;
@property (nonatomic ,strong) NSString *txHash;
@property (nonatomic ,strong) NSString *symbol;
@property (nonatomic ,assign) NSInteger id;

@end

NS_ASSUME_NONNULL_END
