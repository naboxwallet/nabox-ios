//
//  WalletSetTableViewCell.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "WalletSetTableViewCell.h"

@implementation WalletSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    self.skinButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    self.nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.skinButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.nameButton setTitle:KLocalizedString(@"wallet_name") forState:UIControlStateNormal];
    [self.skinButton setTitle:KLocalizedString(@"modify_the_skin") forState:UIControlStateNormal];
    [self.bgView setCircleAndShadowWithRadius:6];
}


- (IBAction)nameButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(walletSetDidSelect:)]) {
        [self.delegate walletSetDidSelect:0];
    }
}

- (IBAction)skinBUttonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(walletSetDidSelect:)]) {
        [self.delegate walletSetDidSelect:1];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
