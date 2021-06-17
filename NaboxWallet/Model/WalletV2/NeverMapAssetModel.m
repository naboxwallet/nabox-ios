//
//  NeverMapAssetModel.m
//  NaboxWallet
//
//  Created by Admin on 2021/4/20.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "NeverMapAssetModel.h"

@implementation NeverMapAssetModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.language = [LanguageUtil getUserLanguageStr];
    }
    return self;
}
@end
