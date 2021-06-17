//
//  AccountChainListViewAccountCell.m
//  NaboxWallet
//
//  Created by Admin on 2021/4/5.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "AccountChainListViewAccountCell.h"

@implementation AccountChainListViewAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWalletModel:(WalletModel *)walletModel{
    _walletModel = walletModel;
    self.accountNameLabel.text = walletModel.alias;
    self.accountBalanceLable.text = [[GlobalVariable sharedInstance] getAssetsAmountWithNum:@(walletModel.totalBalance) andDecimals:2];
    if (walletModel.selected) {
        self.contentView.backgroundColor = KSetHEXColor(0xF9FAFC);
        self.accountNameLabel.textColor = KSetHEXColor(0x333333);
    }else{
        self.accountNameLabel.textColor = KSetHEXColor(0x8F95A8);
        self.contentView.backgroundColor = KSetHEXColor(0xF2F2F4);
    }
}

@end
