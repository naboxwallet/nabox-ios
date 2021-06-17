//
//  SelectLanguageViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "SelectLanguageViewController.h"
#import "SelectCurrencyViewController.h"
#import "WelcomeView.h"

@interface SelectLanguageViewController ()
@property (nonatomic, strong) WelcomeView *welcomeView;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UIButton *enButton;
@property (strong, nonatomic) IBOutlet UIButton *zhButton;
@property (strong, nonatomic) IBOutlet UIButton *enSelectButton;
@property (strong, nonatomic) IBOutlet UIButton *zhSelectButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *infoLabelTop;

@end

@implementation SelectLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self welcomeView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self updateUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)updateUI
{
    self.enButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.zhButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    LANGUAGETYPE type = GetLocalPreferredLanguages();
    if (type == LANGUAGETYPEZHHANS) {
        self.infoLabel.text = @"当前检测到您系统语言为：简体中文";
        self.typeLabel.text = @"as: Simplified Chinese";
        [self showButtonStatusType:1];
    }else if (type == LANGUAGETYPEEN) {
        self.infoLabel.text = @"当前检测到您系统语言为：英文";
        self.typeLabel.text = @"as: English";
        [self showButtonStatusType:0];
    }
    [self.nextButton setTitle:KLocalizedString(@"next") forState:UIControlStateNormal];
    if (iPhone5) {
        self.infoLabelTop.constant = 60;
    }
}

- (IBAction)nextButtonClick:(id)sender {
    SelectCurrencyViewController *selectCurrencyVC = [[SelectCurrencyViewController alloc] init];
    [self.navigationController pushViewController:selectCurrencyVC animated:YES];
}


- (IBAction)enButtonClick:(id)sender {
    [self showButtonStatusType:0];
}

- (IBAction)zhBUttonClick:(id)sender {
    [self showButtonStatusType:1];
}

- (void)showButtonStatusType:(NSInteger)type
{
    self.enButton.selected = !type;
    self.zhButton.selected = type;
    self.enSelectButton.selected = self.enButton.selected;
    self.zhSelectButton.selected = self.zhButton.selected;
    [LanguageUtil setUserLanguage:type ? @"zh-Hans" : @"en"];
    [self.nextButton setTitle:KLocalizedString(@"next") forState:UIControlStateNormal];
}

- (WelcomeView *)welcomeView
{
    if (!_welcomeView) {
        _welcomeView = [[WelcomeView alloc] init];
        [KAppDelegate.window addSubview:_welcomeView];
        [_welcomeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(KAppDelegate.window);
        }];
    }
    return _welcomeView;
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
