//
//  MnemonicCollectionViewCell.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "MnemonicCollectionViewCell.h"

@implementation MnemonicCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.mnemonicLabel setCircleWithRadius:6];
    [self.mnemonicLabel setborderWithBorderColor:kColorBorder Width:1];
}

@end
