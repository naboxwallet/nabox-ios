//
//  NSDecimalNumber+ZHExtensions.m
//  Admin
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import "NSDecimalNumber+ZHExtensions.h"

@implementation NSDecimalNumber (ZHExtensions)
/**
 *  @brief  四舍五入 NSRoundPlain
 *
 *  @param scale 限制位数
 *
 *  @return 返回结果
 */
- (NSDecimalNumber *)roundToScale:(NSUInteger)scale{
    return [self roundToScale:scale mode:NSRoundPlain];
}
/**
 *  @brief  四舍五入
 *
 *  @param scale        限制位数
 *  @param roundingMode NSRoundingMode
 *
 *  @return 返回结果
 */
- (NSDecimalNumber *)roundToScale:(NSUInteger)scale mode:(NSRoundingMode)roundingMode{
    NSDecimalNumberHandler * handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:roundingMode scale:scale raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
    return [self decimalNumberByRoundingAccordingToBehavior:handler];
}

- (NSDecimalNumber*)decimalNumberWithPercentage:(float)percent {
    NSDecimalNumber * percentage = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:percent] decimalValue]];
    return [self decimalNumberByMultiplyingBy:percentage];
}

- (NSDecimalNumber *)decimalNumberWithDiscountPercentage:(NSDecimalNumber *)discountPercentage {
    NSDecimalNumber * hundred = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumber * percent = [self decimalNumberByMultiplyingBy:[discountPercentage decimalNumberByDividingBy:hundred]];
    return [self decimalNumberBySubtracting:percent];
}

- (NSDecimalNumber *)decimalNumberWithDiscountPercentage:(NSDecimalNumber *)discountPercentage roundToScale:(NSUInteger)scale {
    NSDecimalNumber * value = [self decimalNumberWithDiscountPercentage:discountPercentage];
    return [value roundToScale:scale];
}

- (NSDecimalNumber *)discountPercentageWithBaseValue:(NSDecimalNumber *)baseValue {
    NSDecimalNumber * hundred = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumber * percentage = [[self decimalNumberByDividingBy:baseValue] decimalNumberByMultiplyingBy:hundred];
    return [hundred decimalNumberBySubtracting:percentage];
}

- (NSDecimalNumber *)discountPercentageWithBaseValue:(NSDecimalNumber *)baseValue roundToScale:(NSUInteger)scale {
    NSDecimalNumber * discount = [self discountPercentageWithBaseValue:baseValue];
    return [discount roundToScale:scale];
}

@end
