//
//  AlertShow.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AlertBlock)(id _Nullable obj);

@interface AlertShow : NSObject

/**
 系统自带弹出框 设定时间自动消失
 */
+(void)alertShowWithContent:(NSString *)content
                    Message:(NSString *)message
                    Seconds:(CGFloat)second;

/**
 系统自带弹出框 设定时间自动消失（指定viewController）
 */
+(void)alertShowWithViewController:(UIViewController *)viewController
                           content:(NSString *)content
                           Message:(NSString *)message
                           Seconds:(CGFloat)second;

/**
 系统自带弹出框 设定单个标题点击消失
 */
+(void)alertShowWithContent:(NSString *)content
                    Message:(NSString *)message
                buttonTitle:(NSString *)buttonTitle;

/**
 系统自带弹出框 两个Button
 */
+(void)showWithViewController:(UIViewController *)viewController
                        Title:(NSString *)titleStr
                      Message:(NSString *)msg
                 LeftBtnTitle:(NSString *)leftTitle
                RightBtnTitle:(NSString *)rightTitle
                 ClickLeftBtn:(AlertBlock)leftAction
                ClickRightBtn:(AlertBlock)rightAction;

/**
 系统自带弹出框 一个Button
 */
+(void)showWithViewController:(UIViewController *)viewController
                        Title:(NSString *)titleStr
                      Message:(NSString *)msg
                     BtnTitle:(NSString *)btnTitle
                     ClickBtn:(AlertBlock)btnAction;
@end

NS_ASSUME_NONNULL_END
