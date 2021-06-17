//
//  AddAddressPopView.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "AddAddressPopView.h"

@interface AddAddressPopView ()
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *addresslabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation AddAddressPopView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setCircleWithRadius:6];
    [self.cancelButton setborderWithBorderColor:KColorPrimary Width:1];
    self.infoLabel.text = KLocalizedString(@"no_addr");
    [self.cancelButton setTitle:KLocalizedString(@"cancel") forState:UIControlStateNormal];
    [self.confirmButton setTitle:KLocalizedString(@"sure") forState:UIControlStateNormal];
}

- (void)setToAddress:(NSString *)toAddress
{
    _toAddress = toAddress;
    self.addresslabel.text = toAddress;
}

- (IBAction)cancelButtonClick:(id)sender {
    [self hideView];
    if (self.popBlock) {
        self.popBlock(0);
    }
}

- (IBAction)confirmButtonClick:(id)sender {
    [self hideView];
    if (self.popBlock) {
        self.popBlock(1);
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
