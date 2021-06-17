//
//  AccountChainListViewChainCell.m
//  NaboxWallet
//
//  Created by Admin on 2021/4/5.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "AccountChainListViewChainCell.h"

@implementation AccountChainListViewChainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.selectedView setborderWithBorderColor:KColorSkin1 Width:2];
    [self.selectedView setCircle];
    

    self.shadowView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.shadowView.layer.cornerRadius = 6;
    self.shadowView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(0,0);
    self.shadowView.layer.shadowOpacity = 1;
    self.shadowView.layer.shadowRadius = 16;
    
    [self.bgView setCircleWithRadius:6];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWalletChainModel:(WalletChainModel *)walletChainModel{
    _walletChainModel = walletChainModel;
    [self.iconImageView sd_setImageWithURL:KURL(walletChainModel.icon)];
//    [self.iconImageView sd_setImageWithURL:KURL(AliyunImageUrl(walletChainModel.symbol)) placeholderImage:ImageNamed(@"default_pic")];
    self.chainLabel.text = walletChainModel.chain;
    self.balanceLabel.text = [NSString stringWithFormat:@"≈%@",[[GlobalVariable sharedInstance] getAssetsAmountWithNum:walletChainModel.price andDecimals:2]];
    self.addressLabel.text = walletChainModel.address;
}
- (IBAction)copyClickAction:(UIButton *)sender {
    [KAppDelegate.window showNormalToast:KLocalizedString(@"copy_to_clipboard")];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.walletChainModel.address;
}

@end
