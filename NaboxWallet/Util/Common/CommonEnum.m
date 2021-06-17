//
//  CommonEnum.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "CommonEnum.h"

@interface CommonEnum ()

@end

@implementation CommonEnum

LANGUAGETYPE GetLocalPreferredLanguages(void)
{
    NSString *language = [NSLocale preferredLanguages].firstObject;
    if ([language hasPrefix:@"en"]) {
        return LANGUAGETYPEEN;
    } else if ([language hasPrefix:@"zh"]) {
        if ([language rangeOfString:@"Hans"].location != NSNotFound) {
            return LANGUAGETYPEZHHANS; // 简体中文
        } else { // zh-Hant\zh-HK\zh-TW
            return LANGUAGETYPEZHHANS; // 繁體中文
        }
    } else {
        return LANGUAGETYPEZHHANS; // 简体中文
    }
}

@end
