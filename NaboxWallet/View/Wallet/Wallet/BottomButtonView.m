//
//  BottomButtonView.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BottomButtonView.h"

@implementation BottomButtonView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.confirmButton setTitle:KLocalizedString(@"delete_wallet") forState:UIControlStateNormal];
}

- (IBAction)confirmButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomButtonDidSelect)]) {
        [self.delegate bottomButtonDidSelect];
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
