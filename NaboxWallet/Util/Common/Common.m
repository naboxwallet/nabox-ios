//
//  Common.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "Common.h"

@implementation Common

/**
 比较两个版本号的大小
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; v1大于v2返回1.
 */
+ (NSInteger)compareVersion2:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最大的，进行循环比较
    NSInteger bigCount = (v1Array.count > v2Array.count) ? v1Array.count : v2Array.count;
    
    for (int i = 0; i < bigCount; i++) {
        // 字段有值，取值；字段无值，置0。
        NSInteger value1 = (v1Array.count > i) ? [[v1Array objectAtIndex:i] integerValue] : 0;
        NSInteger value2 = (v2Array.count > i) ? [[v2Array objectAtIndex:i] integerValue] : 0;
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本号相等
    return 0;
}

/**
 输入框字符数限制 并且未确定文字不做截取处理
 */
+ (void)strLengthLimitWithTextField:(UITextField *)textField maxLength:(NSInteger)maxLength
{
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (textField.text.length > maxLength) {
                textField.text = [textField.text substringToIndex:maxLength];
            }
        }else{
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (textField.text.length > maxLength) {
            textField.text = [textField.text substringToIndex:maxLength];
        }
    }
}

/**
 TextView输入字符数限制 并且未确定文字不做截取处理
 */
+ (void)strLengthLimitWithTextView:(UITextView *)textView maxLength:(NSInteger)maxLength
{
    if (!maxLength) {
        return;
    }
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (textView.text.length > maxLength) {
                textView.text = [textView.text substringToIndex:maxLength];
            }
        }else{
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (textView.text.length > maxLength) {
            textView.text = [textView.text substringToIndex:maxLength];
        }
    }
}


+(UIImage *)encodeQRImageWithContent:(NSString *)content withSize:(CGFloat)size
{
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIColor *onColor = [UIColor blackColor];
    UIColor *offColor = [UIColor whiteColor];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(CGSizeMake(size, size));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

+ (NSData *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize
{
    if (!image) {
        return nil;
    }
    CGFloat compression = 1;
    maxFileSize = maxFileSize * 1000;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxFileSize) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxFileSize * 0.9) {
            min = compression;
        } else if (data.length > maxFileSize) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

+(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(CGFloat)getTextHeightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width
{
    NSDictionary *stringAttribute = @{NSFontAttributeName:font};
    CGRect frame = [(NSString *)text boundingRectWithSize:CGSizeMake(width, 10000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:stringAttribute context:nil];
    return frame.size.height;
}

+ (CGFloat)getTextHeightNotFontWithText:(UILabel *)label  width:(CGFloat)width
{
    //文字的高
    CGSize size = CGSizeMake(width, 10000000);
    CGSize labelSize = [label sizeThatFits:size];
    return labelSize.height;
}

+ (CGFloat)getTextWidthNotFontWithText:(UILabel *)label  Height:(CGFloat)height
{
    //文字的高
    CGSize size = CGSizeMake(10000000, height);
    CGSize labelSize = [label sizeThatFits:size];
    return labelSize.width;
}

+(CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)font hight:(CGFloat)hight
{
    NSDictionary *stringAttribute = @{NSFontAttributeName:font};
    CGRect frame = [(NSString *)text boundingRectWithSize:CGSizeMake(10000000, hight) options:NSStringDrawingTruncatesLastVisibleLine attributes:stringAttribute context:nil];
    return frame.size.width;
}

+ (void)editLabelStringWithLabel:(UILabel *)label allStr:(NSString *)string editStr:(NSString *)editStr color:(UIColor *)color isSetLine:(BOOL)isSetLine
{
    if (string.length == 0) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 调节行距大小
    if (isSetLine) {
        [paragraphStyle setLineSpacing:5];
    }
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,string.length)];
    if (editStr.length != 0) {
        // string为整体字符串, editStr为需要修改的字符串
        NSRange range = [string rangeOfString:editStr];
        // 设置属性修改字体颜色UIColor与大小UIFont
        [attributedString addAttributes:@{NSForegroundColorAttributeName:color} range:range];
    }
    label.attributedText = attributedString;
}

+ (void)editLabelStringWithLabel:(UILabel *)label allStr:(NSString *)string editStrArr:(NSArray *)editStrArr color:(UIColor *)color isSetLine:(BOOL)isSetLine
{
    if (string.length == 0) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 调节行距大小
    if (isSetLine) {
        [paragraphStyle setLineSpacing:5];
    }
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,string.length)];
    for (NSString *editStr in editStrArr) {
        if (editStr.length != 0) {
            // string为整体字符串, editStr为需要修改的字符串
            NSRange range = [string rangeOfString:editStr];
            // 设置属性修改字体颜色UIColor与大小UIFont
            [attributedString addAttributes:@{NSForegroundColorAttributeName:color} range:range];
        }
    }
    label.attributedText = attributedString;
}

/**
 判断密码强度
 */
+ (NSInteger )judgePasswordStrength:(NSString *)password
{
    if (!password.length) {
        return 0;
    }
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:password]];
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:password]];
    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:password]];
    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:password]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
    int intResult=0;
    for (int j = 0; j < [resultArray count]; j++)
    {
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
        {
            intResult++;
        }
    }
    NSInteger result = 0;
    if (intResult < 2)
    {
        result = 0;
    }
    else if (intResult == 2 && [password length] >= 6)
    {
        result = 1;
    }
    if (intResult > 2 && [password length] >= 6)
    {
        result = 2;
    }
    return result;
}

//判断是否包含
+ (BOOL)judgeRange:(NSArray *)termArray Password:(NSString *)password
{
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[termArray count]; i++)
    {
        range = [password rangeOfString:[termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            result =YES;
        }
    }
    return result;
}

/**
 获取钱包样式数据
 type：0~钱包图片，1~钱包图片不带名称，2~钱包样式名称，3~钱包颜色
 index：下标
 */
+ (id)getWalletDataWithType:(NSInteger)type index:(NSInteger)index
{
    NSArray *dataArr = @[@[@"png_wallet2_word",
                           @"png_wallet1_word",
                           @"png_wallet3_word",
                           @"png_wallet5_word",
                           @"png_wallet4_word"],
                         @[@"png_wallet2",
                           @"png_wallet1",
                           @"png_wallet3",
                           @"png_wallet5",
                           @"png_wallet4"],
                         @[KLocalizedString(@"skin_name1"),
                           KLocalizedString(@"skin_name2"),
                           KLocalizedString(@"skin_name3"),
                           KLocalizedString(@"skin_name4"),
                           KLocalizedString(@"skin_name5")],
                         @[KColorSkin1,
                           KColorSkin2,
                           KColorSkin3,
                           KColorSkin4,
                           KColorSkin5]];
    if (type > dataArr.count - 1) {
        return nil;
    }
    NSArray *typeArr = [dataArr objectAtIndex:type];
    if (index > typeArr.count - 1) {
        return nil;
    }
    return [typeArr objectAtIndex:index];
}


+ (NSDate *)datetimeStrToNSDate:(NSString *)timeStr dateFormat:(NSString *)dateF
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:dateF];
    NSDate *fromdate = [format dateFromString:timeStr];
    return fromdate;
}

+ (NSString *) decimalwithFormat:(double)formatValue{
    NSString *stringNumber = [NSString stringWithFormat:@"%.8lf",formatValue/pow(10, 8)];
     NSDecimalNumber *amountNum = [NSDecimalNumber decimalNumberWithString:stringNumber];
    NSString * outNumber = [NSString stringWithFormat:@"%@",amountNum];
    return outNumber;
}


+ (NSString *) decimalwithFormatByDecimal:(double)formatValue andDecimal: (int) decimal{
    NSString* format =[NSString stringWithFormat:@"%%.%df",decimal];
    NSString *stringNumber = [NSString stringWithFormat:format,formatValue/pow(10, decimal)];
    NSDecimalNumber *amountNum = [NSDecimalNumber decimalNumberWithString:stringNumber];
    NSString * outNumber = [NSString stringWithFormat:@"%@",amountNum];
    return outNumber;
}

+ (NSString *)decimalNotPOWWithFormatByDecimal:(double)formatValue andDecimal:(int)decimal
{
    NSString* format =[NSString stringWithFormat:@"%%.%df",decimal];
    NSString *stringNumber = [NSString stringWithFormat:format,formatValue];
    NSDecimalNumber *amountNum = [NSDecimalNumber decimalNumberWithString:stringNumber];
    NSString *outNumber = [NSString stringWithFormat:@"%@",amountNum];
    return outNumber;
}

+ (NSString *) formatValueWithValue:(NSNumber*)formatValue andDecimal: (int) decimal{
    if (!formatValue) {
        formatValue = @(0);
    }
    NSDecimalNumber *dividend = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",formatValue]];
    NSDecimalNumber *ten = [NSDecimalNumber decimalNumberWithString:@"10"];
    NSDecimalNumber *divisor = [ten decimalNumberByRaisingToPower:decimal];
    NSDecimalNumber *result = [dividend decimalNumberByDividingBy:divisor];
    return [NSString stringWithFormat:@"%@",result];
}

+ (NSNumber *)Num1:(double)num1 multiplyingByDecimal:(int)decimal{
    NSDecimalNumber *n1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf",num1]];
    NSDecimalNumber *ten = [NSDecimalNumber decimalNumberWithString:@"10"];
    NSDecimalNumber *n2 = [ten decimalNumberByRaisingToPower:decimal];
    NSDecimalNumber *result = [n1 decimalNumberByMultiplyingBy:n2];
    return result;
}

+ (NSNumber *)Num1:(double)num1 multiplyingWithNum2:(double)num2{
    NSDecimalNumber *n1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf",num1]];
    NSDecimalNumber *n2 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf",num2]];
    NSDecimalNumber *result = [n1 decimalNumberByMultiplyingBy:n2];
    return result;
}

+ (NSNumber *)Num1:(double)num1 subtractingWithNum2:(double)num2{
    NSDecimalNumber *n1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf",num1]];
    NSDecimalNumber *n2 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf",num2]];
    NSDecimalNumber *result = [n1 decimalNumberBySubtracting:n2];
    return result;
}

+ (NSNumber *)Num1:(double)num1 withNum1decimal:(int)decimal subtractingWithNum2:(double)num2{
    NSDecimalNumber *n1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf",num1]];
    NSDecimalNumber *ten = [NSDecimalNumber decimalNumberWithString:@"10"];
    NSDecimalNumber *t1 = [ten decimalNumberByRaisingToPower:decimal];
    NSDecimalNumber *t2 = [n1 decimalNumberByDividingBy:t1];
    
    NSDecimalNumber *n2 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf",num2]];
    NSDecimalNumber *result = [t2 decimalNumberBySubtracting:n2];
    if ([result doubleValue] < 0) {
        result = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d",0]];
    }
    return result;
}

+(NSString *)datetimeStrFromZoneStr:(NSString *)timeStr andFormat:(NSString *)format{
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSDate *date =[dateFormat dateFromString:timeStr];
    
        NSDateFormatter *Format=[[NSDateFormatter alloc]init];
        [Format setDateFormat:format];
    NSString *cbStr = [Format stringFromDate:date];
    return cbStr;
}




+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


+ (long)getNowTimeTimestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间
    return (long)[datenow timeIntervalSince1970];
}

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    [shapeLayer setBounds:lineView.bounds];
    
    if (isHorizonal) {
        
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
        
    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    } else {
        
        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

+ (NSMutableAttributedString *)setStrShadowWithStr:(NSString *)shadowStr
{
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:shadowStr];
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = 5.0;
    shadow.shadowOffset = CGSizeMake(5, 2.5);
    shadow.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.13f];
    [attributedString addAttribute:NSShadowAttributeName
                             value:shadow
                             range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}



+(BOOL)isNulsChain:(NSString *)address{
    return [address containsString:@"NULS"];
}

+(NSString *)getTradeType:(NSInteger)type{
    NSArray *typeArr = @[@"全部交易",
                         @"共识奖励",
                         @"转账交易",
                         @"设置别名",
                         @"创建节点",
                         @"加入共识",
                         @"退出共识",
                         @"黄牌惩罚",
                         @"红牌惩罚",
                         @"注销节点",
                         @"跨链交易",
                         @"注册跨链",
                         @"注销跨链",
                         @"新增跨链资产",
                         @"注销跨链资产",
                         @"创建合约",
                         @"调用合约",
                         @"删除合约",
                         @"合约转账",
                         @"合约返还",
                         @"合约创建节点",
                         @"合约参与共识",
                         @"合约退出共识",
                         @"合约注销节点",
                         @"验证人变更",
                         @"验证人初始化",
                         @"token跨链转账"];
    if (type < 0 || type > 26) {
        return @"";
    }
    
    return typeArr[type];
}


@end























//    "type": {
//        "undefined": "",
//        "0": "全部交易",
//        "1": "共识奖励",
//        "2": "转账交易",
//        "3": "设置别名",
//        "4": "创建节点",
//        "5": "加入共识",
//        "6": "退出共识",
//        "7": "黄牌惩罚",
//        "8": "红牌惩罚",
//        "9": "注销节点",
//        "10": "跨链交易",
//        "11": "注册跨链",
//        "12": "注销跨链",
//        "13": "新增跨链资产",
//        "14": "注销跨链资产",
//        "15": "创建合约",
//        "16": "调用合约",
//        "17": "删除合约",
//        "18": "合约转账",
//        "19": "合约返还",
//        "20": "合约创建节点",
//        "21": "合约参与共识",
//        "22": "合约退出共识",
//        "23": "合约注销节点",
//        "24": "验证人变更",
//        "25": "验证人初始化",
//        "26":"token跨链转账"
//    },
