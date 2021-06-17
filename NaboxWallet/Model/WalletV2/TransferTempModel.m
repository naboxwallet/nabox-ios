//
//  TransferTempModel.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "TransferTempModel.h"

@implementation TransferTempModel

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"fromAssetList" : @"AssetListResModel"};//前边，是属性数组的名字，后边就是类名
}

@end
