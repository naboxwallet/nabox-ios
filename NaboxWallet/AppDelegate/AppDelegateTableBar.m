//
//  AppDelegateTableBar.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "AppDelegateTableBar.h"
#import "ActivitesViewController.h"
#import "MyViewController.h"
#import "HomeViewController.h"

#define kTABBARVIEWCONTROLLER_CONTROLLER(viewcontroller,ktitle,neimage,acimage) \
{   \
viewcontroller *vc = [[viewcontroller alloc] init];\
UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];\
nav.navigationBar.barTintColor = [UIColor whiteColor];\
nav.navigationBar.translucent = NO;\
nav.tabBarItem = [[UITabBarItem alloc]initWithTitle:ktitle image:[[UIImage imageNamed:neimage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:acimage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];\
NSDictionary *dictHome = [NSDictionary dictionaryWithObject:KColorPrimary forKey:NSForegroundColorAttributeName];\
[nav.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];\
[viewControllers addObject:nav];\
}

@implementation AppDelegateTableBar

+ (void)showMain
{
    [AppDelegateTableBar showMain:0];
}

+ (void)showMain:(NSUInteger)index
{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    kTABBARVIEWCONTROLLER_CONTROLLER(HomeViewController, KLocalizedString(@"wallet"), @"icon_wallet", @"icon_wallet_click");
    kTABBARVIEWCONTROLLER_CONTROLLER(ActivitesViewController, KLocalizedString(@"activitys"), @"icon_active", @"icon_active_click");
    kTABBARVIEWCONTROLLER_CONTROLLER(MyViewController, KLocalizedString(@"user"), @"icon_my", @"icon_my_click");
    UITabBarController *tabBar = [[UITabBarController alloc] init];
    tabBar.viewControllers = viewControllers;
    tabBar.selectedIndex = index;
    tabBar.tabBar.tintColor = KColorPrimary;
    KAppDelegate.window.rootViewController = tabBar;
}

+ (void)tabBarSelect:(NSUInteger)index
{
    UITabBarController *tabBar = (UITabBarController *)KAppDelegate.window.rootViewController;
    tabBar.selectedIndex = index;
}

@end
