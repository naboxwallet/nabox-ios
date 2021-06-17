//
//  AccountRefreshModel.m
//  NaboxWallet
//
//  Created by 罗洋洋 on 2021/6/1.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "AccountRefreshModel.h"

@implementation AccountRefreshModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.language = [LanguageUtil getUserLanguageStr];
        WalletModel *walletModel = [WalletModel mj_objectWithKeyValues:[UserDefaultsUtil getNowWallet]];
        self.pubKey = walletModel.publicKey;
    }
    return self;
}
@end
