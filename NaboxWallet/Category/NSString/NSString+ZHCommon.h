//
//  NSString+ZHCommon.h
//  Admin
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZHCommon)

/**
 *  判断字符串是否有值
 */
-(BOOL)isHaveValue;

///**
// *  获取图片地址
// */
//-(NSURL *)imageURL;
//
///**
// *  获取图片地址
// */
//-(NSString *)imageURLStr;
//
///**
// *  获取图片缩略图地址
// */
//-(NSURL *)imageThumURL;

///**
// *  MD5加密
// */
//-(NSString *)md5String;

/**
 *  计算相应字体下指定宽度的字符串高度
 */
- (CGFloat)stringHeightWithFont:(UIFont *)font width:(CGFloat)width;

/**
 *  手机号格式化
 */
-(NSString *)phoneNumStr;

/**
 *  替换姓名首字为*
 */
- (NSString *)replaceNameToAsterisk;

/**
 *  替换手机号 身份证号中间段为*
 */
- (NSString *)replaceStringToAsterisk;

/**
 *  替换字符串为*
 *  start 开始位置
 *  len   替换长度
 */
- (NSString *)replaceStringToAsteriskStart:(NSInteger)start len:(NSInteger)len;

/**
 *  json字符串转字符串
 */
-(NSString *)jsonStrToStr;

/**
 *  JSON字符传转化成字典
 *
 *  @return 返回字典
 */
- (NSDictionary *)jsonStringToDictionary;

/**
 *  取出HTML
 *
 *  @return 返回字符串
 */
-(NSString *)htmlToString;


/**
 *  @brief  清除html标签
 *
 *  @return 清除后的结果
 */
- (NSString *)stringByStrippingHTML;
/**
 *  @brief  清除js脚本
 *
 *  @return 清楚js后的结果
 */
- (NSString *)stringByRemovingScriptsAndStrippingHTML;
/**
 *  @brief  去除空格
 *
 *  @return 去除空格后的字符串
 */
- (NSString *)trimmingWhitespace;
/**
 *  @brief  去除字符串与空行
 *
 *  @return 去除字符串与空行的字符串
 */
- (NSString *)trimmingWhitespaceAndNewlines;

/**
 *  字符串加密为base64
 *
 *  @return 返回String
 */
-(NSString *)base64StringFromText;

/**
 *  加密字符串解析
 *
 *  @return 返回解析后的字符串
 */
- (NSString *)textFromBase64String;
/**
 *  将字符串转化为NSURL
 *
 *  @return  NSURL地址
 */
-(NSURL *)toUrl;
/**
 *  将资源字符串转化为图片资源
 *
 *  @return  图片
 */
-(UIImage *)toImage;

/**
 *  @brief  获取随机 UUID 例如 E621E1F8-C36C-495A-93FC-0C247A3E6E5F
 *
 *  @return 随机 UUID
 */
+ (NSString *)UUID;
/**
 *
 *  @brief  毫秒时间戳 例如 1443066826371
 *
 *  @return 毫秒时间戳
 */
+ (NSString *)UUIDTimestamp;


/**
 *  判断机型是否支持TouchID
 */
+ (BOOL)judueIPhonePlatformSupportTouchID;


/**
 *  网址路径转换URLEncode编码
 */
- (NSString *)URLEncodedString;

@end
