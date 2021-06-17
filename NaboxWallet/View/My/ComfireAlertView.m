//
//  ComfireAlertView.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019年 NaboxWallet. All rights reserved.
//

#import "ComfireAlertView.h"
@interface ComfireAlertView ()
@property (weak, nonatomic) IBOutlet UIButton *cancleBuuton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation ComfireAlertView


- (void)drawRect:(CGRect)rect {
    
    [self setCircleWithRadius:6];
    [self.cancleBuuton setborderWithBorderColor:KColorPrimary Width:1];
    [self.cancleBuuton setTitle:KLocalizedString(@"cancel") forState:UIControlStateNormal];
    [self.confirmButton setTitle:KLocalizedString(@"sure") forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title{
    _title = title;
//    self.titleLabel.text = title;
}

- (void)setInfo:(NSString *)info{
    _info = info;
    self.infoLabel.text = info;
}

- (IBAction)cancleButtonClick:(UIButton *)sender {
    [self hideView];
    if (self.popBlock) {
        self.popBlock(0);
    }
}
- (IBAction)confirmButtonClick:(UIButton *)sender {
    [self hideView];
    if (self.popBlock) {
        self.popBlock(1);
    }
}


@end
