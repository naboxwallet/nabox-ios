//
//  WalletBackupsTableViewCell.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "WalletBackupsTableViewCell.h"

@interface WalletBackupsTableViewCell ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *mnemonicButton;
@property (strong, nonatomic) IBOutlet UIButton *privateKeyButton;
@property (strong, nonatomic) IBOutlet UIButton *keystoreButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *privatekeyButtonTop;
@property (strong, nonatomic) IBOutlet UIView *shadowBgView;

@end

@implementation WalletBackupsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bgView setCircleWithRadius:6];
    [self.shadowBgView setCircleAndShadowWithRadius:6];
    self.mnemonicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.privateKeyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.keystoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.mnemonicButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    self.privateKeyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    self.keystoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.mnemonicButton setTitle:KLocalizedString(@"backup_mnemonics") forState:UIControlStateNormal];
    [self.privateKeyButton setTitle:KLocalizedString(@"backup_personal_key") forState:UIControlStateNormal];
    [self.keystoreButton setTitle:KLocalizedString(@"buckup_keystore") forState:UIControlStateNormal];
}

- (void)setShowMnemonic:(BOOL)showMnemonic
{
    _showMnemonic = showMnemonic;
    self.privatekeyButtonTop.constant = showMnemonic ? 58 : 5;
}

- (IBAction)mnemonicButtonClick:(id)sender {
    [self setDelegateWithType:0];
}

- (IBAction)privatekeyButtonClick:(id)sender {
    [self setDelegateWithType:1];
}

- (IBAction)keyStoreButtonClick:(id)sender {
    [self setDelegateWithType:2];
}

- (void)setDelegateWithType:(NSInteger)type
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(walletBackupsDidSelect:)]) {
        [self.delegate walletBackupsDidSelect:type];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
