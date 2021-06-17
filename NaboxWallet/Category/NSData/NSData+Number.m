//
//  NSData+Number.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "NSData+Number.h"

// 大端转小端
#define KKL_NTOH(z) sizeof(z) > 4 ? ntohll(z) : ntohl(z)
// 转换为小端 data
#define KKL_CONVERT_DATA(type, targetType) type length = (type)self.length; \
type difference = sizeof(type) - length; \
if (difference > sizeof(type)) { \
difference = 0; \
} \
if (length > sizeof(type)) { \
length = sizeof(type); \
} \
type zero = 0; \
NSMutableData *data = [NSMutableData dataWithBytes:&zero length:sizeof(type)]; \
[data replaceBytesInRange:NSMakeRange(difference, length) withBytes:self.bytes]; \
\
type z; \
[data getBytes:&z length:sizeof(type)]; \
type i = KKL_NTOH(z); \
data = [NSMutableData dataWithBytes:&i length:sizeof(type)]; \
targetType value; \
[data getBytes:&value length:sizeof(targetType)]; \
return value;


@implementation NSData (Number)

- (int)kkl_intValue {
    KKL_CONVERT_DATA(uint32_t, int);
}

- (long)kkl_longValue {
    KKL_CONVERT_DATA(uint64_t, long);
}

- (float)kkl_floatValue {
    KKL_CONVERT_DATA(uint32_t, float);
}

- (instancetype)initWithInt:(int)i {
    uint32_t z = KKL_NTOH(i);
    NSData *data = [NSData dataWithBytes:&z length:sizeof(i)];
    return data;
}

- (instancetype)initWithFloat:(float)f {
    NSData *data = [NSData dataWithBytes:&f length:sizeof(f)];
    int i = [data kkl_intValue];
    uint32_t z = KKL_NTOH(i);
    return [self initWithInt:z];
}

- (instancetype)initWithLong:(long)l {
    uint64_t z = KKL_NTOH(l);
    NSData *data = [NSData dataWithBytes:&z length:sizeof(l)];
    return data;
}

- (NSData *)kkl_subdataWithLocation:(NSInteger)location length:(NSInteger)length {
    if (location + length <= self.length) {
        // 获取长度
        NSRange range = NSMakeRange(location, length);
        NSData *subdata = [self subdataWithRange:range];
        return subdata;
    }
    return nil;
}

@end
