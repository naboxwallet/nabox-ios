//
//  WalletFinishViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "WalletFinishViewController.h"
#import "ImportWalletSuccessView.h"
#import "SyncWalletWithDeviceModel.h"
@interface WalletFinishViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *skinImageView;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalAssetsLabel;

@end

@implementation WalletFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateUI];
    [self createWallet];
    
}

- (void)updateUI
{
    self.navigationItem.title = KLocalizedString(@"import_wallet");
    self.totalAssetsLabel.text = KLocalizedString(@"total_assets");
    [self.backButton setborderWithBorderColor:KColorPrimary Width:1];
    [self.nextButton setTitle:KLocalizedString(@"complete") forState:UIControlStateNormal];
    [self.backButton setTitle:KLocalizedString(@"return_modification") forState:UIControlStateNormal];
    
    self.nameLabel.text = self.walletModel.alias;
    self.skinImageView.image = ImageNamed([Common getWalletDataWithType:1 index:self.walletModel.colorIndex.integerValue]);
}

- (void)createWallet{
    NSString *privateKey = [NSString string];
    if (self.walletModel.mnemonicStr) {
        privateKey = [WalletUtil getPrivateKeyWithMnemonic:self.walletModel.mnemonicStr];
    }else if (self.walletModel.privateKey) {
        privateKey = self.walletModel.privateKey;
    }else if (self.walletModel.privateKey) {
        
    }
    if (![privateKey isHaveValue]) {
        [self.view showNormalToast:KLocalizedString(@"privatekey_exception")];
        return;
    }
    KShowHUD;
    NSString *address = [WalletUtil getAddressWithPrivateKe:privateKey];
    NSString *publicKey = [WalletUtil getPublicKeyWithPrivateKey:privateKey];
    NSString *encryptPrivateKey = [WalletUtil encryptPrivateKey:privateKey password:self.walletModel.password];
    NSString *encryptMnemonic = [WalletUtil encryptMnemonic:self.walletModel.mnemonicStr password:self.walletModel.password];
    [WalletUtil getAddressDictWithPrivateKey:privateKey Callback:^(NSDictionary * _Nonnull addressDict) {
        self.walletModel.addressDict = addressDict;
        KHideHUD;
    }];
    self.walletModel.address = address;
    self.walletModel.publicKey = publicKey;
    self.walletModel.encryptPrivateKey = encryptPrivateKey;
    self.walletModel.encryptMnemonic = encryptMnemonic;
}

#pragma mark - 创建钱包
- (IBAction)nextButtonClick:(id)sender {
    NSMutableDictionary *walletDict = [self.walletModel mj_keyValues];
    [UserDefaultsUtil saveNowWallet:walletDict];
    [UserDefaultsUtil saveToAllWallet:walletDict];
    ImportWalletSuccessView *importView = [ImportWalletSuccessView instanceView];
    importView.style = SheetStyleImportWallet;
    importView.result = 1;
    importView.resultBlock = ^(NSInteger result) {
        [AppDelegateTableBar showMain];
    };
    [importView showInController:self preferredStyle:TYAlertControllerStyleActionSheet];
}



- (IBAction)backAndSetButtonClick:(id)sender {
    [self goBack];
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
