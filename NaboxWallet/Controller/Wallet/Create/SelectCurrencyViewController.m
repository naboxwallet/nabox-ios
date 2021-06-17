//
//  SelectCurrencyViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "SelectCurrencyViewController.h"
#import "CreateWalletTypeViewController.h"

@interface SelectCurrencyViewController ()
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIButton *usdButton;
@property (strong, nonatomic) IBOutlet UIButton *rmbButton;
@property (strong, nonatomic) IBOutlet UIButton *usdSelectButton;
@property (strong, nonatomic) IBOutlet UIButton *rmbSelectButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation SelectCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)updateUI
{
    self.infoLabel.text = KLocalizedString(@"choice_currency");
    self.usdButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.rmbButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.nextButton setTitle:KLocalizedString(@"next") forState:UIControlStateNormal];
    [self showButtonStatusType:0];
    [UserDefaultsUtil saveValue:@"USD" forKey:KEY_CURRENCY];
}

- (IBAction)nextButtonClick:(id)sender {
    CreateWalletTypeViewController *createWalletTypeVC = [[CreateWalletTypeViewController alloc] init];
    [self.navigationController pushViewController:createWalletTypeVC animated:YES];
}


- (IBAction)usdButtonClick:(id)sender {
    [self showButtonStatusType:0];
    [UserDefaultsUtil saveValue:@"USD" forKey:KEY_CURRENCY];
}

- (IBAction)rmbButtonClick:(id)sender {
    [self showButtonStatusType:1];
    [UserDefaultsUtil saveValue:@"RMB" forKey:KEY_CURRENCY];
}


- (void)showButtonStatusType:(NSInteger)type
{
    self.usdButton.selected = !type;
    self.rmbButton.selected = type;
    self.usdSelectButton.selected = self.usdButton.selected;
    self.rmbSelectButton.selected = self.rmbButton.selected;
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
