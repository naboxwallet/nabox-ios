//
//  CopyPrivateKeyViewController.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"
#import "KeyStoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CopyPrivateKeyViewController : BaseViewController
@property (nonatomic, copy) NSString *privateKey;

@property (nonatomic ,assign) BOOL isKeyStoreBackUp; // 是否是keystore备份
@property (nonatomic ,assign) BOOL createWallet; // 是否是创建钱包
@property (nonatomic ,strong) NSDictionary *walletDict; // 新建钱包所有参数

@property (nonatomic,strong) KeyStoreModel *keystoreModel; // keystore
@end

NS_ASSUME_NONNULL_END
