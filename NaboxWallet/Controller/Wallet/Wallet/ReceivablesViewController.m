//
//  ReceivablesViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "ReceivablesViewController.h"
#import "ZxingModel.h"

@interface ReceivablesViewController ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *qrcodeImageView;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UIButton *addressButton;
@property (strong, nonatomic) IBOutlet UIButton *pasteButton;

@property (nonatomic ,strong) ZxingModel *zxingModel;

@end

@implementation ReceivablesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = KColorPrimary;
    self.navigationItem.title = KLocalizedString(@"receivables");
//    self.zxingModel = [ZxingModel new];
//    if(self.otherAssetModel && self.otherAssetModel.tokenSymbol){
//         self.nameLabel.text = self.otherAssetModel.tokenSymbol;
//         self.zxingModel.address = self.otherAssetModel.contractAddress;
//         self.zxingModel.walletAddress = self.otherAssetModel.address;
//         self.zxingModel.coinName = self.otherAssetModel.tokenSymbol;
//         if(self.otherAssetModel.status==-1||self.otherAssetModel.status==3){
//              self.iconImageView.image = ImageNamed(@"token_nuls2");
//        }else{
//            if(self.otherAssetModel.iconUrl!=nil){
//                [self.iconImageView sd_setImageWithURL:KURL(self.otherAssetModel.iconUrl)];
//            }else{
//                self.iconImageView.image = ImageNamed(@"token_nuls2");
//            }
//        }
//         self.qrcodeImageView.image = [Common encodeQRImageWithContent:[[NSString alloc]initWithData:[self.zxingModel mj_JSONData] encoding:NSUTF8StringEncoding] withSize:162];
//    }
    
    NSString *imageName = [NSString stringWithFormat:@"logo_%@",self.chain];
     self.iconImageView.image = ImageNamed(imageName);
   self.qrcodeImageView.image = [Common encodeQRImageWithContent:self.addressStr withSize:162];
    [self.addressButton setTitle:self.addressStr forState:UIControlStateNormal];
    self.nameLabel.text = self.chain;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:KColorPrimary] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:KColorPrimary];
    self.showTitleIsWhite = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.lineView.width == KSCREEN_WIDTH - 50) {
        [self.lineView setCircleWithRadius:6];
        [self.lineView setImaginaryLineBorderWithColor:KColorGray2 Width:1];
//        [self.pasteButton setImaginaryLineBorderNoRadiusWithColor:KColorGray2 Width:1];
    }
}

- (IBAction)copyButtonClick:(id)sender {
    [KAppDelegate.window showNormalToast:KLocalizedString(@"copy_to_clipboard")];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.addressStr;
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
