//
//  SelectFileViewController.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"
#import "KeyStoreModel.h"

typedef void(^SelectKeystoreBlock)(KeyStoreModel * _Nullable model);

NS_ASSUME_NONNULL_BEGIN

@interface SelectFileViewController : BaseViewController
@property (nonatomic, assign) NSInteger selctIndex;//0~Keystore2.0，1~Keystore1.0
@property (nonatomic, copy) SelectKeystoreBlock keystoreBlock;
@end

NS_ASSUME_NONNULL_END
