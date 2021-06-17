//
//  NSData+Number.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 num类型和NSData类型互转
 */
@interface NSData (Number)

- (int)kkl_intValue;

- (long)kkl_longValue;

- (float)kkl_floatValue;

- (instancetype)initWithInt:(int)i;

- (instancetype)initWithFloat:(float)f;

- (instancetype)initWithLong:(long)l;

- (NSData *)kkl_subdataWithLocation:(NSInteger)location length:(NSInteger)length;

@end

NS_ASSUME_NONNULL_END
