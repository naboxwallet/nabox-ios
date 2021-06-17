//
//  ContactViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactIconCollectionCell.h"
#import "SWQRCodeViewController.h"
#import "ChooseAssetsListView.h"
#import "FTPopOverMenu.h"
#import "CommonListView.h"
@interface ContactViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UIView *networkView;
@property (strong, nonatomic) IBOutlet UIImageView *chainIconImage;
@property (strong, nonatomic) IBOutlet UILabel *chainNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *networkTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *addressView;

@property (nonatomic ,strong) NSMutableArray *titleAndIconArr;
@property (nonatomic ,strong)ContactsModel* contactModel;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   self.navigationItem.title = KLocalizedString(@"add_new_contacts");
    self.contactModel = [ContactsModel new];
    self.networkTitleLabel.text = KLocalizedString(@"network");
    self.nameTF.placeholder = KLocalizedString(@"input_contacts_name");
    self.addressTF.placeholder = KLocalizedString(@"input_contacts_address");
    self.nameTitleLabel.text = KLocalizedString(@"name");
    self.addressTitleLabel.text = KLocalizedString(@"address");
    [self.submitButton setCircleWithRadius:4];
    [self.submitButton setTitle:KLocalizedString(@"complete") forState:UIControlStateNormal];
    
    [self.addressView setCircleWithRadius:6];
    [self.addressView setborderWithBorderColor:kColorBorder Width:1];
    [self.nameTF setCircleWithRadius:6];
    [self.nameTF setborderWithBorderColor:kColorBorder Width:1];
    [self.networkView setCircleWithRadius:6];
    [self.networkView setborderWithBorderColor:kColorBorder Width:1];
    self.addressTF.leftView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];;
    self.addressTF.leftViewMode = UITextFieldViewModeAlways;
    self.nameTF.leftView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];;
    self.nameTF.leftViewMode = UITextFieldViewModeAlways;
    
    // 默认NULS
    self.contactModel.chain = @"NULS";
    self.contactModel.iconName = @"logo_NULS";
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseChain)];
    [self.networkView addGestureRecognizer:tapGesture];
    
    if (self.toAddress) {
        self.addressTF.text = self.toAddress;
    }
//    self.addressTF.text = @"TNVTdTSPHe3tarnBkTqukNgrBihpfotpTat4i";
    
//        self.addressTF.text = @"0x8f404078E5E3A7de8502dc4544805bC0eEbccc6E";
//        self.addressTF.text = @"tNULSeBaMt9Tf6VvfYfvUFGVqdiyPqFLfQg9La";
    //    self.addressTF.text = @"0x1F0518A1F11195e4518F1615948Fd87B4f433EE1";
//    self.addressTF.text = @"tNULSeBaMgEfD7ZLQSnxY56SaVLQeKfNKgJgpY";
}

/** 选择网络类型 */
- (IBAction)chainChooseViewTap:(UITapGestureRecognizer *)sender
{
    WS(weakSelf);
    FTPopOverMenuConfiguration *configuration = [self getMenuConfiguration];
    [FTPopOverMenu showForSender:self.chainIconImage
                   withMenuArray:self.titleAndIconArr[0]
                      imageArray:self.titleAndIconArr[1]
                   configuration:configuration
                       doneBlock:^(NSInteger selectedIndex) {
                           SS(strongSelf);
                           NSString *chainName = self.titleAndIconArr[0][selectedIndex];
                           NSString *iconName = self.titleAndIconArr[1][selectedIndex];
                           strongSelf.contactModel.iconName = iconName;
                           strongSelf.contactModel.chain = chainName;
                           strongSelf.chainIconImage.image = ImageNamed(iconName);
                           strongSelf.chainNameLabel.text = chainName;
                       } dismissBlock:nil];
    
    
}

- (void)chooseChain{
//    ChooseAssetsListView *assetsListView = [ChooseAssetsListView instanceView];
//    [assetsListView showInController:self preferredStyle:TYAlertControllerStyleActionSheet];
//    WS(weakSelf);
//    assetsListView.selectBlock = ^(NSString * _Nullable chainName, NSString * _Nullable iconName) {
//        SS(strongSelf);
//        strongSelf.contactModel.iconName = iconName;
//        strongSelf.contactModel.chain = chainName;
//        strongSelf.chainIconImage.image = ImageNamed(iconName);
//        strongSelf.chainNameLabel.text = chainName;
//    };
    [self.addressTF becomeFirstResponder];
    CommonListView *assetsListView = [CommonListView instanceView];
    assetsListView.titleLabel.text = KLocalizedString(@"chooseNetwork");
    assetsListView.dataSource = self.titleAndIconArr[0];
    [assetsListView showInController:self preferredStyle:TYAlertControllerStyleActionSheet];
    WS(weakSelf);
    assetsListView.selectBlock = ^(NSString * _Nullable name, NSInteger index) {
        SS(strongSelf);
        NSString *imageName = self.titleAndIconArr[1][index];
        strongSelf.contactModel.iconName = imageName;
        strongSelf.contactModel.chain = name;
        strongSelf.chainIconImage.image = ImageNamed(imageName);
        strongSelf.chainNameLabel.text = name;
    };
}


- (IBAction)scanAction:(UIButton *)sender {
    SWQRCodeViewController *qrCodeVC = [[SWQRCodeViewController alloc] init];
    SWQRCodeConfig *config = [[SWQRCodeConfig alloc]init];
    config.scannerType = SWScannerTypeQRCode;
    qrCodeVC.codeConfig = config;
    qrCodeVC.title = @"扫码";
    WS(weakSelf);
    qrCodeVC.resultBlock = ^(NSString *result) {
        SS(strongSelf);
        if (![ChainUtil isNulsAddress:result] && ![ChainUtil isNerveAddress:result] && ![ChainUtil isHeterAddress:result]) {
            [KAppDelegate.window showNormalToast:KLocalizedString(@"address_error")];
            return;
        }
        strongSelf.addressTF.text = result;
    };
    [qrCodeVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:qrCodeVC animated:YES];
}
- (IBAction)subnmitAction:(UIButton *)sender {
    if (self.nameTF.text.length == 0) {
        return [KAppDelegate.window showNormalToast:KLocalizedString(@"input_contacts_name")];
    }
    NSString *address = self.addressTF.text;
    if (address.length == 0) {
        return [KAppDelegate.window showNormalToast:KLocalizedString(@"input_contacts_address")];
    }
    if (![ChainUtil isNulsAddress:address] && ![ChainUtil isNerveAddress:address] && ![ChainUtil isHeterAddress:address]) {
        [KAppDelegate.window showNormalToast:KLocalizedString(@"address_error")];
        return;
    }
    self.contactModel.name = self.nameTF.text;
    self.contactModel.address = self.addressTF.text;
    [ContactsUtil addContacts:self.contactModel];
    NSLog(KLocalizedString(@"add_contacts_success"));
    if (self.block) {
        self.block();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableArray *)titleAndIconArr
{
    if (!_titleAndIconArr) {
        _titleAndIconArr = [NSMutableArray array];
        NSArray *titleArr= @[@"Ethereum",@"NULS",@"NERVE",@"BSC",@"Heco"];
        NSArray *iconArr = @[@"logo_Ethereum",@"logo_NULS",@"logo_NERVE",@"logo_BSC",@"logo_Heco"];
        [_titleAndIconArr addObject:titleArr];
        [_titleAndIconArr addObject:iconArr];
    }
    return _titleAndIconArr;
}

/** 获取通用配置 */
- (FTPopOverMenuConfiguration *)getMenuConfiguration
{
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuWidth = 150.f;
    configuration.backgroundColor = KColorWhite;
    configuration.borderColor = kColorBorder;
    configuration.textColor = KColorBlack;
    configuration.separatorColor = kColorLine;
    configuration.selectedCellBackgroundColor = KColorBg;
    configuration.textAlignment = NSTextAlignmentLeft;
    return configuration;
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
