//
//  BackupsPrivateKeyViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//  备份私钥警告页面

#import "BackupsPrivateKeyViewController.h"
#import "CopyPrivateKeyViewController.h"
#import "ImportWalletSuccessView.h"
#import "KeyStoreModel.h"

@interface BackupsPrivateKeyViewController ()
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *warnLabel;
@property (strong, nonatomic) IBOutlet UILabel *warn1Label;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIButton *finishButton;

@end

@implementation BackupsPrivateKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateUI];
}

- (void)updateUI
{
    if (self.backupsType == BackupsTypePrivateKey) {
        self.navigationItem.title = KLocalizedString(@"backup_personal_key");
        NSArray *warnArr = [KLocalizedString(@"warning_content") componentsSeparatedByString:@"ll"];
        self.warnLabel.text = [warnArr firstObject];
        self.warn1Label.text = [warnArr lastObject];
        self.finishButton.hidden = YES;
    }else if (self.backupsType == BackupsTypeKeyStore) {
        self.navigationItem.title = KLocalizedString(@"buckup_keystore");
        NSArray *warnArr = [KLocalizedString(@"backup_keystore_hint") componentsSeparatedByString:@"ll"];
        self.warnLabel.text = [warnArr firstObject];
        self.warn1Label.text = [warnArr lastObject];
        [self.finishButton setTitle:KLocalizedString(@"backup_completed") forState:UIControlStateNormal];
    }
    
    self.infoLabel.text = KLocalizedString(@"warning");
    [self.confirmButton setTitle:KLocalizedString(@"know_danger_next") forState:UIControlStateNormal];
}


- (IBAction)confirmButtonClick:(id)sender {
    if (self.backupsType == BackupsTypePrivateKey) {
        CopyPrivateKeyViewController *copyVC = [[CopyPrivateKeyViewController alloc] init];
        copyVC.privateKey = self.privateKey;
        copyVC.createWallet = self.createWallet;
        copyVC.walletDict = self.walletDict;
        [self.navigationController pushViewController:copyVC animated:YES];
    }else if (self.backupsType == BackupsTypeKeyStore) {
        NSString *pubKey = [WalletUtil getPublicKeyWithPrivateKey:self.privateKey];
        KeyStoreModel *model = [[KeyStoreModel alloc] init];
        model.address = self.walletModel.address;
        model.alias = self.walletModel.alias;
        model.encryptedPrivateKey = self.walletModel.encryptPrivateKey;
        model.pubKey = pubKey;
        model.time = [NSDate stringWithDate:[NSDate date] format:@"yyyy-MM-dd hh:mm:ss"];

        [UserDefaultsUtil saveToAllKeyStore:model.mj_keyValues];
        [self.confirmButton setTouchEnable:NO];
        [self.view showNormalToast:KLocalizedString(@"backup_completed")];
    }
}

// 完成keystore备份 如果是新建需保存钱包
- (IBAction)finishAction:(UIButton *)sender {
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
