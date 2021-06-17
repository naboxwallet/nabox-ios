//
//  WalletCardTableViewCell.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "HomeCardTableViewCell.h"
#import "WalletChainModel.h"
@interface HomeCardTableViewCell ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *skinImageView;
@property (strong, nonatomic) IBOutlet UILabel *totalAssetsLabel;
@property (strong, nonatomic) IBOutlet UILabel *assetsNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *addressButton;
@property (strong, nonatomic) IBOutlet UIButton *qrcodeButton;
@property (strong, nonatomic) IBOutlet UIButton *selfChainTradeButton;
@property (strong, nonatomic) IBOutlet UIButton *crossChainTradeButton;
@property (strong, nonatomic) IBOutlet UIButton *detailButton;


@end

@implementation HomeCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
//    self.bgView.layer.cornerRadius = 6.f;
//    self.bgView.layer.masksToBounds = NO;
//    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.bgView.layer.shadowOffset = CGSizeMake(0.f, -0.5f);
//    self.bgView.layer.shadowOpacity = 0.4f;
//    self.bgView.layer.shadowRadius = 1.0f;
    
    self.totalAssetsLabel.text = KLocalizedString(@"total_assets");
    
    
      self.selfChainTradeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [self.selfChainTradeButton setTitle:KLocalizedString(@"cross_chain_trade") forState:UIControlStateNormal];
    
      self.crossChainTradeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [self.crossChainTradeButton setTitle:KLocalizedString(@"transfer_accounts") forState:UIControlStateNormal];
    [self.detailButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:2];
    [self.detailButton setTitle:KLocalizedString(@"detail") forState:UIControlStateNormal];
}

- (void)setHidenQRCode:(BOOL)hidenQRCode
{
    _hidenQRCode = hidenQRCode;
    self.qrcodeButton.hidden = hidenQRCode;
}

- (void)setWalletModel:(WalletModel *)walletModel
{
    _walletModel = walletModel;
    NSString *imageName = [Common getWalletDataWithType:1 index:walletModel.colorIndex.integerValue];
    self.skinImageView.image = ImageNamed(imageName);
    NSString *address = [walletModel.addressDict objectForKey: walletModel.chain];
    [self.addressButton setTitle:address forState:UIControlStateNormal];
    self.addressButton.titleLabel.layer.shadowColor = KSetHEXColorWithAlpha(0x000000,0.1).CGColor;
    self.addressButton.titleLabel.layer.shadowRadius = 5;
    self.addressButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 2);
}

- (void)setAsset:(NSNumber*)asset{
//     self.assetsNumLabel.text = [NSString stringWithFormat:@"$%@",asset];
    self.assetsNumLabel.text = [[GlobalVariable sharedInstance] getAssetsAmountWithNum:asset andDecimals:2 ];
}

- (IBAction)qrcodeButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(walletCardDidSelect:index:)]) {
        [self.delegate walletCardDidSelect:0 index:self.selectIdex];
    }
}


- (IBAction)addressButtonClick:(id)sender {
    [KAppDelegate.window showNormalToast:KLocalizedString(@"copy_to_clipboard")];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *address = [self.walletModel.addressDict objectForKey: self.walletModel.chain];
    pasteboard.string = address;
}

- (IBAction)selfChainTradeAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(walletCardDidSelect:index:)]) {
        [self.delegate walletCardDidSelect:1 index:self.selectIdex];
    }
}
- (IBAction)crossChainTradeAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(walletCardDidSelect:index:)]) {
        [self.delegate walletCardDidSelect:2 index:self.selectIdex];
    }
}
- (IBAction)detailButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(walletCardDidSelect:index:)]) {
        [self.delegate walletCardDidSelect:3 index:self.selectIdex];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
