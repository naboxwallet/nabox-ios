//
//  ImportWalletRootViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//  keystore导入

#import "ImportWalletRootViewController.h"
#import "KeystoreImportWalletViewController.h"
#import "SGPagingView.h"

@interface ImportWalletRootViewController ()<SGPageTitleViewDelegate,SGPageContentViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;
@property (nonatomic, strong) NSMutableArray *vcArr;
@property (nonatomic, assign) NSInteger tempIndex;

@end

@implementation ImportWalletRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KLocalizedString(@"import_wallet");
    [self setPageView];
}

- (void)setPageView
{
    [self.view layoutIfNeeded];
    NSArray *titleArr = @[@"Keystore2.0",@"Keystore1.0"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.bottomSeparatorColor = kColorLine;
    configure.titleColor = KColorDarkGray;
    configure.titleSelectedColor = KColorPrimary;
    configure.indicatorColor = KColorPrimary;
    configure.titleFont = kSetSystemFontOfSize(16);
//    configure.titleSelectedFont = kSetNoAutoSystemFontOfSize(15.1);
    configure.indicatorAdditionalWidth = KSCREEN_WIDTH / 2;
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 44) delegate:self titleNames:titleArr configure:configure];
    self.pageTitleView.backgroundColor = KColorWhite;
    [self.view addSubview:self.pageTitleView];
    [self.pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    self.vcArr = [NSMutableArray array];
    for (int i = 0; i < titleArr.count; i ++) {
        KeystoreImportWalletViewController *importVC = [[KeystoreImportWalletViewController alloc] init];
        importVC.selctIndex = i;
        WS(weakSelf);
        importVC.importBlock = ^{
            [weakSelf.pageContentView updateViewOffset];
        };
        [self.vcArr addObject:importVC];
    }
    
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0,
                                                                               CGRectGetMaxY(self.pageTitleView.frame),
                                                                               KSCREEN_WIDTH,
                                                                               KSCREEN_HEIGHT - CGRectGetMaxY(self.pageTitleView.frame) - KNavbarAndStatusHieght)
                                                           parentVC:self childVCs:self.vcArr];
    self.pageContentView.delegatePageContentView = self;
    [self.view addSubview:self.pageContentView];
    [self.pageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.pageTitleView.mas_bottom);
    }];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    self.tempIndex = selectedIndex;
    [self.pageContentView setPageContentViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    self.tempIndex = targetIndex;
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
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
