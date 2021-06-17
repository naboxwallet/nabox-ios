//
//  TradeInfoModel.m
//  NaboxWallet
//
//  Created by Admin on 2021/3/7.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "TradeInfoModel.h"

@implementation TradeInfoModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.language = [LanguageUtil getUserLanguageStr];
    }
    return self;
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"txId" : @"id"};
}
@end

@implementation TradeInfoResModel

@end

@implementation CrossTxModel

@end

