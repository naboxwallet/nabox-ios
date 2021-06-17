//
//  PKWeb3Utils.m
//  Web3Objc
//
//  Created by coin on 07/05/2020.
//  Copyright © 2020 coin. All rights reserved.
//

#import "PKWeb3Utils.h"
#import "CVETH.h"
#import "RegEx.h"
#define UNIT_MAP @{ @"noether": @"0", @"wei": @"1", @"kwei": @"1000", @"Kwei": @"1000", @"babbage": @"1000", @"femtoether": @"1000", @"mwei": @"1000000", @"Mwei": @"1000000", @"lovelace": @"1000000", @"picoether": @"1000000", @"gwei": @"1000000000", @"Gwei": @"1000000000", @"shannon": @"1000000000", @"nanoether": @"1000000000", @"nano": @"1000000000", @"szabo": @"1000000000000", @"microether": @"1000000000000", @"micro": @"1000000000000", @"finney": @"1000000000000000", @"milliether": @"1000000000000000", @"milli": @"1000000000000000", @"ether": @"1000000000000000000", @"kether": @"1000000000000000000000", @"grand": @"1000000000000000000000", @"mether": @"1000000000000000000000000", @"gether": @"1000000000000000000000000000", @"tether": @"1000000000000000000000000000000"}

@implementation PKWeb3Utils

static RegEx *RegexNumbersOnly = nil;
static NSUInteger etherDecimals = 18;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RegexNumbersOnly = [RegEx regExWithPattern:@"^[0-9]*$"];
    });
}

-(NSString *)randomHex:(NSInteger)_size
{
    return [[CVETHWallet getRandomKeyByBytes:_size] addPrefix0x];
}
-(NSString *)sha3:(NSString *)_string
{
    return [[_string keccak256HashString] addPrefix0x];
}
-(NSString *)keccak256:(NSString *)_string
{
    return [[_string keccak256HashString] addPrefix0x];
}
-(NSString *)toChecksumAddress:(NSString *)_address
{
    return [CVETHWallet getCheckSumAddress:_address];
}
-(BOOL)checkAddressChecksum:(NSString *)_address
{
    return [CVETHWallet checkAddressCheckSum:[_address addPrefix0x]];
}
-(NSString *)numberToHex:(NSString *)_numberString
{
    return [CVETH hexWeiFromWei:_numberString];
}
-(NSString *)hexToNumber:(NSString *)_hex
{
    if ([_hex isEqualToString:@""] || [_hex isEqualToString:@"0x"]) {
        return @"0";
    }
    return [_hex decFromHex];
}
-(NSString *)utf8ToHex:(NSString *)_String
{
    return [[[_String dataUsingEncoding:NSUTF8StringEncoding] dataDirectString] addPrefix0x];
}
-(NSString *)hexToUtf8:(NSString *)_hex
{
    NSString *retVal = [[NSString alloc] initWithData:[[_hex removePrefix0x] parseHexData] encoding:NSUTF8StringEncoding];
    return retVal;
}

-(NSString *)formatUnits:(NSString *)value WithUnit:(NSUInteger)_unit
{
    if (!value) { return nil; }
    
    NSString *weiString = value;
    
    BOOL negative = NO;
    if ([weiString hasPrefix:@"-"]) {
        negative = YES;
        weiString = [weiString substringFromIndex:1];
    }
    
    NSUInteger loop = _unit + 1;
    while (weiString.length < loop) {
        weiString = [@"0" stringByAppendingString:weiString];
    }
    
    NSUInteger decimalIndex = weiString.length - _unit;
    NSString *whole = [weiString substringToIndex:decimalIndex];
    NSString *decimal = [weiString substringFromIndex:decimalIndex];
    
    
    while (decimal.length > 1 && [decimal hasSuffix:@"0"]) {
        decimal = [decimal substringToIndex:decimal.length - 1];
    }
    
    if (negative) {
        whole = [@"-" stringByAppendingString:whole];
    }
    
    return [NSString stringWithFormat:@"%@.%@", whole, decimal];
}
-(NSString *)parseUnits:(NSString *)value WithUnit:(NSUInteger)_unit
{
    if ([value isEqualToString:@"."]) { return nil; }
    
    BOOL negative = NO;
    if ([value hasPrefix:@"-"]) {
        negative = YES;
        value = [value substringFromIndex:1];
    }
    
    if (value.length == 0) { return nil; }
    
    NSArray *parts = [value componentsSeparatedByString:@"."];
    if ([parts count] > 2) { return nil; }
    
    NSString *whole = [parts objectAtIndex:0];
    if (whole.length == 0) { whole = @"0"; }
    if (![RegexNumbersOnly matchesExactly:whole]) { return nil; }
    
    NSString *decimal = ([parts count] > 1) ? [parts objectAtIndex:1]: @"0";
    if (!decimal || decimal.length == 0) { decimal = @"0"; }
    if (![RegexNumbersOnly matchesExactly:decimal]) { return nil; }
    
    if (decimal.length > _unit) { return nil; }
    while (decimal.length < _unit) { decimal = [decimal stringByAppendingString:@"0"]; }
    
    NSString *wei = [whole stringByAppendingString:decimal];
    if (negative) { wei = [@"-" stringByAppendingString:wei]; }
        
    return wei;
}

-(NSString *)formatEther:(NSString *)wei
{
    return [self formatUnits:wei WithUnit:etherDecimals];
}
-(NSString *)parseEther:(NSString *)etherString
{
    return [self parseUnits:etherString WithUnit:etherDecimals];
}

@end
