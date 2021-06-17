//
//  KeystoreImportWalletViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "KeystoreImportWalletViewController.h"
#import "SetWalletNameViewController.h"
#import "SelectFileViewController.h"
#import "CommonWebViewController.h"
#import "KeyStoreModel.h"

@interface KeystoreImportWalletViewController ()
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *addFileButton;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *showButton;
@property (strong, nonatomic) IBOutlet UIButton *promptButton;
@property (strong, nonatomic) IBOutlet UIButton *introduceButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UILabel *warnLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nextButtonBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *infoLabelTop;

@end

@implementation KeystoreImportWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoTextFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoTextViewTextChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateUI
{
    [self.bgView setCircleWithRadius:6];
    [self.bgView setborderWithBorderColor:KColorGray4 Width:1];
    self.infoLabel.text = KLocalizedString(@"use_keystore_import");
    self.descriptionLabel.text = KLocalizedString(@"use_keystore_import_hint");
    self.textView.zw_placeHolder = KLocalizedString(@"keystore_file_content");
    [self.introduceButton setTitle:KLocalizedString(@"what_is_keystore") forState:UIControlStateNormal];
    self.passwordTextField.placeholder = KLocalizedString(@"wallet_password");
    [self.addFileButton setTitle:[NSString stringWithFormat:@"  %@",KLocalizedString(@"add_keystore_file")] forState:UIControlStateNormal];
    [self.nextButton setTitle:KLocalizedString(@"next") forState:UIControlStateNormal];
    [self.nextButton setTouchEnable:NO];
    self.promptButton.hidden = YES;
    self.warnLabel.hidden = YES;
    self.showButton.selected = NO;
    if (iPhone5) {
        self.infoLabelTop.constant = 10;
        self.nextButtonBottom.constant = 10;
    }
}

#pragma mark - 监听
- (void)keyboardWillHide:(NSNotification *)sender
{
    if (self.importBlock) {
        self.importBlock();
    }
}

- (void)infoTextFieldTextChanged:(NSNotification *)sender
{
    UITextField *textField = (UITextField *)sender.object;
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self textVerify];
}

- (void)infoTextViewTextChanged:(NSNotification *)sender
{
    self.textView.text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self textVerify];
}

- (void)textVerify
{
    if (self.passwordTextField.text.length && self.textView.text.length) {
        [self.nextButton setTouchEnable:YES];
    }else {
        [self.nextButton setTouchEnable:NO];
    }
}

- (IBAction)selectFileButtonClick:(id)sender {
    SelectFileViewController *selectVC = [[SelectFileViewController alloc] init];
    selectVC.selctIndex = self.selctIndex;
    WS(weakSelf);
    selectVC.keystoreBlock = ^(KeyStoreModel * _Nullable model) {
        NSDictionary *dict = [model mj_keyValuesWithKeys:@[@"address",@"encryptedPrivateKey",@"alias",@"pubKey"]];
        model.time = @"";
        NSString *keystoreStr = [dict mj_JSONString];
        SS(strongSelf);
        strongSelf.textView.text = keystoreStr;
    };
    [self.navigationController pushViewController:selectVC animated:YES];
}


- (IBAction)showButtonClick:(id)sender {
    self.showButton.selected = !self.showButton.selected;
    self.passwordTextField.secureTextEntry = !self.showButton.selected;
}

- (IBAction)introduceButtonClick:(id)sender {
    CommonWebViewController *webVC = [[CommonWebViewController alloc] init];
    [webVC setDocType:DocumentTypeKeyStore];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)nextButtonClick:(id)sender {
    [self.textView resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    self.warnLabel.hidden = NO;
//    if (self.passwordTextField.text.length < 6) {
//        self.warnLabel.text = KLocalizedString(@"password_must_morethan_8");
//        return;
//    }
    self.warnLabel.hidden = YES;
    
    KeyStoreModel *model = [KeyStoreModel mj_objectWithKeyValues:self.textView.text];
    if (!model.address.length || !model.encryptedPrivateKey.length) {
        [self.view showNormalToast:KLocalizedString(@"keystore_exception")];
        return;
    }
    
    if (![model.address hasPrefix:PREFIX] && ![model.address hasPrefix:@"Ns"]) {
        [self.view showNormalToast:KLocalizedString(@"incorrect_address_format")];
        return;
    }
    
    NSString *privateKey = [WalletUtil decryptPrivateKey:model.encryptedPrivateKey password:self.passwordTextField.text];
    NSString *address = [WalletUtil getAddressWithPrivateKe:privateKey];
    if (![model.address hasPrefix:@"Ns"]) {
        if (![model.address isEqualToString:address]) {
            [self.view showNormalToast:KLocalizedString(@"password_error")];
            [self.view endEditing:YES];
            return;
        }
    }
    
    WalletModel *walletModel = [[WalletModel alloc] init];
    walletModel.address = address;
    walletModel.encryptPrivateKey = model.encryptedPrivateKey;
    walletModel.password = self.passwordTextField.text;
    walletModel.alias = model.alias;
    walletModel.privateKey = privateKey;
    
    SetWalletNameViewController *resultVC = [[SetWalletNameViewController alloc] init];
    resultVC.walletModel = walletModel;
    [self.navigationController pushViewController:resultVC animated:YES];
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
