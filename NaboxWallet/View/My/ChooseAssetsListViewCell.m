//
//  ChooseAssetsListViewCell.m
//  NaboxWallet
//
//  Created by Admin on 2021/2/27.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "ChooseAssetsListViewCell.h"

@implementation ChooseAssetsListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImage.userInteractionEnabled = NO;
    self.iconNameLabel.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
