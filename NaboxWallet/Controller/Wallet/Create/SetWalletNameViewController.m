//
//  SetWalletNameViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "SetWalletNameViewController.h"
#import "SelectSkinViewController.h"
#import "WalletFinishViewController.h"
@interface SetWalletNameViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation SetWalletNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateUI];
}

- (void)updateUI
{
    self.nameTextField.text = self.walletModel.alias;
    self.navigationItem.title = KLocalizedString(@"import_wallet");
    self.infoLabel.text = KLocalizedString(@"name_the_import_wallet");
    self.descriptionLabel.text = KLocalizedString(@"hd_wallet_donot_save_alisa");
    self.nameTextField.placeholder = KLocalizedString(@"wallet_name");
    [self.nextButton setTitle:KLocalizedString(@"next") forState:UIControlStateNormal];
    self.nameTextField.delegate = self;
    
    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)textFieldDidChange:(UITextField *)textField{
  [Common strLengthLimitWithTextField:textField maxLength:12];
}

- (IBAction)nextButtonClick:(id)sender {
    self.walletModel.alias = self.nameTextField.text;
    self.walletModel.alias = [self.walletModel.alias stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!self.walletModel.alias.length) {
        [self.nameTextField resignFirstResponder];
        [self.view showNormalToast:KLocalizedString(@"please_input_wallet_name")];
        return;
    }
//    SelectSkinViewController *skinVC = [[SelectSkinViewController alloc] init];
//    skinVC.skinType = SelectSkinTypeImport;
//    skinVC.walletModel = self.walletModel;
//    [self.navigationController pushViewController:skinVC animated:YES];
    
    WalletFinishViewController *resultVC = [[WalletFinishViewController alloc] init];
    resultVC.walletModel = self.walletModel;
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
