//
//  CoinDataModel.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "CoinDataModel.h"

@implementation CoinDataModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"from" : @"CoinFromModel",
             @"to" : @"CoinToModel"};
}


@end
