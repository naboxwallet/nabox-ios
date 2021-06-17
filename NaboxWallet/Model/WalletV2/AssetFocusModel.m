//
//  AssetFocusModel.m
//  NaboxWallet
//
//  Created by Admin on 2021/4/16.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "AssetFocusModel.h"

@implementation AssetFocusModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.language = [LanguageUtil getUserLanguageStr];
    }
    return self;
}
@end
