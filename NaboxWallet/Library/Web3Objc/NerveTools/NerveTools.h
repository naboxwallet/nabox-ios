//
//  NerveTools.h
//  Web3Objc
//
//  Created by pierreluo on 2021/3/19.
//  Copyright © 2021 coin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKWeb3Objc.h"

@interface NerveTools : NSObject

+ (NSString *)sendEth: (PKWeb3Objc *) web3 PriKey: (NSString *)_priKey To: (NSString *)_to Value: (NSString *)_value;

+ (NSString *)sendERC20: (PKWeb3Objc *) web3 PriKey: (NSString *)_priKey ERC20Contract: (NSString *)_contract ERC20Decimals: (NSUInteger)_decimals To: (NSString *)_to Value: (NSString *)_value;

+ (NSString *)approveERC20: (PKWeb3Objc *) web3 PriKey: (NSString *)_priKey ERC20Contract: (NSString *)_contract ERC20Decimals: (NSUInteger)_decimals To: (NSString *)_to Value: (NSString *)_value;

+ (NSString *)getERC20Allowance: (PKWeb3Objc *) web3 Owner: (NSString *)_owner ERC20Contract: (NSString *)_contract Spender: (NSString *)_spender;

+ (NSString *)getERC20Balance: (PKWeb3Objc *) web3 Owner: (NSString *)_owner ERC20Contract: (NSString *)_contract;

+ (NSString *)crossOutWithETH: (PKWeb3Objc *) web3 PriKey: (NSString *)_priKey MultyContract: (NSString *)_contract To: (NSString *)_to Value: (NSString *)_value;

+ (NSString *)crossOutWithERC20: (PKWeb3Objc *) web3 PriKey: (NSString *)_priKey MultyContract: (NSString *)_multyContract ERC20Contract: (NSString *)_erc20Contract ERC20Decimals: (NSUInteger)_erc20Decimals To: (NSString *)_to Value: (NSString *)_value;

+ (BOOL)needERC20Allowance: (PKWeb3Objc *) web3 Owner: (NSString *)_owner ERC20Contract: (NSString *)_contract Spender: (NSString *)_spender;
@end


