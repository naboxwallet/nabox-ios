//
//  AppDelegateTableBar.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegateTableBar : NSObject
/**
 tabBar初始化
 */
+ (void)showMain;
+ (void)showMain:(NSUInteger)index;
/**
 tabBar跳转
 index:下标
 */
+ (void)tabBarSelect:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
