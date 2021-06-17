//
//  ImportWalletSheetView.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "ExportWalletSheetView.h"

@interface ExportWalletSheetView ()
@property (strong, nonatomic) IBOutlet UIButton *keystoreButton;
@property (strong, nonatomic) IBOutlet UIButton *privatekeyButton;

@end

@implementation ExportWalletSheetView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.keystoreButton setCircleWithRadius:4];
    
    [self.privatekeyButton setCircleWithRadius:4];
    [self.keystoreButton setborderWithBorderColor:KColorPrimary Width:1];
    
    [self.privatekeyButton setborderWithBorderColor:KColorPrimary Width:1];
    [self.keystoreButton setTitle:KLocalizedString(@"buckup_keystore") forState:UIControlStateNormal];
    [self.privatekeyButton setTitle:KLocalizedString(@"backup_personal_key") forState:UIControlStateNormal];
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
