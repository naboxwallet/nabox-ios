//
//  NSString+ZHCommon.m
//  Admin
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import "NSString+ZHCommon.h"
#include <sys/sysctl.h>
#import <UIKit/UIDevice.h>

@implementation NSString (ZHCommon)

- (BOOL)isHaveValue{
    //去除首尾的空格
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str == nil || str == NULL || [str isKindOfClass:[NSNull class]] || [str length] == 0 || [str isEqualToString: @"(null)"]) {
        return NO;
    }
    return YES;
}

/**
 *  手机号格式化
 */
- (NSString *)phoneNumStr
{
    if (!self.length || self.length != 11) {
        return self;
    }
    NSString *numberString = [self stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    return numberString;
}

/**
 *  替换姓名首字为*
 */
- (NSString *)replaceNameToAsterisk
{
    if (!self.length) {
        return self;
    }
    return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
}

/**
 *  替换手机号 身份证号中间段为*
 */
- (NSString *)replaceStringToAsterisk {
    if (!self.length) {
        return self;
    }
    NSInteger len = self.length - 2;
    NSString *asteriskStr = self;
    for (NSInteger i = 3; i < len; i++) {
        NSRange range = NSMakeRange(i, 1);
        asteriskStr = [asteriskStr stringByReplacingCharactersInRange:range withString:@"*"];
    }
    return asteriskStr;
}

/**
 *  替换字符串为*
 *  start 开始位置
 *  len   替换长度
 */
- (NSString *)replaceStringToAsteriskStart:(NSInteger)start len:(NSInteger)len {
    if (!self.length) {
        return self;
    }
    if (start >= len) {
        return self;
    }
    NSString *asteriskStr = self;
    for (NSInteger i = start; i <= len; i++) {
        NSRange range = NSMakeRange(i, 1);
        asteriskStr = [asteriskStr stringByReplacingCharactersInRange:range withString:@"*"];
    }
    return asteriskStr;
}

/**
 *  json字符串转字符串
 */
- (NSString *)jsonStrToStr
{
    return [self stringByReplacingOccurrencesOfString:@"\"" withString:@""];
}

- (CGFloat)stringHeightWithFont:(UIFont *)font width:(CGFloat)width{
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    //    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    size =[self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size.height;
}

-(NSDictionary *)jsonStringToDictionary
{
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    //    BOOL  isJson=[NSJSONSerialization isValidJSONObject:self];
    //    NSArray *arr=[NSArray arrayWithObject:jsonData];
    //    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&err];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }
    return dic;
}

//去除字符串
-(NSString *)htmlToString
{
    if (self == nil) {
        return nil;
    }
    NSString *html=self;
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
    
}

/**
 *  @brief  清除html标签
 *
 *  @return 清除后的结果
 */
- (NSString *)stringByStrippingHTML {
    return [self stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}
/**
 *  @brief  清除js脚本
 *
 *  @return 清楚js后的结果
 */
- (NSString *)stringByRemovingScriptsAndStrippingHTML {
    NSMutableString *mString = [self mutableCopy];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<script[^>]*>[\\w\\W]*</script>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:mString options:NSMatchingReportProgress range:NSMakeRange(0, [mString length])];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        [mString replaceCharactersInRange:match.range withString:@""];
    }
    return [mString stringByStrippingHTML];
}
/**
 *  @brief  去除空格
 *
 *  @return 去除空格后的字符串
 */
- (NSString *)trimmingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
/**
 *  @brief  去除字符串与空行
 *
 *  @return 去除字符串与空行的字符串
 */
- (NSString *)trimmingWhitespaceAndNewlines
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


-(NSString *)base64StringFromText
{
    NSData *nsdata = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    // Print the Base64 encoded string
    return  base64Encoded;
}

-(NSString *)textFromBase64String
{
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:self options:0];
    
    // Decoded NSString from the NSData
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    return base64Decoded;
    
}

-(NSURL *)toUrl{
    return  [NSURL URLWithString:self];
}

-(UIImage *)toImage{
    return [UIImage imageNamed:self];
}

/**
 *  @brief  获取随机 UUID 例如 E621E1F8-C36C-495A-93FC-0C247A3E6E5F
 *
 *  @return 随机 UUID
 */
+ (NSString *)UUID
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0)
    {
        return  [[NSUUID UUID] UUIDString];
    }
    else
    {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        return (__bridge_transfer NSString *)uuid;
    }
}
/**
 *
 *  @brief  毫秒时间戳 例如 1443066826371
 *
 *  @return 毫秒时间戳
 */
+ (NSString *)UUIDTimestamp
{
    return  [[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000] stringValue];
}


//是否是5s以上的设备支持
+ (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

// 判断是否支持TouchID
+ (BOOL)judueIPhonePlatformSupportTouchID
{
    /*
     if ([platform isEqualToString:@"iPhone1,1"])   return @"iPhone1G GSM";
     if ([platform isEqualToString:@"iPhone1,2"])   return @"iPhone3G GSM";
     if ([platform isEqualToString:@"iPhone2,1"])   return @"iPhone3GS GSM";
     if ([platform isEqualToString:@"iPhone3,1"])   return @"iPhone4 GSM";
     if ([platform isEqualToString:@"iPhone3,3"])   return @"iPhone4 CDMA";
     if ([platform isEqualToString:@"iPhone4,1"])   return @"iPhone4S";
     if ([platform isEqualToString:@"iPhone5,1"])   return @"iPhone5";
     if ([platform isEqualToString:@"iPhone5,2"])   return @"iPhone5";
     if ([platform isEqualToString:@"iPhone5,3"])   return @"iPhone 5c (A1456/A1532)";
     if ([platform isEqualToString:@"iPhone5,4"])   return @"iPhone 5c (A1507/A1516/A1526/A1529)";
     if ([platform isEqualToString:@"iPhone6,1"])   return @"iPhone 5s (A1453/A1533)";
     if ([platform isEqualToString:@"iPhone6,2"])   return @"iPhone 5s (A1457/A1518/A1528/A1530)";
     */
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if([self platform].length > 6 )
        {
            NSString * numberPlatformStr = [[self platform] substringWithRange:NSMakeRange(6, 1)];
            NSInteger numberPlatform = [numberPlatformStr integerValue];
            // 是否是5s以上的设备
            if(numberPlatform > 5)
            {
                return YES;
            }else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    else
    {
        //iPad 设备
        return NO;
    }
}


- (NSString *)URLEncodedString
{
    NSString * charaters = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:charaters] invertedSet];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:set];
}

//-(void) objectForKey:(NSString*) str  {
//
//    assert(NO); // 这里的assert(NO)是必须的，不允许该函数正常运行
//
//}

@end
