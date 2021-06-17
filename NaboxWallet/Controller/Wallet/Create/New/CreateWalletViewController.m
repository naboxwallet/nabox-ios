//
//  CreateWalletViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "CreateWalletViewController.h"
#import "SelectSkinViewController.h"
#import "CommonWebViewController.h"
#import "BackUpChooseTypeViewController.h"

@interface CreateWalletViewController ()
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *repetitionTextField;
@property (strong, nonatomic) IBOutlet UIButton *indicatorButton;
@property (strong, nonatomic) IBOutlet UIButton *showButton;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) IBOutlet UIButton *agreementButton;
@property (strong, nonatomic) IBOutlet UIButton *createButton;
@property (strong, nonatomic) IBOutlet UILabel *warnLabel;

@property (nonatomic, assign) NSInteger warnType;
@property (nonatomic, strong) WalletModel *walletModel;
@property (nonatomic ,assign) NSInteger pwdLevel; // 密码级别
@end

@implementation CreateWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoTextFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateUI
{
    self.navigationItem.title = KLocalizedString(@"add_wallet");
    self.infoLabel.text = KLocalizedString(@"password_hint");
    self.nameTextField.placeholder = KLocalizedString(@"wallet_name");
    self.passwordTextField.placeholder = KLocalizedString(@"password");
    self.repetitionTextField.placeholder = KLocalizedString(@"repeat_password");
    [self.selectButton setTitle:[NSString stringWithFormat:@" %@",KLocalizedString(@"read_agree")] forState:UIControlStateNormal];
    [self.agreementButton setTitle:[NSString stringWithFormat:@" %@",KLocalizedString(@"service_sule")] forState:UIControlStateNormal];
    [self.indicatorButton layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleRight) imageTitleSpace:4];
    [self.createButton setTitle:KLocalizedString(@"agree_and_create_wallet") forState:UIControlStateNormal];
    [self.createButton setTouchEnable:NO];
    self.indicatorButton.enabled = NO;
    self.indicatorButton.hidden = YES;
    self.warnLabel.hidden = YES;
    [self.warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameTextField);
        make.top.equalTo(self.nameTextField.mas_bottom).offset(5);
    }];
}

#pragma mark - 监听
- (void)infoTextFieldTextChanged:(NSNotification *)sender
{
    UITextField *textField = (UITextField *)sender.object;
    if (textField.tag == 101) {
        if (!self.warnType) {
            self.warnLabel.hidden = textField.text;
        }
    [Common strLengthLimitWithTextField:textField maxLength:12];
    }else if (textField.tag == 102) {
        //[Common strLengthLimitWithTextField:textField maxLength:20];
        textField.text = [textField.text trimmingWhitespace];
        NSInteger result = [Common judgePasswordStrength:textField.text];
        [self setIndicatorButtonWithResult:result];
        self.pwdLevel = result;
    }else if (textField.tag == 103) {
        textField.text = [textField.text trimmingWhitespace];
//        [Common strLengthLimitWithTextField:textField maxLength:20];
    }
}

- (void)setIndicatorButtonWithResult:(NSInteger)result
{
    self.indicatorButton.hidden = !self.passwordTextField.text.length;
    [self.indicatorButton layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleRight) imageTitleSpace:4];
    if (result == 0) {
        [self.indicatorButton setTitle:[NSString stringWithFormat:@" %@",KLocalizedString(@"danger")] forState:UIControlStateNormal];
        [self.indicatorButton setImage:ImageNamed(@"icon_danger") forState:UIControlStateNormal];
        [self.indicatorButton setTitleColor:KColorRed forState:UIControlStateNormal];
    }else if (result == 1) {
        [self.indicatorButton setTitle:[NSString stringWithFormat:@" %@",KLocalizedString(@"normal")] forState:UIControlStateNormal];
        [self.indicatorButton setImage:ImageNamed(@"icon_norm") forState:UIControlStateNormal];
        [self.indicatorButton setTitleColor:KColorYellow forState:UIControlStateNormal];
    }else if (result == 2) {
        [self.indicatorButton setTitle:[NSString stringWithFormat:@" %@",KLocalizedString(@"safe")] forState:UIControlStateNormal];
        [self.indicatorButton setImage:ImageNamed(@"icon_safe") forState:UIControlStateNormal];
        [self.indicatorButton setTitleColor:KColorPrimary forState:UIControlStateNormal];
    }
}

- (IBAction)showButtonClick:(id)sender {
    self.showButton.selected = !self.showButton.selected;
    self.passwordTextField.secureTextEntry = !self.showButton.selected;
    self.repetitionTextField.secureTextEntry = !self.showButton.selected;
}

- (IBAction)selectButtonClick:(id)sender {
    self.selectButton.selected = !self.selectButton.selected;
    [self.createButton setTouchEnable:self.selectButton.selected];
}

- (IBAction)agreementButtonClick:(id)sender {
    CommonWebViewController *webVC = [[CommonWebViewController alloc] init];
    [webVC setDocType:DocumentTypePrivacyPolicy];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)createButtonClick:(id)sender {
    self.warnLabel.hidden = NO;
    if (!self.nameTextField.text.length) {
        self.warnLabel.text = KLocalizedString(@"input_wallet_name");
        [self setWarnLabelTopWithType:0];
        return;
    }
    if (!self.passwordTextField.text.length) {
        self.warnLabel.text = KLocalizedString(@"please_input_password");
        [self setWarnLabelTopWithType:1];
        return;
    }
    if (!self.repetitionTextField.text.length) {
        self.warnLabel.text = KLocalizedString(@"please_reset_password");
        [self setWarnLabelTopWithType:2];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.repetitionTextField.text]) {
        self.warnLabel.text = KLocalizedString(@"two_password_inconsistencies");
        [self setWarnLabelTopWithType:2];
        return;
    }
    if (self.passwordTextField.text.length < 8 || self.passwordTextField.text.length > 12 || self.pwdLevel == 0) {
        self.warnLabel.text = KLocalizedString(@"password_must_morethan_8");
        [self setWarnLabelTopWithType:1];
        return;
    }
    self.warnLabel.hidden = YES;
    self.walletModel.alias = self.nameTextField.text;
    self.walletModel.password = self.passwordTextField.text;
    
//    SelectSkinViewController *skinVC = [[SelectSkinViewController alloc] init];
//    skinVC.skinType = SelectSkinTypeCreate;
//    skinVC.walletModel = self.walletModel;
//    [self.navigationController pushViewController:skinVC animated:YES];
    
    BackUpChooseTypeViewController *vc = [BackUpChooseTypeViewController new];
    vc.walletModel = self.walletModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setWarnLabelTopWithType:(NSInteger)type
{
    self.warnType = type;
    [self.warnLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameTextField);
        if (type == 0) {
            make.top.equalTo(self.nameTextField.mas_bottom).offset(5);
        }else if (type == 1) {
            make.top.equalTo(self.passwordTextField.mas_bottom).offset(5);
        }else if (type == 2) {
            make.top.equalTo(self.repetitionTextField.mas_bottom).offset(5);
        }
    }];
}

- (WalletModel *)walletModel
{
    if (!_walletModel) {
        _walletModel = [[WalletModel alloc] init];
    }
    return _walletModel;
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
