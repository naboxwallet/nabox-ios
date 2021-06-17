//
//  BackUpChooseTypeViewController.m
//  NaboxWallet
//
//  Created by Admin on 2020/10/13.
//  Copyright © 2020 NaboxWallet. All rights reserved.
//

#import "BackUpChooseTypeViewController.h"
#import "BackupsPrivateKeyViewController.h"
#import "ImportWalletSuccessView.h"
#import "KeyStoreModel.h"
#import "CopyPrivateKeyViewController.h"
@interface BackUpChooseTypeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *privateButton;
@property (weak, nonatomic) IBOutlet UIButton *keystoreButton;

@property (nonatomic ,strong) NSString *mnemonicStr;
@property (nonatomic ,strong) NSString *privateKey;
@property (nonatomic ,strong) NSDictionary *walletDict;
@end

@implementation BackUpChooseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    backup_mnemonic_word
     self.navigationItem.title = KLocalizedString(@"backup_wallet");
    [self.privateButton setTitle:KLocalizedString(@"backup_personal_key") forState:UIControlStateNormal];
    [self.keystoreButton setTitle:KLocalizedString(@"buckup_keystore") forState:UIControlStateNormal];
     self.navigationItem.rightBarButtonItem = [self getBarbuttonItemWith:KLocalizedString(@"no_copy_code") titleColor:KColorPrimary withAction:@selector(skipBarButtonAction)];
    
    KShowHUD;
    // 在这里获取私钥对应各个链的地址
    self.mnemonicStr = [WalletUtil getMnemonicStr];
    self.privateKey = [WalletUtil getPrivateKeyWithMnemonic:self.mnemonicStr];
    NSString *privateKey = self.privateKey;
    NSString *address = [WalletUtil getAddressWithPrivateKe:privateKey];
    [WalletUtil getAddressDictWithPrivateKey:privateKey Callback:^(NSDictionary * _Nonnull addressDict) {
        self.walletModel.addressDict = addressDict;
        self.walletDict = [self.walletModel mj_keyValues];
         KHideHUD;
    }];
    NSString *publicKey = [WalletUtil getPublicKeyWithPrivateKey:privateKey];
    NSString *encryptPrivateKey = [WalletUtil encryptPrivateKey:privateKey password:self.walletModel.password];
    NSString *encryptMnemonic = [WalletUtil encryptMnemonic:self.mnemonicStr password:self.walletModel.password];
    self.walletModel.address = address;
    
    self.walletModel.publicKey = publicKey;
    self.walletModel.mnemonicStr = nil;
    self.walletModel.encryptMnemonic = encryptMnemonic;
    self.walletModel.encryptPrivateKey = encryptPrivateKey;
}
- (IBAction)private:(UIButton *)sender {
    
    BackupsPrivateKeyViewController *vc = [BackupsPrivateKeyViewController new];
    vc.walletModel = self.walletModel;
    vc.backupsType = BackupsTypePrivateKey;
    vc.privateKey = self.privateKey;
    vc.createWallet = true;
    vc.walletDict = self.walletDict;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)keystore:(UIButton *)sender {
    
    NSString *pubKey = [WalletUtil getPublicKeyWithPrivateKey:self.privateKey];
    KeyStoreModel *model = [[KeyStoreModel alloc] init];
    model.address = self.walletModel.address;
    model.alias = self.walletModel.alias;
    model.encryptedPrivateKey = self.walletModel.encryptPrivateKey;
    model.pubKey = pubKey;
    model.time = [NSDate stringWithDate:[NSDate date] format:@"yyyy-MM-dd hh:mm:ss"];
    
    CopyPrivateKeyViewController *vc = [CopyPrivateKeyViewController new];
    vc.createWallet = true;
    vc.keystoreModel = model;
    vc.isKeyStoreBackUp = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 暂不备份
- (void)skipBarButtonAction
{
    [UserDefaultsUtil saveNowWallet:self.walletDict];
    [UserDefaultsUtil saveToAllWallet:self.walletDict];
    
    ImportWalletSuccessView *importView = [ImportWalletSuccessView instanceView];
    importView.style = SheetStyleCreate;
    importView.result = 1;
    importView.resultBlock = ^(NSInteger result) {
        [AppDelegateTableBar showMain];
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
