//
//  CopyPrivateKeyViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//  拷贝私钥或者keystore页面

#import "CopyPrivateKeyViewController.h"
#import "ImportWalletSuccessView.h"
@interface CopyPrivateKeyViewController ()
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *warnLabel;
@property (strong, nonatomic) IBOutlet UILabel *warn1Label;
@property (strong, nonatomic) IBOutlet UILabel *warn2Label;
@property (strong, nonatomic) IBOutlet UILabel *privatekeyTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *privatekeyLabel;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIButton *finishButton;

@end

@implementation CopyPrivateKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateUI];
    
}

- (void)updateUI
{
    [self.confirmButton setTouchEnable:YES];
    [self.finishButton setTouchEnable:YES];
    [self.finishButton setTitle:KLocalizedString(@"backup_completed") forState:UIControlStateNormal];
    
    if (self.isKeyStoreBackUp) {
        self.privatekeyLabel.text = [self.keystoreModel mj_JSONString];
            self.navigationItem.title = KLocalizedString(@"buckup_keystore");
        self.infoLabel.text = KLocalizedString(@"buckup_keystore");
        
            NSArray *warnArr = [KLocalizedString(@"backup_keystore_hint") componentsSeparatedByString:@"ll"];
            self.warnLabel.text = KLocalizedString(@"warning");
            self.warn1Label.text = [warnArr firstObject];
             self.warn2Label.text = [warnArr lastObject];
        self.privatekeyTitleLabel.text = KLocalizedString(@"keystore");
        [self.confirmButton setTitle:KLocalizedString(@"copy_keystore") forState:UIControlStateNormal];
    }else{
        self.privatekeyLabel.text = self.privateKey;
        self.navigationItem.title = KLocalizedString(@"backup_personal_key");
        self.infoLabel.text = KLocalizedString(@"copy_personal_key");
        self.warnLabel.text = KLocalizedString(@"warning");
        NSArray *warnArr = [KLocalizedString(@"copy_personal_key_warning") componentsSeparatedByString:@"ll"];
        self.warn1Label.text = [warnArr firstObject];
        self.warn2Label.text = [warnArr lastObject];
        self.privatekeyTitleLabel.text = KLocalizedString(@"personal_key");
        
        [self.confirmButton setTitle:KLocalizedString(@"copy_personal_key") forState:UIControlStateNormal];
    }
    
}

// 复制
- (IBAction)confirmButtonClick:(id)sender {
    if (self.isKeyStoreBackUp) {
        [UserDefaultsUtil saveToAllKeyStore:self.keystoreModel.mj_keyValues];
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.privatekeyLabel.text;
    }
    
    [self.confirmButton setTouchEnable:NO];
    [self.confirmButton setTitle:KLocalizedString(@"already_copy") forState:UIControlStateNormal];
}

// 点击备份
- (IBAction)completeBackUp:(UIButton *)sender {
    if (self.createWallet) {
        [UserDefaultsUtil saveNowWallet:self.walletDict];
        [UserDefaultsUtil saveToAllWallet:self.walletDict];
        ImportWalletSuccessView *importView = [ImportWalletSuccessView instanceView];
        importView.style = SheetStyleCreate;
        importView.result = 1;
        importView.resultBlock = ^(NSInteger result) {
            [AppDelegateTableBar showMain];
        };
        [importView showInController:self preferredStyle:TYAlertControllerStyleActionSheet];
    }else{
        [AppDelegateTableBar showMain];
    }
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
