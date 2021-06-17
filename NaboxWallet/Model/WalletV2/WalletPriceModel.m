//
//  WalletPriceModel.m
//  NaboxWallet
//
//  Created by Admin on 2021/1/30.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "WalletPriceModel.h"

@implementation WalletPriceModel
- (instancetype)init
{
    if (self = [super init]) {
        self.language = [LanguageUtil getUserLanguageStr];
        WalletModel *walletModel = [WalletModel mj_objectWithKeyValues:[UserDefaultsUtil getNowWallet]];
        self.pubKey = walletModel.publicKey;
    }
    return self;
}
@end
