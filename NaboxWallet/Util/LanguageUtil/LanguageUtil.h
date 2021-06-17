//
//  LanguageUtil.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LanguageUtil : NSObject

/**
 获取当前资源文件
 */
+ (NSBundle *)bundle;

/**
 获取应用当前语言
 */
+ (NSString *)userLanguage;

/**
 获取应用当前语言类型
 */
+ (LANGUAGETYPE)getUserLanguageType;

/**
 获取应用当前语言类型
 */
+ (NSString *)getUserLanguageStr;

/**设置当前语言
 language : en(英文) or zh-Hans(简体中文)
 */
+ (void)setUserLanguage:(NSString *)language;

@end

NS_ASSUME_NONNULL_END
