//
//  TransferConfirmViewController.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"
#import "TransferTempModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransferConfirmViewController : BaseViewController
@property (nonatomic, strong) TransferTempModel *transModel;
@property (nonatomic, copy) NSString *feeValueStr;//手续费显示

@end

NS_ASSUME_NONNULL_END
