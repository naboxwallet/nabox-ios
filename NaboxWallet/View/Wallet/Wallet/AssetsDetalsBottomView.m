//
//  AssetsDetalsBottomView.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "AssetsDetalsBottomView.h"

@implementation AssetsDetalsBottomView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self.receivablesButton setTitle:KLocalizedString(@"cross_chain_trade") forState:UIControlStateNormal];
    [self.transferButton setTitle:KLocalizedString(@"transfer_accounts") forState:UIControlStateNormal];
//    if (iPhone5) {
//        self.buttonWidth.constant = (KSCREEN_WIDTH - 20 - 20) / 2;
//    }
    self.buttonWidth.constant = (KSCREEN_WIDTH - 20 - 20) / 2;
}

- (IBAction)receivablesButtonClick:(id)sender {
    if (self.tradingBlock) {
        self.tradingBlock(0);
    }
}

- (IBAction)transferButtonClick:(id)sender {
    if (self.tradingBlock) {
        self.tradingBlock(1);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
