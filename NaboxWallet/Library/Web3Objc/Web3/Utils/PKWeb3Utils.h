//
//  PKWeb3Utils.h
//  Web3Objc
//
//  Created by coin on 07/05/2020.
//  Copyright © 2020 coin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BigNumber.h"

NS_ASSUME_NONNULL_BEGIN

@interface PKWeb3Utils : NSObject
-(NSString *)randomHex:(NSInteger)_size;
-(NSString *)sha3:(NSString *)_string;
-(NSString *)keccak256:(NSString *)_string;
-(NSString *)toChecksumAddress:(NSString *)_address;
-(BOOL)checkAddressChecksum:(NSString *)_address;
-(NSString *)numberToHex:(NSString *)_numberString;
-(NSString *)hexToNumber:(NSString *)_hex;
-(NSString *)utf8ToHex:(NSString *)_String;
-(NSString *)hexToUtf8:(NSString *)_hex;

-(NSString *)formatUnits:(NSString *)value WithUnit:(NSUInteger)_unit;
-(NSString *)parseUnits:(NSString *)value WithUnit:(NSUInteger)_unit;

-(NSString *)formatEther:(NSString *)wei;
-(NSString *)parseEther:(NSString *)etherString;
@end

NS_ASSUME_NONNULL_END
