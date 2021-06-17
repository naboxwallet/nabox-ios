//
//  BackupsPrivateKeyViewController.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    BackupsTypePrivateKey,
    BackupsTypeKeyStore,
} BackupsType;

NS_ASSUME_NONNULL_BEGIN

@interface BackupsPrivateKeyViewController : BaseViewController
@property (nonatomic, copy) NSString *privateKey;
@property (nonatomic, assign) BackupsType backupsType;//备份类型
@property (nonatomic, strong) WalletModel *walletModel;

@property (nonatomic ,assign) BOOL createWallet; // 是否是创建钱包
@property (nonatomic ,strong) NSDictionary *walletDict; // 新建钱包所有参数
@end

NS_ASSUME_NONNULL_END
