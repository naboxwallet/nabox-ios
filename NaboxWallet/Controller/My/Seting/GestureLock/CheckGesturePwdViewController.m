//
//  TQViewController2.m
//  TQGestureLockViewDemo_Example
//
//  Created by TQTeam on 2017/11/3.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import "CheckGesturePwdViewController.h"
#import "TQGestureLockView.h"
#import "TQGesturesPasswordManager.h"
#import "TQGestureLockHintLabel.h"
//#import "TQSucceedViewController.h"
#import "TQGestureLockToast.h"
#import "TransferTempModel.h"
@interface CheckGesturePwdViewController () <TQGestureLockViewDelegate>{
    NSInteger count;
}

@property (nonatomic, strong) TQGestureLockView *lockView;
@property (nonatomic, strong) TQGestureLockHintLabel *hintLabel;
@property (nonatomic, strong) TQGesturesPasswordManager *passwordManager;
@property (nonatomic, assign) NSInteger restVerifyNumber;


@property (nonatomic, strong) TransferTempModel *transModel;
@property (nonatomic, strong) WalletModel *walletModel;

@property (nonatomic ,strong)UILabel *printLabel;
@property (nonatomic ,strong)UILabel *signLabel;
@property (nonatomic ,strong) UILabel *lockLabel;
@property (nonatomic ,strong) UILabel *lockTimeLabel;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CheckGesturePwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self commonInitialization];
    
    [self subviewsInitialization];
    
//    UIButton *t = [UIButton buttonWithType:UIButtonTypeSystem];
//    [t setFrame:CGRectMake(100, 100, 50, 50)];
//    t.backgroundColor = [UIColor redColor];
//    [self.view addSubview:t];
//    [t addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
//    [self test];
}

-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)commonInitialization
{
    self.passwordManager = [TQGesturesPasswordManager manager];
    [self verifyInitialRestNumber];
}

- (void)subviewsInitialization
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat spacing = TQSizeFitW(40);
    CGFloat diameter = (screenSize.width - spacing * 4) / 3;
    CGFloat bottom1 = TQSizeFitH(55);
    CGFloat width1 = screenSize.width;
    CGFloat top1 = screenSize.height - width1 - bottom1;
    CGRect rect1 = CGRectMake(0, 316, width1, width1);
    
    CGFloat width2 = screenSize.width, height2 = 30;
    CGFloat top2 = top1 - height2 -17;
    CGRect rect2 = CGRectMake(0, top2, width2, height2);
    
    TQGestureLockDrawManager *drawManager = [TQGestureLockDrawManager defaultManager];
    drawManager.circleDiameter = diameter;
    drawManager.edgeSpacingInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    drawManager.bridgingLineWidth = 0.5;
    drawManager.hollowCircleBorderWidth = 0.5;
    drawManager.drawSelectedColor = KColorSkin1;
    drawManager.drawNormalColor = KColorSkin1;
    
    _lockView = [[TQGestureLockView alloc] initWithFrame:rect1 drawManager:drawManager];
    _lockView.delegate = self;
    [self.view addSubview:_lockView];
    
//    _hintLabel = [[TQGestureLockHintLabel alloc] initWithFrame:rect2];
//    [self.view addSubview:_hintLabel];
    
    UIImageView *iconImageView = [[UIImageView alloc]init];
    [self.view addSubview:iconImageView];
    iconImageView.image = ImageNamed(@"icon_nuls");
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(75);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    
    self.printLabel = [UILabel new];
    [self.view addSubview:self.printLabel];
    self.printLabel.text = KLocalizedString(@"please_draw_the_unlock_password");
    self.printLabel.font = kSetSystemFontOfSize(14);
    self.printLabel.numberOfLines = 0;
    self.printLabel.textColor = KSetHEXColor(0x333333);
    self.printLabel.textAlignment = NSTextAlignmentCenter;
    [self.printLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(iconImageView.mas_bottom).offset(87);
        make.width.mas_equalTo(KSCREEN_WIDTH-40);
    }];
    
    self.signLabel = [UILabel new];
    [self.view addSubview:self.signLabel];
    self.signLabel.text = @"";
//    self.signLabel.text = @"钱包被锁定";
    self.signLabel.font = kSetSystemFontOfSize(14);
    self.signLabel.textColor = KSetHEXColor(0xF14545);
    self.signLabel.textAlignment = NSTextAlignmentCenter;
    self.signLabel.numberOfLines = 0;
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
         make.top.equalTo(self.printLabel.mas_bottom).offset(12);
        make.width.mas_equalTo(KSCREEN_WIDTH-40);
    }];
    
  
    
    self.lockLabel = [UILabel new];
    self.lockLabel.font = [UIFont boldSystemFontOfSize:28];
    [self.view addSubview:self.lockLabel];
    self.lockLabel.text = @"";
    self.lockLabel.textColor =KSetHEXColor(0x333333);
    
    self.lockLabel.textAlignment = NSTextAlignmentCenter;
    self.lockLabel.numberOfLines = 0;
    [self.lockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(iconImageView.mas_bottom).offset(30);
        make.width.mas_equalTo(KSCREEN_WIDTH-40);
    }];
    
    self.lockTimeLabel = [UILabel new];
    self.lockTimeLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.lockTimeLabel];
    self.lockTimeLabel.text = @"";
    self.lockTimeLabel.textColor = KSetHEXColor(0xF14545);
    self.lockTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.lockTimeLabel.numberOfLines = 0;
    [self.lockTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.lockLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(KSCREEN_WIDTH-40);
    }];
    
    
    
}

#pragma mark - TQGestureLockViewDelegate

- (void)gestureLockView:(TQGestureLockView *)gestureLockView lessErrorSecurityCodeSting:(NSString *)securityCodeSting
{
    [gestureLockView setNeedsDisplayGestureLockErrorState:YES];
    [self verifyRestNumbers];
}

- (void)gestureLockView:(TQGestureLockView *)gestureLockView finalRightSecurityCodeSting:(NSString *)securityCodeSting
{
    if ([self.passwordManager verifyPassword:securityCodeSting]) {
        [gestureLockView setNeedsDisplayGestureLockErrorState:NO];
//        TQSucceedViewController *vc = [TQSucceedViewController new];
//        [self.navigationController pushViewController:vc animated:YES];
//        [_hintLabel clearText];
        self.signLabel.text = @"";
        self.lockLabel.text = @"";
        self.lockTimeLabel.text = @"";
        [self verifyInitialRestNumber];
        [AppDelegateTableBar showMain];
    } else {
        [gestureLockView setNeedsDisplayGestureLockErrorState:YES];
        [self verifyRestNumbers];
    }
}

- (void)verifyInitialRestNumber {
    self.restVerifyNumber = 4;
}

- (void)verifyRestNumbers {
    if (self.restVerifyNumber < 1) {
//        [self.view tq_showText:@"验证失败" afterDelay:2];
        self.lockLabel.text = @"账号已被锁定";
        self.signLabel.text = @"";
        self.printLabel.hidden = YES;
        self.lockView.hidden = YES;
//        count = 5*60;
        count = 10;
      self.timer =   [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    } else {
        NSString *text = [NSString stringWithFormat:@"密码错误，还可以再输入%lu次", self.restVerifyNumber];
//        [_hintLabel setWarningText:text shakeAnimated:YES];
        self.signLabel.text = text;
        self.restVerifyNumber -= 1;
    }
}

- (void)handleTimer{
    count -- ;
    NSLog(@"%ld",count);
    if (count == 0) {
        [self.timer invalidate];
        [self verifyInitialRestNumber];
        self.lockTimeLabel.text =@"";
        self.lockLabel.text = @"";
        self.printLabel.hidden = NO;
        self.lockView.hidden = NO;
    }else{
        self.lockTimeLabel.text = [NSString stringWithFormat:@"%lds",count];
    }
}


@end
