//
//  AssetInfoModel.m
//  NaboxWallet
//
//  Created by Admin on 2021/3/6.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "AssetInfoModel.h"

@implementation AssetInfoModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.language = [LanguageUtil getUserLanguageStr];
        self.refresh = false;
    }
    return self;
}
@end
