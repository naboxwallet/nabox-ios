//
//  ReadSysMsgModel.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "ReadSysMsgModel.h"

@implementation ReadSysMsgModel
- (instancetype)init
{
    if (self = [super init]) {
        self.terminal = TERMINAL;
//        NSArray *wallets = [UserDefaultsUtil getAllWallet];
        NSDictionary *walletDic = [UserDefaultsUtil getNowWallet];
        self.addressList = @[walletDic[@"address"]];
    }
    return self;
}
@end
