//
//  ExportWalletViewController.m
//  NaboxWallet
//
//  Created by Admin on 2020/9/30.
//  Copyright © 2020 NaboxWallet. All rights reserved.
//

#import "ExportWalletViewController.h"
#import "ExportWalletSheetView.h"
#import "BackupsPrivateKeyViewController.h"
@interface ExportWalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ExportWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoTextFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateUI
{
    self.infoLabel.text = self.code;
    [self.infoLabel setborderWithBorderColor:kColorBorder Width:1];
    [self.infoLabel setCircleWithRadius:6];
    self.passwordTextField.placeholder = KLocalizedString(@"wallet_password");
     [self.passwordTextField setborderWithBorderColor:kColorBorder Width:1];
    [self.passwordTextField setCircleWithRadius:4];
    [self.nextButton setTitle:KLocalizedString(@"next") forState:UIControlStateNormal];
    [self.nextButton setTouchEnable:NO];
}

#pragma mark - 监听
- (void)keyboardWillHide:(NSNotification *)sender
{
//    if (self.importBlock) {
//        self.importBlock();
//    }
}

- (void)infoTextFieldTextChanged:(NSNotification *)sender
{
    UITextField *textField = (UITextField *)sender.object;
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self textVerify];
}

- (void)textVerify
{
    if (self.passwordTextField.text.length && self.code) {
        [self.nextButton setTouchEnable:YES];
    }else {
        [self.nextButton setTouchEnable:NO];
    }
}

- (IBAction)next:(UIButton *)sender {
    NSDictionary *dic  =  [self.code mj_JSONObject];
    NSString *encryptPrivateKey = [dic objectForKey:@"encryptedPrivateKey"];
    NSString *address = [dic objectForKey:@"address"];
    NSString *password = self.passwordTextField.text;
    NSString *privateKey = [WalletUtil decryptPrivateKey:encryptPrivateKey password:password];
    if (![privateKey isHaveValue]) {
        [self.view showNormalToast:KLocalizedString(@"password_error")];
        return;
    }
    ExportWalletSheetView *importView = [ExportWalletSheetView instanceView];
    importView.importBlock = ^(NSInteger tag) {
        if (tag == 3) {
            BackupsPrivateKeyViewController *backupsVC = [[BackupsPrivateKeyViewController alloc] init];
            backupsVC.backupsType = BackupsTypePrivateKey;
            backupsVC.privateKey = privateKey;
            [self.navigationController pushViewController:backupsVC animated:YES];
        }else if (tag == 1){
            BackupsPrivateKeyViewController *backupsVC = [[BackupsPrivateKeyViewController alloc] init];
            backupsVC.backupsType = BackupsTypeKeyStore;
            WalletModel *walletModel = [WalletModel new];
            walletModel.address = address;
            walletModel.alias = @"";
            walletModel.encryptPrivateKey = encryptPrivateKey;
            backupsVC.walletModel = walletModel;
            backupsVC.privateKey = privateKey;
            [self.navigationController pushViewController:backupsVC animated:YES];
        }
    };
    [importView showInController:self preferredStyle:TYAlertControllerStyleActionSheet];
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
