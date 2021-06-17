//
//  AccountsAssetModel.m
//  NaboxWallet
//
//  Created by Admin on 2021/3/27.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "AccountsAssetModel.h"

@implementation AccountsAssetModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.language = [LanguageUtil getUserLanguageStr];
    }
    return self;
}
@end
