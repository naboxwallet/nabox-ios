//
//  TradingRecordViewController.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"
#import "TransferModel.h"
#import "TransDetailRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradingRecordViewController : BaseViewController

@property (nonatomic, strong) NSString *txHash;//交易txHash
@property (nonatomic, assign) NSInteger transCoinId;//交易ID
@property (nonatomic ,strong) NSString *chain;

@end

NS_ASSUME_NONNULL_END
