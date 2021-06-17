//
//  ComposeTransferModel.m
//  NaboxWallet
//
//  Created by Admin on 2021/3/6.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "ComposeTransferModel.h"

@implementation ComposeTransferModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.language = [LanguageUtil getUserLanguageStr];
    }
    return self;
}
@end
