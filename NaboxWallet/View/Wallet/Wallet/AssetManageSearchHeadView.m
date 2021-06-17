//
//  AssetManageSearchHeadView.m
//  NaboxWallet
//
//  Created by Admin on 2021/4/4.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "AssetManageSearchHeadView.h"

@implementation AssetManageSearchHeadView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.textField.placeholder = KLocalizedString(@"input_key_to_search");
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetManageSearchChange:)]) {
        [self.delegate assetManageSearchChange:textField.text];
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
