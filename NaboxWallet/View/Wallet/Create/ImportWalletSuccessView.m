//
//  ImportWalletSuccessView.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "ImportWalletSuccessView.h"

@implementation ImportWalletSuccessView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.infoLabel.text = KLocalizedString(@"import_success");
}

- (void)setResult:(NSInteger)result
{
    _result = result;
    if (self.style == SheetStyleImportWallet) {
        if (!result) {
            self.infoLabel.text = KLocalizedString(@"import_fail");
            self.iconImageView.image = ImageNamed(@"icon_fail");
        }else if (result == 1) {
            self.infoLabel.text = KLocalizedString(@"import_success");
            self.iconImageView.image = ImageNamed(@"icon_succ");
        }
    }else if (self.style == SheetStyleTransfer) {
        if (!result) {
            self.infoLabel.text = KLocalizedString(@"transaction_fail");
            self.iconImageView.image = ImageNamed(@"icon_fail");
        }else if (result == 1) {
            self.infoLabel.text = KLocalizedString(@"transaction_success");
            self.iconImageView.image = ImageNamed(@"icon_succ");
        }
    }else if (self.style == SheetStyleBackup) {
        self.infoLabel.text = KLocalizedString(@"backup_success");
        self.iconImageView.image = ImageNamed(@"icon_succ");
    }else if (self.style == SheetStyleCreate) {
        self.infoLabel.text = KLocalizedString(@"create_wallet_success");
        self.iconImageView.image = ImageNamed(@"icon_succ");
    }else if (self.style == SheetStyleJoinConsensus) {
        self.infoLabel.text = KLocalizedString(@"submit_consensus");
        self.iconImageView.image = ImageNamed(@"icon_succ");
    }else if (self.style == SheetStyleNaboxPay) {
        if (!result) {
            self.infoLabel.text = KLocalizedString(@"order_fail");
            self.iconImageView.image = ImageNamed(@"icon_fail");
        }else if (result == 1) {
            self.infoLabel.text = KLocalizedString(@"order_success");
            self.iconImageView.image = ImageNamed(@"icon_succ");
        }
    }
    
    
}

- (IBAction)confirmButtonClick:(id)sender {
    [self hideView];
    if (self.successBlock) {
        self.successBlock();
    }
    if (self.resultBlock) {
        self.resultBlock(self.result);
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
