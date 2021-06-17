//
//  WalletNamePopView.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "WalletNamePopView.h"

@interface WalletNamePopView ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UILabel *oldNameLabel;

@end

@implementation WalletNamePopView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setCircleWithRadius:6];
    
    [self.cancelButton setTitle:KLocalizedString(@"cancel") forState:UIControlStateNormal];
    [self.confirmButton setTitle:KLocalizedString(@"sure") forState:UIControlStateNormal];
    [self.cancelButton setborderWithBorderColor:KColorPrimary Width:1];
    self.nameTextField.delegate = self;
    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setOldName:(NSString *)oldName
{
    _oldName = oldName;
    self.oldNameLabel.text = oldName;
}

- (void)setPopType:(WalletPopType)popType
{
    _popType = popType;
    if (popType == WalletPopTypeName) {
        self.oldNameLabel.hidden = NO;
        self.nameLabel.text = KLocalizedString(@"old_name");
        self.nameTextField.placeholder = KLocalizedString(@"new_wallet_name");
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(24);
//            make.width.mas_equalTo(52);
        }];
        [self.oldNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).offset(20);
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self.nameLabel);
        }];
    }else if (popType == WalletPopTypePassword) {
        self.oldNameLabel.hidden = YES;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.text = KLocalizedString(@"input_password");
        self.nameTextField.placeholder = KLocalizedString(@"input_password");
        self.nameTextField.secureTextEntry = YES;
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(24);
            make.centerX.equalTo(self);
        }];
    }
}

- (IBAction)cancelButtonClick:(id)sender {
    [self hideView];
}

- (IBAction)confirmButtonClick:(id)sender {
    NSString *infoStr = [NSString string];
    if (self.popType == WalletPopTypePassword) {
        if (![self.nameTextField.text isHaveValue]) {
            infoStr = KLocalizedString(@"input_password");
        }
    }else if (self.popType == WalletPopTypeName) {
        if (![self.nameTextField.text isHaveValue]) {
            infoStr = KLocalizedString(@"input_wallet_name");
        }
    }
    if ([infoStr isHaveValue]) {
        [KAppDelegate.window showNormalToast:infoStr];
        return;
    }
//    [self hideView];
    if (self.nameBlock) {
        self.nameBlock(self,self.nameTextField.text);
    }
}


-(void)textFieldDidChange:(UITextField *)textField{
    if (self.popType == WalletPopTypePassword) {
        NSString *tem = [[textField.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
        textField.text = tem;
    }else if (self.popType == WalletPopTypeName){
        [Common strLengthLimitWithTextField:textField maxLength:12];
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
