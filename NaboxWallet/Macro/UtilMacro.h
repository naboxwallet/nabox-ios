//
//  UtilMacro.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#ifndef UtilMacro_h
#define UtilMacro_h

//========================================配置========================================

//多语言快捷取值
//#define KLocalizedString(string) NSLocalizedStringFromTable(string,@"Languages", nil)
#define KLocalizedString(string) NSLocalizedStringFromTableInBundle(string, @"Languages", [LanguageUtil bundle], nil)

#define KLineHeight 10
#define KSafeAreaHeight 20
#define KPageSize 10

#define KNameLength     40//名称长度
#define KPasswordLength 40//密码长度

#define TERMINAL [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define D_CHAIN @"NULS" // 默认链


#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
# define DLog(...);
#endif

//========================================引用========================================

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define SS(strongSelf)  __strong __typeof(&*self)strongSelf = weakSelf
#define KWeakSelf __weak typeof(self) weakSelf = self;
#define KAppDelegate  ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define KKeyWindow [UIApplication sharedApplication].keyWindow

#define recourcesPath [[NSBundle mainBundle] resourcePath]

#define kSetSystemFontOfSize(FONTSIZE) [UIFont systemFontOfSize:FONTSIZE]
#define kSetSystemBoldFontOfSize(FONTSIZE) [UIFont boldSystemFontOfSize:FONTSIZE]
//========================================设备判断========================================

#define iPhone4                                                                 \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                   \
? CGSizeEqualToSize(CGSizeMake(640, 960),                                       \
[[UIScreen mainScreen] currentMode].size)                                       \
: NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6                                                                 \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                   \
? CGSizeEqualToSize(CGSizeMake(750, 1334),                                      \
[[UIScreen mainScreen] currentMode].size)                                       \
: NO)
#define iPhone6Plus                                                             \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                   \
? CGSizeEqualToSize(CGSizeMake(1242, 2208),                                     \
[[UIScreen mainScreen] currentMode].size)                                       \
: NO)

//判断iPhoneX，Xs（iPhoneX，iPhoneXs）
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !isPad : NO)

//判断是否为iPhoneX系列
#define iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define iPad                                                                    \
(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)?YES:NO)


//========================================高度获取========================================
#define KSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define KSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define KStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define KNavBarHeight self.navigationController.navigationBar.frame.size.height
#define KNavbarAndStatusHieght (KStatusBarHeight+KNavBarHeight)
#define KTabBarHeight self.tabBarController.tabBar.height

//========================================系统版本========================================
//版本大于等于iOS11
#define GHoEIOS11   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
#define IOS11_OR_GREATER ([[NSProcessInfo processInfo] operatingSystemVersion].majorVersion >= 11)

#define iOS11   @available(iOS 11.0, *)
#define iOS10   @available(iOS 10.0, *)
#define iOS9    @available(iOS 9.0, *)
#define iOS8    @available(iOS 8.0, *)
#define iOS7    @available(iOS 7.0, *)

//当前设备系统版本号
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//获取设备当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//========================================URL========================================

#define KURL(string) [NSURL URLWithString:string.length?string:@""]

//========================================UIImage图片========================================

//读取本地图片
#define LoadImage(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:type]]

//定义UIImage对象
#define ImageNamed(imageName) [UIImage imageNamed:imageName]
#define ImageNamedOriginal(imageName) [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]

#define AliyunImageUrl(imageName) [NSString stringWithFormat:@"https://nuls-cf.oss-us-west-1.aliyuncs.com/icon/%@.png",imageName]

//========================================页面跳转========================================
#define KPushVC(ViewController)\
{\
ViewController *VC = [[ViewController alloc] init];\
[self.navigationController pushViewController:VC animated:YES];\
}

#define KPushVCNotTabBar(ViewController)\
{\
ViewController *VC = [[ViewController alloc] init];\
[VC setHidesBottomBarWhenPushed:YES];\
[self.navigationController pushViewController:VC animated:YES];\
}


//========================================指示器========================================
#define KShowHUD                 [HUDUtil showHUD]
#define KHideHUD                 [HUDUtil hideHUD]
#define KShowHUDWithStr(message) [HUDUtil showHUDWithMessage:message]


static inline CGFloat TQFontSizeFit(CGFloat value) {
    if ([UIScreen mainScreen].bounds.size.width < 375.0f) return value * 0.9;
    if ([UIScreen mainScreen].bounds.size.width > 375.0f) return value * 1.1;
    return value;
}

static inline CGFloat TQSizeFitW(CGFloat value) {
    return value * ([UIScreen mainScreen].bounds.size.width / 375.0f);
}

static inline CGFloat TQSizeFitH(CGFloat value) {
    return value * ([UIScreen mainScreen].bounds.size.height / 667.0f);
}



#endif /* UtilMacro_h */
