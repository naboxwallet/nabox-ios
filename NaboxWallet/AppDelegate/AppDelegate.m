//
//  AppDelegate.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegateTableBar.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "SelectLanguageViewController.h"
#import "CreateWalletTypeViewController.h"
#import "CheckGesturePwdViewController.h"
#import "TQGesturesPasswordManager.h"
#import "WalletUtil.h"
#import "HomeViewController.h"
#import "AccountRefreshModel.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    DLog(@"设备id:%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]);
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
 
//     [UserDefaultsUtil saveValue:[NSNumber numberWithBool:NO] forKey:KEY_ISJOINED];
    //进入逻辑
    NSString *currency = [UserDefaultsUtil getValueWithKey:KEY_CURRENCY];
    if ([currency isHaveValue]) {
        if ([[UserDefaultsUtil getAllWallet] count]) {
            if ([TQGesturesPasswordManager haveLocked]) {
                CheckGesturePwdViewController *vc = [CheckGesturePwdViewController new];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                self.window.rootViewController = nav;
                return YES;
            }
//            self.window.rootViewController = [HomeViewController new];
            [AppDelegateTableBar showMain];
        }else {
            CreateWalletTypeViewController *creaateVC = [[CreateWalletTypeViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:creaateVC];
            self.window.rootViewController = nav;
        }
    }else {
        SelectLanguageViewController *selectVC = [[SelectLanguageViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selectVC];
        self.window.rootViewController = nav;
    }
    [self setKeyboardmanager];
    [self refreshAccount];
    return YES;
}

- (void)setKeyboardmanager
{
    // 获取类库的单例变量
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    // 控制整个功能是否启用
    keyboardManager.enable = YES;
    // 控制点击背景是否收起键盘
    keyboardManager.shouldResignOnTouchOutside = YES;
    // 控制键盘上的工具条文字颜色是否用户自定义
    // keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;
    // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    // keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    // 控制是否显示键盘上的工具条
    keyboardManager.enableAutoToolbar = NO;
    // 设置占位文字的字体
    // keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17];
    // 输入框距离键盘的距离
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
   
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    if ([TQGesturesPasswordManager haveLocked]) {
        CheckGesturePwdViewController *vc = [CheckGesturePwdViewController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
    }
    [self refreshAccount];
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)refreshAccount{
    AccountRefreshModel *model =  [AccountRefreshModel new];
    [NetUtil requestWithType:RequestTypePost path:API_ACCOUNT_REFRESH dataModel:model responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
    }];
}

@end
