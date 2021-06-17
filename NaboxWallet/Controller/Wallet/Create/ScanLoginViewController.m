//
//  ScanLoginViewController.m
//  NaboxWallet
//
//  Created by Admin on 2020/9/29.
//  Copyright © 2020 NaboxWallet. All rights reserved.
//

#import "ScanLoginViewController.h"

@interface ScanLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *aa;

@end

@implementation ScanLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = KLocalizedString(@"login_confirmation");
    [self.aa setTitle:KLocalizedString(@"login_confirmation") forState:UIControlStateNormal];
    
}
- (IBAction)login:(UIButton *)sender {
    WalletModel *walletModel = [WalletModel mj_objectWithKeyValues:[UserDefaultsUtil getNowWallet]];
    BasePublicModel *dataModel = [BasePublicModel new];
    dataModel.params = @{@"key":self.send,@"value":@{@"address":walletModel.address,@"terminal":@"Nabox"}};
    [NetUtil requestWithMethod:PUBLIC_API_SCAN_IMPORT dataModel:dataModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        if (success) {
            [self.view showNormalToast:KLocalizedString(@"login_success")];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.view showNormalToast:KLocalizedString(@"login_fail")];
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
