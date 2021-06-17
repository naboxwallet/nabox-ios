//
//  ImportWalletSheetView.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "ImportWalletSheetView.h"

@interface ImportWalletSheetView ()
@property (strong, nonatomic) IBOutlet UIButton *keystoreButton;
@property (strong, nonatomic) IBOutlet UIButton *mnemonicButton;
@property (strong, nonatomic) IBOutlet UIButton *privatekeyButton;

@end

@implementation ImportWalletSheetView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.keystoreButton setCircleWithRadius:4];
    [self.mnemonicButton setCircleWithRadius:4];
    [self.privatekeyButton setCircleWithRadius:4];
    [self.keystoreButton setborderWithBorderColor:KColorPrimary Width:1];
    [self.mnemonicButton setborderWithBorderColor:KColorPrimary Width:1];
    [self.privatekeyButton setborderWithBorderColor:KColorPrimary Width:1];
    [self.keystoreButton setTitle:KLocalizedString(@"keystore_import") forState:UIControlStateNormal];
    [self.mnemonicButton setTitle:KLocalizedString(@"mnemonic_word_import") forState:UIControlStateNormal];
    [self.privatekeyButton setTitle:KLocalizedString(@"personal_key_import") forState:UIControlStateNormal];
    
}

- (IBAction)closeButtonClick:(id)sender {
    [self hideView];
}

- (IBAction)keystoreButtonClick:(id)sender {
    [self hideView];
    if (self.importBlock) {
        self.importBlock(1);
    }
}

- (IBAction)mnemonicButtonClick:(id)sender {
    [self hideView];
    if (self.importBlock) {
        self.importBlock(2);
    }
}

- (IBAction)privatekeyButtonClick:(id)sender {
    [self hideView];
    if (self.importBlock) {
        self.importBlock(3);
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
