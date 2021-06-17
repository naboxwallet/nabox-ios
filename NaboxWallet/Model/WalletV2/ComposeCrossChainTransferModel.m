//
//  ComposeCrossChainTransferModel.m
//  NaboxWallet
//
//  Created by Admin on 2021/3/13.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "ComposeCrossChainTransferModel.h"

@implementation ComposeCrossChainTransferModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.language = [LanguageUtil getUserLanguageStr];
    }
    return self;
}
@end
