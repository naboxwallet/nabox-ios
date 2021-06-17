//
//  ColorMacro.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h

/**
 *  随机色
 */
#define HRRandomColor HRColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

/**
 *  RGB 设置颜色
 */
#define KBaseSetRGBColor(rd,ge,be,al) ([UIColor colorWithRed:rd/255.0f green:ge/255.0f blue:be/255.0f alpha:al])

#define KSetRGBColorWithAlpha(rd,ge,be,al) KBaseSetRGBColor(rd,ge,be,al)

#define KSetRGBColor(rd,ge,be) KBaseSetRGBColor(rd,ge,be,1)

/**
 *  HEX 16进制 设置颜色
 */
#define KBaseSetHEXColor(rgbValue,al) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(al)])

#define KSetHEXColorWithAlpha(rgbValue,al) KBaseSetHEXColor(rgbValue,al)

#define KSetHEXColor(rgbValue) KBaseSetHEXColor(rgbValue,1)


//////////////////////////////项目颜色需求配置/////////////////////////

#define KColorClear     [UIColor clearColor] //透明色
#define KColorWhite     [UIColor whiteColor] //白色
#define KColorBlack     [UIColor blackColor] //黑色
#define KColorPrimary   KSetHEXColor(0x53b8a9)//蓝色 主色
#define KColorBlue      KSetHEXColor(0x53b8a9)//蓝色
#define KColorBg        KSetHEXColor(0xf4f4f4)//背景色
#define KColorRed       KSetHEXColor(0xF14545)//红色
#define KColorYellow    KSetHEXColor(0xffbc09)//黄色

#define KColorSkin1          KSetHEXColor(0x53B8A9)//主色 皮肤
#define KColorSkin2          KSetHEXColor(0x599b72)//皮肤
#define KColorSkin3          KSetHEXColor(0x257cc1)//皮肤
#define KColorSkin4          KSetHEXColor(0x292e39)//皮肤
#define KColorSkin5          KSetHEXColor(0x5270b5)//皮肤
#define KColorGreen          KSetHEXColor(0x43A193)//绿色
#define KColorGreenDisable   KSetHEXColor(0xf4f4f4)//绿色 不可点
#define KColorOrange         KSetHEXColor(0xFD775A)//橘色 正常
#define KColorOrangeCleck    KSetHEXColor(0xFF6543)//橘色 点击
#define KColorOrangeDisable  KSetHEXColor(0xFD775A)//橘色 不可点
#define KColorDarkGray       KSetHEXColor(0x333333)//深灰色
#define KColorGray1          KSetHEXColor(0x616262)//灰色
#define KColorGray2          KSetHEXColor(0x8F95A8)//灰色
#define KColorGray3          KSetHEXColor(0xCCCED8)//灰色
#define KColorGray4          KSetHEXColor(0xE9EBF3)//灰色
#define KColorGray5          KSetHEXColor(0xF7F7F7)//灰色
#define KColorGray6          KSetHEXColor(0xF1F2F7)//灰色
#define kColorBorder         KSetHEXColor(0xd8dce4)
#define kColorBackground     KSetHEXColor(0xf6f7fa)

#define kColorLine  KSetHEXColor(0xe5e5e5)//分割线
#endif /* ColorMacro_h */
