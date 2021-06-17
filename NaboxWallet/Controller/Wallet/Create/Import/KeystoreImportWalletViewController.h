//
//  KeystoreImportWalletViewController.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ImportBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface KeystoreImportWalletViewController : BaseViewController
@property (nonatomic, assign) NSInteger selctIndex;//0~Keystore2.0，1~Keystore1.0
@property (nonatomic, copy) ImportBlock importBlock;
@end

NS_ASSUME_NONNULL_END
