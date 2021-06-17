//
//  NSDecimalNumber+ZHExtensions.h
//  Admin
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

//十进制数字类，继承自NSNumber，苹果针对浮点类型计算精度问题提供出来的计算类，
//基于十进制的科学计数法来计算，同时可以指定舍入模式，一般用于货币计算。

// Rounding policies :
// Original
//    value 1.2  1.21  1.25  1.35  1.27

// Plain    1.2  1.2   1.3   1.4   1.3
// Down     1.2  1.2   1.2   1.3   1.2
// Up       1.2  1.3   1.3   1.4   1.3
// Bankers  1.2  1.2   1.2   1.4   1.3

@interface NSDecimalNumber (ZHExtensions)

/**
 *  @brief  四舍五入 NSRoundPlain
 *
 *  @param scale 限制位数
 *
 *  @return 返回结果
 */
- (NSDecimalNumber*)roundToScale:(NSUInteger)scale;
/**
 *  @brief  四舍五入
 *
 *  @param scale        限制位数
 *  @param roundingMode NSRoundingMode
 *
 *  @return 返回结果
 */
- (NSDecimalNumber*)roundToScale:(NSUInteger)scale mode:(NSRoundingMode)roundingMode;

/**
 相加
 */
- (NSDecimalNumber*)decimalNumberWithPercentage:(float)percent;
- (NSDecimalNumber*)decimalNumberWithDiscountPercentage:(NSDecimalNumber *)discountPercentage;
- (NSDecimalNumber*)decimalNumberWithDiscountPercentage:(NSDecimalNumber *)discountPercentage roundToScale:(NSUInteger)scale;

/**
 相减
 */
- (NSDecimalNumber*)discountPercentageWithBaseValue:(NSDecimalNumber *)baseValue;
- (NSDecimalNumber*)discountPercentageWithBaseValue:(NSDecimalNumber *)baseValue roundToScale:(NSUInteger)scale;

@end
