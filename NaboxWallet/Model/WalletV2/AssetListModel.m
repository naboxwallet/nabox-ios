//
//  AssetListModel.m
//  NaboxWallet
//
//  Created by Admin on 2021/2/28.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "AssetListModel.h"

@implementation AssetListModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.language = [LanguageUtil getUserLanguageStr];
    }
    return self;
}
@end

@implementation AssetListResModel

@end


@implementation HeterogeneousListModel

@end

