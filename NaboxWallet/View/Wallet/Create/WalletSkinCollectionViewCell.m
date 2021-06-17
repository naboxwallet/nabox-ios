//
//  WalletSkinCollectionViewCell.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "WalletSkinCollectionViewCell.h"

@implementation WalletSkinCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 6.f;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.f, 1.f);
    self.layer.shadowOpacity = 0.4f;
    self.layer.shadowRadius = 3.f;
//    [self.skinImageView setCircleWithRadius:6];
}

@end
