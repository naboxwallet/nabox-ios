//
//  WalletNamePopView.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "AddFeePopView.h"

@interface AddFeePopView ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UILabel *havePayLabel;
@property (strong, nonatomic) IBOutlet UILabel *havePayInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *recommendFeeLabel;
@property (strong, nonatomic) IBOutlet UILabel *recommendFeeInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *addFeeLabel;
@property (strong, nonatomic) IBOutlet UILabel *unitLabel;


@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;


@end

@implementation AddFeePopView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setCircleWithRadius:6];
    
    [self.cancelButton setTitle:KLocalizedString(@"cancel") forState:UIControlStateNormal];
    [self.confirmButton setTitle:KLocalizedString(@"sure") forState:UIControlStateNormal];
    [self.cancelButton setborderWithBorderColor:KColorPrimary Width:1];
    self.amountTextField.delegate = self;
    [self.amountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}



- (IBAction)cancelButtonClick:(id)sender {
    [self hideView];
}

- (IBAction)confirmButtonClick:(id)sender {
    NSString *infoStr = [NSString string];
    if ([infoStr isHaveValue]) {
        [KAppDelegate.window showNormalToast:infoStr];
        return;
    }
//    [self hideView];
    if (self.nameBlock) {
        self.nameBlock(self,self.amountTextField.text);
    }
}

-(void)textFieldDidChange:(UITextField *)textField{
        NSString *tem = [[textField.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
        textField.text = tem;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
