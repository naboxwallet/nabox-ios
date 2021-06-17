//
//  Common.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Common : NSObject

/**
 比较两个版本号的大小
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)compareVersion2:(NSString *)v1 to:(NSString *)v2;

/**
 输入框字符数限制 并且未确定文字不做截取处理
 */
+ (void)strLengthLimitWithTextField:(UITextField *)textField maxLength:(NSInteger)maxLength;
/**
 TextView输入字符数限制 并且未确定文字不做截取处理
 */
+ (void)strLengthLimitWithTextView:(UITextView *)textView maxLength:(NSInteger)maxLength;

/**
 生成二维码
 */
+(UIImage *)encodeQRImageWithContent:(NSString *)content withSize:(CGFloat)size;

/**
 图片压缩到指定大小 KB单位
 */
+ (NSData *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize;


/**
 color转image
 */
+(UIImage *)imageWithColor:(UIColor *)color;


//*************************************************label************************************************************

/**
 根据label宽度计算文字高度
 */
+ (CGFloat)getTextHeightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width;

/**
 根据label计算文字高度
 */
+ (CGFloat)getTextHeightNotFontWithText:(UILabel *)label width:(CGFloat)width;

/**
 根据label计算文字高度
 */
+ (CGFloat)getTextWidthNotFontWithText:(UILabel *)label Height:(CGFloat)height;

/**
 根据label高度计算文字宽度
 */
+ (CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)font hight:(CGFloat)hight;

/**
 修改Label中不同文字颜色及行间距
 */
+ (void)editLabelStringWithLabel:(UILabel *)label allStr:(NSString *)string editStr:(NSString *)editStr color:(UIColor *)color isSetLine:(BOOL) isSetLine;

+ (void)editLabelStringWithLabel:(UILabel *)label allStr:(NSString *)string editStrArr:(NSArray *)editStrArr color:(UIColor *)color isSetLine:(BOOL)isSetLine;


/**
 判断密码强度
 */
+ (NSInteger )judgePasswordStrength:(NSString *)password;

/**
 获取钱包样式数据
 type：0~钱包图片，1~钱包图片不带名称，2~钱包样式名称，3~钱包颜色
 index：下标
 */
+ (id)getWalletDataWithType:(NSInteger)type index:(NSInteger)index;

/**
 日期字符串转换NSDate(自定义格式)
 */
+(NSDate *)datetimeStrToNSDate:(NSString *)timeStr dateFormat:(NSString *)dateF;



/**
 Na转nuls后小数点保留8位(自定义小数点位数)
 */
+ (NSString *) decimalwithFormat:(double)formatValue;


/**
 biginteger转token后小数点保留n位(自定义小数点位数)
 */
+ (NSString *)decimalwithFormatByDecimal:(double)formatValue andDecimal:(int)decimal;
+ (NSString *)decimalNotPOWWithFormatByDecimal:(double)formatValue andDecimal:(int)decimal;

/**
 * 除以10^n
 */
+ (NSString *) formatValueWithValue:(NSNumber*)formatValue andDecimal: (int) decimal;
/**
 * 两个数相乘
 */
+ (NSNumber *)Num1:(double)num1 multiplyingByDecimal:(int)decimal;
+ (NSNumber *)Num1:(double)num1 multiplyingWithNum2:(double)num2;
/**
 * 两数相减
 */
+ (NSNumber *)Num1:(double)num1 subtractingWithNum2:(double)num2;
+ (NSNumber *)Num1:(double)num1 withNum1decimal:(int)decimal subtractingWithNum2:(double)num2;
/**
 后台(带时区)日期字符串格式化(自定义格式)
 */

+(NSString *)datetimeStrFromZoneStr:(NSString *)timeStr andFormat:(NSString *)format;

/**
时间戳转日期字符串(自定义格式)
 */

+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;

/**
 * 当前时间戳，秒
 */
+ (long)getNowTimeTimestamp;

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;

/**
 * 为文本添加阴影
 */
+ (NSMutableAttributedString *)setStrShadowWithStr:(NSString *)shadowStr;



+(NSString *)getTradeType:(NSInteger)type;

+ (BOOL)isNulsChain:(NSString *)address;

@end

NS_ASSUME_NONNULL_END
