//
//  ChainUtil.m
//  NaboxWallet
//
//  Created by Admin on 2021/4/18.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "ChainUtil.h"
//BSC = 0x8f404078E5E3A7de8502dc4544805bC0eEbccc6E;
//Ethereum = 0x8f404078E5E3A7de8502dc4544805bC0eEbccc6E;
//Heco = 0x8f404078E5E3A7de8502dc4544805bC0eEbccc6E;
//NERVE = TNVTdTSPTXQudD2FBSefpQRkXTyhhtSjyEVAF;
//NULS = tNULSeBaMt9Tf6VvfYfvUFGVqdiyPqFLfQg9La;
@implementation ChainUtil
+(BOOL)isNuls:(NSString *)chain{
    return [chain isEqualToString:@"NULS"];
}
+(BOOL)isNerve:(NSString *)chain{
    return [chain isEqualToString:@"NERVE"];
}
+(BOOL)isNulsSeries:(NSString *)chain{
    return [chain isEqualToString:@"NULS"] || [chain isEqualToString:@"NERVE"];
}
+(BOOL)isHeterChain:(NSString *)chain{
    return [chain isEqualToString:@"Ethereum"] || [chain isEqualToString:@"Heco"] || [chain isEqualToString:@"BSC"] || [chain isEqualToString:@"OKExChain"];
}

+(NSString *)ChainFromAddress:(NSString *)address{
    NSString *chain = @"";
    if ([address hasPrefix:PREFIX]) {
        chain = @"NULS";
    } else if ([address hasPrefix:NVT_PREFIX]){
        chain = @"NERVE";
    }
    return chain;
}
+(BOOL)isNulsAddress:(NSString *)address{
    return [address hasPrefix:PREFIX] && address.length - PREFIX.length == 33;
}
+(BOOL)isNerveAddress:(NSString *)address{
    return [address hasPrefix:NVT_PREFIX] && address.length - NVT_PREFIX.length == 33;
}
+(BOOL)isHeterAddress:(NSString *)address{
    if ([address hasPrefix:@"0x"] && address.length == 42) {
        return YES;
    }
    return NO;
}

+(BOOL)needComposeHashFromChain:(NSString *)fromChain andToChain:(NSString *)toChain{
    return ![self isNerve:fromChain] && ![self isNerve:toChain] && ![fromChain isEqualToString:toChain];
}


/** 交易时验证地址合法性 **/
+(BOOL)isCorrectAddress:(NSString *)address withChain:(NSString *)chain{
    if ([self isNuls:chain]) {
        return [self isNulsAddress:address];
    }else if ([self isNerve:chain]){
        return [self isNerveAddress:address];
    }else if ([self isHeterChain:chain]){
        return [self isHeterAddress:address];
    }
    return NO;
}
@end
