//
//  WelcomeViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SelectLanguageViewController.h"

@interface WelcomeViewController ()
@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showInfoStrAndPush];
}

- (void)showInfoStrAndPush
{
    self.infoLabel.alpha = 0.f;
    [UIView animateWithDuration:2 animations:^{
        self.infoLabel.text = KLocalizedString(@"welcome");
        self.infoLabel.alpha = 1.f;
    } completion:^(BOOL finished) {
        self.infoLabel.alpha = 0.f;
        [UIView animateWithDuration:2 animations:^{
            self.infoLabel.text = KLocalizedString(@"welcome2");
            self.infoLabel.alpha = 1.f;
        } completion:^(BOOL finished) {
            KPushVC(SelectLanguageViewController);
        }];
    }];
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = KColorDarkGray;
        _infoLabel.font = kSetSystemFontOfSize(21);
        [self.view addSubview:_infoLabel];
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
            make.centerY.equalTo(self.view);
        }];
    }
    return _infoLabel;
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
