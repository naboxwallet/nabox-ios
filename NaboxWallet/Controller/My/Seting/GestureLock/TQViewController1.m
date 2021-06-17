//
//  TQViewController1.m
//  TQGestureLockViewDemo_Example
//
//  Created by TQTeam on 2017/11/3.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import "TQViewController1.h"
#import "TQGestureLockView.h"
#import "TQGestureLockPreview.h"
#import "TQGesturesPasswordManager.h"
#import "TQGestureLockHintLabel.h"
#import "TQGestureLockToast.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface TQViewController1 () <TQGestureLockViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;
@property (nonatomic, strong) TQGestureLockView *lockView;
@property (nonatomic, strong) TQGestureLockPreview *preview;
@property (nonatomic, strong) TQGestureLockHintLabel *hintLabel;
@property (nonatomic, strong) TQGesturesPasswordManager *passwordManager;
@property (nonatomic ,strong) UILabel *firstLabel;
@property (nonatomic ,strong) UILabel *twoLabel;
@property (nonatomic ,strong) UILabel *signLabel;
@end

@implementation TQViewController1


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = KLocalizedString(@"draw_a_design");
//    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
//    
//    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
//    [self.view addGestureRecognizer:pan];
    
//    self.fd_interactivePopDisabled = NO;
//    self.navigationController.fd_interactivePopDisabled = NO;
   
    self.view.backgroundColor = [UIColor whiteColor];
    [self commonInitialization];
    
    [self subviewsInitialization];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
//     self.navigationController.navigationBarHidden = YES;
}

- (void)commonInitialization
{
    self.passwordManager = [TQGesturesPasswordManager manager];
}

- (void)subviewsInitialization
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat spacing = TQSizeFitW(40);
    CGFloat diameter = (screenSize.width - spacing * 4) / 3;
    CGFloat bottom1 = TQSizeFitH(55);
    CGFloat width1 = screenSize.width;
    CGFloat top1 = screenSize.height - width1 - bottom1;
    CGRect rect1 = CGRectMake(0, 230, width1, width1);
    
    CGFloat width2 = screenSize.width, height2 = 30;
    CGFloat top2 = top1 + spacing - height2 - 15;
    CGRect rect2 = CGRectMake(0, 171, width2, height2);
    
    CGFloat width3 = 55;
    CGFloat left3 = screenSize.width / 2 - width3 / 2;
    CGFloat top3 = top2 - width3 - 5;
    CGRect rect3 = CGRectMake(left3, top3, width3, width3);
    
    TQGestureLockDrawManager *drawManager = [TQGestureLockDrawManager defaultManager];
    drawManager.circleDiameter = diameter;
    drawManager.edgeSpacingInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    drawManager.bridgingLineWidth = 0.5;
    drawManager.hollowCircleBorderWidth = 0.5;
    drawManager.drawSelectedColor = KColorSkin1;
    drawManager.drawNormalColor = KColorSkin1;
    
//    @property (nonatomic, strong) UIColor *drawNormalColor;
//
//    /// 选中状态下颜色
//    @property (nonatomic, strong) UIColor *drawSelectedColor;
//
//    /// 错误状态下颜色
//    @property (nonatomic, strong) UIColor *drawErrorColor;
    
    _lockView = [[TQGestureLockView alloc] initWithFrame:rect1 drawManager:drawManager];
    _lockView.delegate = self;
    [self.view addSubview:_lockView];
    
//    _hintLabel = [[TQGestureLockHintLabel alloc] initWithFrame:rect2];
//    [_hintLabel setNormalText:@"111"];
//    [self.view addSubview:_hintLabel];
    
    
    self.firstLabel = [UILabel new];
    [self.view addSubview:self.firstLabel];
    self.firstLabel.text = KLocalizedString(@"draw_an_unlock_pattern");
    self.firstLabel.font = [UIFont boldSystemFontOfSize:19];
    self.firstLabel.textColor = KSetHEXColor(0x333333);
    self.firstLabel.textAlignment = NSTextAlignmentCenter;
    self.firstLabel.numberOfLines = 0;
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(47);
        make.width.mas_equalTo(KSCREEN_WIDTH-40);
    }];
    
    self.twoLabel = [UILabel new];
    [self.view addSubview:self.twoLabel];
    self.twoLabel.text = KLocalizedString(@"keep_your_password_in_mind");
    self.twoLabel.font = kSetSystemFontOfSize(14);
    self.twoLabel.numberOfLines = 0;
     self.twoLabel.textColor = KSetHEXColor(0x333333);
    self.twoLabel.textAlignment = NSTextAlignmentCenter;
    [self.twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.firstLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(KSCREEN_WIDTH-40);
    }];
    
    self.signLabel = [UILabel new];
    [self.view addSubview:self.signLabel];
    self.signLabel.text = @"";
    self.signLabel.font = kSetSystemFontOfSize(14);
    self.signLabel.textColor = KSetHEXColor(0xF14545);
    self.signLabel.textAlignment = NSTextAlignmentCenter;
    self.signLabel.numberOfLines = 0;
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(170);
        make.width.mas_equalTo(KSCREEN_WIDTH-40);
    }];
    
    
    
    
    [_preview redraw];
}

#pragma mark - TQGestureLockViewDelegate

- (void)gestureLockView:(TQGestureLockView *)gestureLockView lessErrorSecurityCodeSting:(NSString *)securityCodeSting
{
    [gestureLockView setNeedsDisplayGestureLockErrorState:YES];
    
    if (self.passwordManager.hasFirstPassword) {
        _signLabel.text = KLocalizedString(@"two_different_drawing_patterns");
    } else {
        self.signLabel.text = KLocalizedString(@"draw_an_unlock_pattern");
//        [_hintLabel setWarningText:@""
//                     shakeAnimated:YES];
    }
}

- (void)gestureLockView:(TQGestureLockView *)gestureLockView finalRightSecurityCodeSting:(NSString *)securityCodeSting
{
    if (self.passwordManager.hasFirstPassword == NO) {
       
        [gestureLockView setNeedsDisplayGestureLockErrorState:NO];
        
        self.passwordManager.firstPassword = securityCodeSting;
       
        [_preview redrawWithVerifySecurityCodeString:securityCodeSting];
        self.signLabel.text = @"";
//        self.twoLabel.text = KLocalizedString(@"please_re_gesture");
        self.firstLabel.text = KLocalizedString(@"please_re_gesture");
//        [_hintLabel setNormalText:KLocalizedString(@"please_re_gesture")];
        
    } else {
        
        if ([self.passwordManager.firstPassword isEqualToString:securityCodeSting]) {
            
            [gestureLockView setNeedsDisplayGestureLockErrorState:NO];
          
//            [_hintLabel clearText];
            
            [self.passwordManager saveEventuallyPassword:securityCodeSting];
            
//            [self.view tq_showHUD:@"设置成功"];
            
            gestureLockView.userInteractionEnabled = NO;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });

        } else {
            [gestureLockView setNeedsDisplayGestureLockErrorState:YES];
            
//            [_hintLabel setWarningText:KLocalizedString(@"two_different_drawing_patterns") shakeAnimated:YES];
            
            self.signLabel.text = KLocalizedString(@"two_different_drawing_patterns");
        }
    }
}

@end
