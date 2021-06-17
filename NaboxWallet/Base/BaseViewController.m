//
//  BaseViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.navigationController.navigationBar setTranslucent:NO];
    self.view.backgroundColor = KColorWhite;
    [self setNav];
    [self tableViewHeightFix];
    [self setBackBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.showTitleIsWhite = NO;
}

- (void)tableViewHeightFix
{
    if (@available(iOS 11.0, *)) {
        //解决iOS11，仅实现heightForHeaderInSection，没有实现viewForHeaderInSection方法时,section间距大的问题
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
    }
}

- (void)setNav
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:KColorWhite] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:KColorBg];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:18],NSForegroundColorAttributeName:KColorBlack}];
}

- (void)setBackBarButtonItem
{
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
        self.navigationItem.leftBarButtonItem.tintColor = KColorBlack;
        self.navigationController.navigationBar.tintColor = KColorClear;
    }else{
        self.navigationItem.hidesBackButton = YES;
        [self.navigationItem.leftBarButtonItem.customView setHidden:YES];
    }
}

- (void)setShowTitleIsWhite:(BOOL)showTitleIsWhite
{
    _showTitleIsWhite = showTitleIsWhite;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:18],NSForegroundColorAttributeName:self.showTitleIsWhite?KColorWhite:KColorBlack}];
    self.navigationItem.leftBarButtonItem.tintColor = self.showTitleIsWhite?KColorWhite:KColorBlack;
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

//下拉刷新
- (void)headerRefresh
{
    
}

//上拉刷新
- (void)footerRefresh
{
    
}

- (BOOL)isModal {
    if([self presentingViewController])
        return YES;
    
    if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
        return YES;
    
    if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
        return YES;
    
    return NO;
}

//通过图片自定义BarButtonItem
- (UIBarButtonItem *)getBarButtonItemWithImage:(UIImage *)image action:(SEL)action
{
    UIBarButtonItem *bit = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:action];
    return bit;
}

//通过文字自定义BarButtonItem
- (UIBarButtonItem *)getBarbuttonItemWith:(NSString *)string titleColor:(UIColor *)titleColor withAction:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize size = [self sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) string:string];
    btn.frame = CGRectMake(0, 0, size.width, KNavBarHeight);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn setTitle:string forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *bit = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return bit;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString *)string
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)moreRightBarButtonWithImages:(NSArray *)images withFirstAction:(SEL)firstAction secondAction:(SEL)secondAction
{
    UIBarButtonItem *firstButton = [[UIBarButtonItem alloc] initWithImage:[images[0] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:firstAction];
    if (images.count == 1) {
        [self.navigationItem setRightBarButtonItems:@[firstButton] animated:YES];
        return;
    }
    UIBarButtonItem *secondButton = [[UIBarButtonItem alloc] initWithImage:[images[1] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:secondAction];
    [self.navigationItem setRightBarButtonItems:@[secondButton,firstButton] animated:YES];
}


- (void)setupRefreshFortableView:(UITableView *)tableView headerReresh:(BOOL)headerReresh footderReResh:(BOOL)footderReResh
{
    if (headerReresh) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
//        header.arrowView.image = ImageNamed(@"bot_refresh");
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        // 设置文字
        [header setTitle:KLocalizedString(@"header_pulling") forState:MJRefreshStateIdle];
        [header setTitle:KLocalizedString(@"header_release") forState:MJRefreshStatePulling];
        [header setTitle:KLocalizedString(@"header_loading") forState:MJRefreshStateRefreshing];
        // 设置字体
        header.stateLabel.font = [UIFont systemFontOfSize:14];
        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
        // 设置颜色
        if (self.showRefreshWhite) {
            header.stateLabel.textColor = KColorWhite;
            header.lastUpdatedTimeLabel.textColor = KColorWhite;
            header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        }
        tableView.mj_header = header;
    }
    if (footderReResh) {
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
//        footer.arrowView.image = ImageNamed(@"bot_refresh");
        // 设置文字
        [footer setTitle:KLocalizedString(@"footer_pulling") forState:MJRefreshStateIdle];
        [footer setTitle:KLocalizedString(@"footer_release") forState:MJRefreshStatePulling];
        [footer setTitle:KLocalizedString(@"footer_refreshing") forState:MJRefreshStateRefreshing];
        [footer setTitle:KLocalizedString(@"footer_nothing") forState:MJRefreshStateNoMoreData];
        // 设置字体
        footer.stateLabel.font = [UIFont systemFontOfSize:14];
        // 设置颜色
//        footer.stateLabel.textColor = kColorTextGray6;
        tableView.mj_footer = footer;
    }
}


- (PlaceholderView *)placeholderView
{
    if (!_placeholderView) {
        _placeholderView = [PlaceholderView instanceView];
        _placeholderView.backgroundColor = [UIColor clearColor];
    }
    return _placeholderView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
