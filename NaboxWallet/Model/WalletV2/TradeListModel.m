//
//  TradeListModel.m
//  NaboxWallet
//
//  Created by Admin on 2021/2/28.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "TradeListModel.h"

@implementation TradeListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"txHash" : @"hash"};
}
@end
