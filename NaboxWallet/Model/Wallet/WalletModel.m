//
//  WalletModel.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "WalletModel.h"
#import "ConfigModel.h"
@implementation WalletModel

- (instancetype)init
{
    if (self = [super init]) {
        self.language = [LanguageUtil getUserLanguageStr];
        self.timeZone = [[NSTimeZone localTimeZone] name];
        self.tag = self.language;
        self.coinType = COINTYPE;
        self.bip44ParentPath = [NSString stringWithFormat:@"M/44H/%@H/0H/0",COINTYPECODE];
        self.terminal = TERMINAL;
        self.chain = D_CHAIN;
        self.skinName = @"绿色之夏";
        self.skinImageName = @"png_wallet2_word";
        self.colorIndex = @(0);
    }
    return self;
}

/**
 模型转字典并只解析需要上传的部分参数
 */
- (NSDictionary *)getWalletDictIgnoredKeys
{
    NSDictionary *tempDict = [self mj_keyValuesWithKeys:@[@"address",
                                                          @"alias",
                                                          @"bip44ParentPath",
                                                          @"coinType",
                                                          @"language",
                                                          @"tag",
                                                          @"timeZone",
                                                          @"terminal"]];
    return tempDict;
}

@end
