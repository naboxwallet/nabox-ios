//
//  GasLimitModel.m
//  NaboxWallet
//
//  Created by nuls on 2019/11/15.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "GasLimitModel.h"

@implementation GasLimitModel
- (instancetype)init
{
    if (self = [super init]) {
        self.language = [LanguageUtil getUserLanguageStr];
        self.value = @"0";
        self.methodName = @"transfer";
        self.methodDesc = @"";

    }
    return self;
}
@end
