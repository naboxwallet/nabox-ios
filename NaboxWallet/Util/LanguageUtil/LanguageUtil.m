//
//  LanguageUtil.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "LanguageUtil.h"

@implementation LanguageUtil

static NSBundle *bundle = nil;
+ (NSBundle *)bundle {
    if (!bundle) {
        //获取文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:[self userLanguage] ofType:@"lproj"];
        bundle = [NSBundle bundleWithPath:path];//生成bundle
    }
    return bundle;
}

//获取当前语言
+ (NSString *)userLanguage {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:@"LocalLanguageKey"];
    if (!language.length) {
        LANGUAGETYPE type = GetLocalPreferredLanguages();
        if (type == LANGUAGETYPEEN) {
            language = @"en";
        }else if (type == LANGUAGETYPEZHHANS) {
            language = @"zh-Hans";
        }
        [self setUserLanguage:language];
    }
    return language;
}

/**
 获取应用当前语言类型
 */
+ (LANGUAGETYPE)getUserLanguageType
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:@"LocalLanguageKey"];
    LANGUAGETYPE type = LANGUAGETYPEZHHANS;
    if ([language isEqualToString:@"en"]) {
        type = LANGUAGETYPEEN;
    }else if ([language isEqualToString:@"zh-Hans"]) {
        type = LANGUAGETYPEZHHANS;
    }
    if (!language.length) {
        type = GetLocalPreferredLanguages();
    }
    return type;
}

/**
 获取应用当前语言类型
 */
+ (NSString *)getUserLanguageStr
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:@"LocalLanguageKey"];
    if ([language isEqualToString:@"en"]) {
        language = @"EN";
    }else if ([language isEqualToString:@"zh-Hans"]) {
        language = @"CHS";
    }
    if (!language.length) {
        LANGUAGETYPE type = GetLocalPreferredLanguages();
        if (type == LANGUAGETYPEEN) {
            language = @"EN";
        }else if (type == LANGUAGETYPEZHHANS) {
            language = @"CHS";
        }
    }
    return language;
}

//设置语言
+ (void)setUserLanguage:(NSString *)language {
    if (!language.length) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currLanguage = [userDefaults valueForKey:@"LocalLanguageKey"];
    if ([currLanguage isEqualToString:language]) {
        return;
    }
    [userDefaults setValue:language forKey:@"LocalLanguageKey"];
    [userDefaults synchronize];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
}

@end
