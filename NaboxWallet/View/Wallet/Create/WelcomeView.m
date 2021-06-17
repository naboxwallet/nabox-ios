//
//  WelcomeView.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "WelcomeView.h"

@interface WelcomeView ()
@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation WelcomeView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = KColorWhite;
        [self showInfoStr];
    }
    return self;
}

- (void)showInfoStr
{
    self.infoLabel.alpha = 0.f;
    [UIView animateWithDuration:2 animations:^{
        self.infoLabel.text = KLocalizedString(@"welcome");
        self.infoLabel.alpha = 1.f;
    } completion:^(BOOL finished) {
        self.infoLabel.alpha = 0.f;
        [UIView animateWithDuration:2 animations:^{
            self.infoLabel.text = KLocalizedString(@"welcome2");
            self.infoLabel.alpha = 1.f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
               self.alpha = 0.f;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
    }];
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.numberOfLines = 0;
        _infoLabel.textColor = KColorDarkGray;
        _infoLabel.font = kSetSystemFontOfSize(21);
        [self addSubview:_infoLabel];
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
    }
    return _infoLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
