//
//  SyncWalletWithDeviceModel.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019年 NaboxWallet. All rights reserved.
//

#import "SyncWalletWithDeviceModel.h"

@implementation SyncWalletWithDeviceModel
- (instancetype)init
{
    if (self = [super init]) {
        self.terminal = TERMINAL;
        self.type = @"IOS";
        self.language = [LanguageUtil getUserLanguageStr];
        self.timeZone = [[NSTimeZone localTimeZone] name];
        NSDictionary *wallets = [UserDefaultsUtil getNowWallet];
        if (wallets) {
            WalletModel *walletModel = [WalletModel mj_objectWithKeyValues:wallets];
            NSMutableArray *addressArray = [NSMutableArray new];
            for (NSString *chain in [walletModel.addressDict allKeys]) {
                NSDictionary *dict = @{@"chain":chain,@"address":[walletModel.addressDict objectForKey:chain]};
                [addressArray addObject:dict];
            }
            self.addressList = addressArray;
            self.pubKey = walletModel.publicKey;
        }
    }
    return self;
}
@end
