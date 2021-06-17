//
//  BaseViewController.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic, strong) PlaceholderView *placeholderView;//占位视图
@property (nonatomic, assign) BOOL showTitleIsWhite;
@property (nonatomic, assign) BOOL showRefreshWhite;

//返回
- (void)goBack;

//通过图片自定义BarButtonItem
- (UIBarButtonItem *)getBarButtonItemWithImage:(UIImage *)image action:(SEL)action;

//通过文字自定义BarButtonItem
- (UIBarButtonItem *)getBarbuttonItemWith:(NSString *)string titleColor:(UIColor *)titleColor withAction:(SEL)action;

//通过图片自定义设置1个or2个BarButtonItem
- (void)moreRightBarButtonWithImages:(NSArray *)images withFirstAction:(SEL)firstAction secondAction:(SEL)secondAction;

//下拉刷新
- (void)headerRefresh;

//上拉刷新
- (void)footerRefresh;

//设置上下拉刷新
- (void)setupRefreshFortableView:(UITableView *)tableView headerReresh:(BOOL)headerReresh footderReResh:(BOOL)footderReResh;

@end

NS_ASSUME_NONNULL_END
