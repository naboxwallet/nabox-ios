//
//  SearchAssetModel.m
//  NaboxWallet
//
//  Created by Admin on 2021/4/16.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "SearchAssetModel.h"

@implementation SearchAssetModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.language = [LanguageUtil getUserLanguageStr];
    }
    return self;
}
@end
