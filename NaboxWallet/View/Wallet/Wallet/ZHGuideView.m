//
//  ZHGuideView.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "ZHGuideView.h"

@interface ZHGuideView ()
@property (nonatomic, strong) UIView *tempView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation ZHGuideView

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)showInViewWithFrame:(CGRect)frame
{
    [KAppDelegate.window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(KAppDelegate.window);
    }];
    [self layoutIfNeeded];
    self.tempView = [[UIView alloc] initWithFrame:frame];
    self.tempView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tempView];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    // 创建矩形
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRect:frame];
    [path appendPath:circlePath];
    
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.frame = self.bounds;
    shaperLayer.fillColor = [KColorBlack colorWithAlphaComponent:0.4].CGColor;
    // 设置填充规则
    shaperLayer.fillRule = kCAFillRuleEvenOdd;
    shaperLayer.path = path.CGPath;
    [self.layer addSublayer: shaperLayer];
    
    [self infoLabel];
    [self confirmButton];
    self.alpha = 0.f;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.f;
    }];
}


- (void)confirmButtonClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.font = kSetSystemFontOfSize(16);
        _infoLabel.numberOfLines = 0;
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.text = @"往左滑进入转帐，往右滑进入收款,\n也可以点击进入资产详情";
        [self addSubview:_infoLabel];
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.tempView.mas_top).offset(-15);
            make.centerX.equalTo(self);
        }];
    }
    return _infoLabel;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:KLocalizedString(@"i_know") forState:UIControlStateNormal];
        [_confirmButton setTintColor:[UIColor whiteColor]];
        [_confirmButton setCircleWithRadius:4];
        [_confirmButton setborderWithBorderColor:[UIColor whiteColor] Width:1];
        _confirmButton.titleLabel.font = kSetSystemFontOfSize(16);
        [_confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmButton];
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tempView.mas_bottom).offset(25);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(self);
        }];
    }
    return _confirmButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
