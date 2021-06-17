//
//  CreateWalletTypeViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "CreateWalletTypeViewController.h"
#import "CreateWalletViewController.h"
#import "ImportWalletSheetView.h"
#import "ImportWalletViewController.h"
#import "ImportWalletRootViewController.h"

@interface CreateWalletTypeViewController ()
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIButton *createButton;
@property (strong, nonatomic) IBOutlet UILabel *createLabel;
@property (strong, nonatomic) IBOutlet UIView *createView;
@property (strong, nonatomic) IBOutlet UIButton *importButton;
@property (strong, nonatomic) IBOutlet UILabel *importLabel;
@property (strong, nonatomic) IBOutlet UIView *importView;
@property (strong, nonatomic) IBOutlet UIView *createBgView;
@property (strong, nonatomic) IBOutlet UIView *importBgView;

@end

@implementation CreateWalletTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateUI];
}


- (void)updateUI
{
    [self.view layoutIfNeeded];
    self.infoLabel.text = KLocalizedString(@"create_wallet");
    self.createLabel.text = KLocalizedString(@"add_wallet");
    self.importLabel.text = KLocalizedString(@"import_wallet");
    [self.createView setCircleWithRadius:2];
    [self.importView setCircleWithRadius:2];
    
    [self.createBgView setShadowWithOpacity:0.3 radius:6];
    [self.createButton setCircleWithRadius:6];
    [self.importBgView setShadowWithOpacity:0.3 radius:6];
    [self.importButton setCircleWithRadius:6];
    self.createButton.adjustsImageWhenHighlighted = NO;
    self.importButton.adjustsImageWhenHighlighted = NO;
}

- (IBAction)createWalletButtonClick:(id)sender {
    CreateWalletViewController *createVC = [[CreateWalletViewController alloc] init];
    
    [self.navigationController pushViewController:createVC animated:YES];
}

- (IBAction)importButtonClick:(id)sender {
    ImportWalletSheetView *importView = [ImportWalletSheetView instanceView];
    WS(weakSelf);
    importView.importBlock = ^(NSInteger tag) {
        [weakSelf importWalletType:tag];
    };
    [importView showInController:self preferredStyle:TYAlertControllerStyleActionSheet];
}

#pragma mark - 1~keystore,2~助记词，3~私钥
- (void)importWalletType:(NSInteger)type
{
    if (type == 1) {
        ImportWalletRootViewController *createVC = [[ImportWalletRootViewController alloc] init];
        
        [self.navigationController pushViewController:createVC animated:YES];
    }else if (type == 2) {
        ImportWalletViewController *createVC = [[ImportWalletViewController alloc] init];
        createVC.importType = ImportWalletTypeMnemonic;
        [self.navigationController pushViewController:createVC animated:YES];
    }else if (type == 3) {
        ImportWalletViewController *createVC = [[ImportWalletViewController alloc] init];
        createVC.importType = ImportWalletTypePrivateKey;
        [self.navigationController pushViewController:createVC animated:YES];
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
