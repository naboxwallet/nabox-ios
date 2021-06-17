//
//  ImportWalletViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//  私钥导入

#import "ImportWalletViewController.h"
#import "SetWalletNameViewController.h"
#import "CommonWebViewController.h"

@interface ImportWalletViewController ()
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *reptitionTextField;
@property (strong, nonatomic) IBOutlet UIButton *indicatorButton;
@property (strong, nonatomic) IBOutlet UIButton *showButton;
@property (strong, nonatomic) IBOutlet UIButton *promptLabel;
@property (strong, nonatomic) IBOutlet UIButton *introduceButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UILabel *warnLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *infoLabelTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nextButtonBottom;


@property (nonatomic, strong) WalletModel *walletModel;
@property (nonatomic ,assign) NSInteger pwdLevel; // 密码级别
@end

@implementation ImportWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateUI];
//    self.textView.text = @"32a78bf8cb9527771f3938c388365d1e084a8d506d39a4cc7036622dbb6344c1";
//    self.textView.text = @"6ca94429e32fabcf5c9b5377f0ac49dc89da42b00212084e7d64ccb03ff49d33";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoTextFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoTextViewTextChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateUI
{
    self.navigationItem.title = KLocalizedString(@"import_wallet");
    [self.bgView setCircleWithRadius:6];
    [self.bgView setborderWithBorderColor:KColorGray4 Width:1];
    if (self.importType == ImportWalletTypeMnemonic) {
        self.infoLabel.text = KLocalizedString(@"use_mnemonic_word_import_wallet");
        self.descriptionLabel.hidden = YES;
        self.textView.zw_placeHolder = KLocalizedString(@"mnemonic_word_import_hint");
        self.promptLabel.hidden = YES;
        [self.introduceButton setTitle:KLocalizedString(@"what_is_mnemonic_word") forState:UIControlStateNormal];
    }else if (self.importType == ImportWalletTypePrivateKey) {
        self.infoLabel.text = KLocalizedString(@"use_personal_key_import");
        self.descriptionLabel.text = KLocalizedString(@"use_personal_key_import_hint");
        self.textView.zw_placeHolder = KLocalizedString(@"personal_ket_content");
        [self.introduceButton setTitle:KLocalizedString(@"what_is_personal_key") forState:UIControlStateNormal];
        self.promptLabel.hidden = YES;
    }
    [self.indicatorButton layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleRight) imageTitleSpace:4];
    self.passwordTextField.placeholder = KLocalizedString(@"set_wallet_password");
    self.reptitionTextField.placeholder = KLocalizedString(@"repeat_password");
    [self.nextButton setTitle:KLocalizedString(@"next") forState:UIControlStateNormal];
    [self.nextButton setTouchEnable:NO];
    self.warnLabel.hidden = YES;
    self.indicatorButton.hidden = YES;
    if (iPhone5) {
        self.infoLabelTop.constant = 20;
        self.nextButtonBottom.constant = 20;
    }
}

#pragma mark - 监听
- (void)infoTextFieldTextChanged:(NSNotification *)sender
{
    UITextField *textField = (UITextField *)sender.object;
    if (textField.tag == 102) {
        //[Common strLengthLimitWithTextField:textField maxLength:20];
        textField.text = [textField.text trimmingWhitespace];
        NSInteger result = [Common judgePasswordStrength:textField.text];
        [self setIndicatorButtonWithResult:result];
        self.pwdLevel = result;
    }else if (textField.tag == 103) {
        textField.text = [textField.text trimmingWhitespace];
        //[Common strLengthLimitWithTextField:textField maxLength:20];
    }
    [self textVerify];
}

- (void)infoTextViewTextChanged:(NSNotification *)sender
{
    self.textView.text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self textVerify];
}

- (void)textVerify
{
    if (self.passwordTextField.text.length && self.reptitionTextField.text.length && self.textView.text.length) {
        [self.nextButton setTouchEnable:YES];
    }else {
        [self.nextButton setTouchEnable:NO];
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
    self.reptitionTextField.secureTextEntry = !self.showButton.selected;
}

- (IBAction)introduceButtonClick:(id)sender {
    CommonWebViewController *webVC = [[CommonWebViewController alloc] init];
    if (self.importType == ImportWalletTypeMnemonic) {
        webVC.docType = DocumentTypeMnemonic;
    }else if (self.importType == ImportWalletTypePrivateKey) {
        webVC.docType = DocumentTypePrivateKey;
    }
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)nextButtonClick:(id)sender {
    self.warnLabel.hidden = NO;
    if (!self.passwordTextField.text.length) {
        self.warnLabel.text = KLocalizedString(@"please_input_password");
        [self setWarnLabelTopWithType:1];
        return;
    }
    if (!self.reptitionTextField.text.length) {
        self.warnLabel.text = KLocalizedString(@"please_reset_password");
        [self setWarnLabelTopWithType:2];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.reptitionTextField.text]) {
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
    self.walletModel = [[WalletModel alloc] init];
    self.walletModel.password = self.passwordTextField.text;
    if (self.importType == ImportWalletTypeMnemonic) {
        self.walletModel.mnemonicStr = self.textView.text;
    }else if (self.importType == ImportWalletTypePrivateKey) {
        self.walletModel.privateKey = self.textView.text;
    }
    
    SetWalletNameViewController *nameVC = [[SetWalletNameViewController alloc] init];
    nameVC.walletModel = self.walletModel;
    [self.navigationController pushViewController:nameVC animated:YES];
}

- (void)setWarnLabelTopWithType:(NSInteger)type
{
    [self.warnLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordTextField);
        if (type == 1) {
            make.top.equalTo(self.passwordTextField.mas_bottom).offset(5);
        }else if (type == 2) {
            make.top.equalTo(self.reptitionTextField.mas_bottom).offset(5);
        }
    }];
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
