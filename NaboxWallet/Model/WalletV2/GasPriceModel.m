//
//  GasPriceModel.m
//  NaboxWallet
//
//  Created by Admin on 2021/3/11.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "GasPriceModel.h"

@implementation GasPriceModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.language = [LanguageUtil getUserLanguageStr];
    }
    return self;
}
@end
