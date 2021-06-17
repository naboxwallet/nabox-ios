//
//  TradingRecordFilterView.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "TradingRecordFilterView.h"
#import "BRPickerView.h"

@interface TradingRecordFilterView ()
@property (strong, nonatomic) IBOutlet UILabel *recordLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIButton *beginDateButton;
@property (strong, nonatomic) IBOutlet UIButton *endDateButton;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, strong) UIView *bgColorView;
@property (nonatomic, strong) NSMutableArray *buttonArr;
@end

@implementation TradingRecordFilterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.recordLabel.text = KLocalizedString(@"screening_transaction_records");
    self.dateLabel.text = KLocalizedString(@"date_range");
    [self.confirmButton setTitle:KLocalizedString(@"sure") forState:UIControlStateNormal];
    [self.beginDateButton setCircleWithRadius:4];
    [self.endDateButton setCircleWithRadius:4];
    [self.beginDateButton setborderWithBorderColor:kColorLine Width:1];
    [self.endDateButton setborderWithBorderColor:kColorLine Width:1];
}

- (void)setQueryModel:(QueryTxListModel *)queryModel
{
    _queryModel = queryModel;
    NSString *startStr = [[queryModel.startTime componentsSeparatedByString:@" "] firstObject];
    NSString *endStr = [[queryModel.endTime componentsSeparatedByString:@" "] firstObject];
    [self.beginDateButton setTitle:startStr forState:UIControlStateNormal];
    [self.endDateButton setTitle:endStr forState:UIControlStateNormal];
}

- (void)setSelectArr:(NSMutableArray *)selectArr
{
    _selectArr = selectArr;
    [self createSelectButton];
}

//- (void)showInView
//{
//    UIView *view = KAppDelegate.window;
//    CGFloat viewWidth = 280;
//    self.bgColorView = [[UIView alloc] init];
//    [self.bgColorView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideInView)]];
//    self.bgColorView.backgroundColor = [KColorBlack colorWithAlphaComponent:0.f];
//    [view addSubview:self.bgColorView];
//    [self.bgColorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(view);
//    }];
//    [view addSubview:self];
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view.mas_right);
//        make.top.bottom.equalTo(view);
//        make.width.mas_equalTo(viewWidth);
//    }];
//    [self.superview layoutIfNeeded];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.bgColorView.backgroundColor = [KColorBlack colorWithAlphaComponent:0.4f];
//        [self mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(view.mas_right).offset(-viewWidth);
//        }];
//        [self.superview layoutIfNeeded];
//    }];
//}


//type==0 nuls  type不等于0 token
- (void)showInView{
    UIView *view = KAppDelegate.window;
    CGFloat viewWidth = 280;
    self.bgColorView = [[UIView alloc] init];
    [self.bgColorView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideInView)]];
    self.bgColorView.backgroundColor = [KColorBlack colorWithAlphaComponent:0.f];
    [view addSubview:self.bgColorView];
    [self.bgColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_right);
        make.top.bottom.equalTo(view);
        make.width.mas_equalTo(viewWidth);
    }];
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgColorView.backgroundColor = [KColorBlack colorWithAlphaComponent:0.4f];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_right).offset(-viewWidth);
        }];
        [self.superview layoutIfNeeded];
    }];
    
    
}

- (void)hideInView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgColorView.backgroundColor = [KColorBlack colorWithAlphaComponent:0.f];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.superview.mas_right);
        }];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.bgColorView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)createSelectButton
{
    self.buttonArr = [NSMutableArray array];
    NSArray *titleArr;

    if(self.type==0){
         titleArr= @[KLocalizedString(@"transfer_accounts"),
                              KLocalizedString(@"receivables"),
                              //                          KLocalizedString(@"date_range"),
                              KLocalizedString(@"Join_the_entrustment"),
                              KLocalizedString(@"exit_entrustment"),
                              KLocalizedString(@"consensus_gains"),
                              KLocalizedString(@"调用合约"),
                              KLocalizedString(@"合约返回")
                              ];
    }else{
        titleArr= @[KLocalizedString(@"transfer_accounts"),
                              KLocalizedString(@"receivables")
                               ];
    }
    
                         
    NSInteger lineNum = 2;
    NSInteger space = 24;
    NSInteger lineSpace = 16;
    CGFloat height = 40;
    CGFloat itemWidth = (280 - space * (lineNum + 1)) / lineNum;
    for (int i = 0; i < titleArr.count; i ++) {
        NSString *title = titleArr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setCircleWithRadius:2];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:KColorDarkGray forState:UIControlStateNormal];
        [button setTitleColor:KColorWhite forState:UIControlStateSelected];
        [button setBackgroundColor:KColorGray4 forState:UIControlStateNormal];
        [button setBackgroundColor:KColorPrimary forState:UIControlStateSelected];
        button.titleLabel.font = kSetSystemFontOfSize(14);
        button.tag = i;
        [button setCircleWithRadius:4];
        button.selected = [[self.selectArr objectAtIndex:i] boolValue];
        [button addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:button];
        [self.buttonArr addObject:button];
        
        CGFloat offictX = (i % lineNum + 1) * (space + itemWidth) - itemWidth;
        CGFloat offictY = (i / lineNum) * (lineSpace + height) + lineSpace;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(offictX);
            make.width.mas_equalTo(itemWidth);
            make.height.mas_equalTo(height);
            make.top.equalTo(self.bgView).offset(offictY);
        }];
    }
}

- (void)itemButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
}

- (IBAction)beginDateButtonClick:(id)sender {
    [self selectDateWithIsEnd:NO];
}

- (IBAction)endDateButtonClick:(id)sender {
    [self selectDateWithIsEnd:YES];
}

- (IBAction)confirmButtonClick:(id)sender {
    [self hideInView];
    NSMutableArray *types = [NSMutableArray array];
    [self.selectArr removeAllObjects];
    BOOL selectOut = NO;
    BOOL selectIn = NO;
    for (UIButton *button in self.buttonArr) {
        [self.selectArr addObject:[NSNumber numberWithBool:button.selected]];
        if (button.tag == 0 && button.selected) {
            selectOut = YES;
        }
        if (button.tag == 1 && button.selected) {
            selectIn = YES;
        }
        if (button.tag == 2 && button.selected) {
            [types addObject:@"5"];
        }
        if (button.tag == 3 && button.selected) {
            [types addObject:@"6"];
            [types addObject:@"8"];
        }
        if (button.tag == 4 && button.selected) {
            [types addObject:@"1"];
        }
        if (button.tag == 5 && button.selected) {
            [types addObject:@"16"];
            [types addObject:@"18"];
        }
        if (button.tag == 6 && button.selected) {
            [types addObject:@"19"];
        }
    }
    if (selectOut && selectIn) {
        if(self.type==0){
             [types addObject:@"2"];
        }else{
             [types addObject:@"16"];
             [types addObject:@"18"];
        }
       
    }else if (!selectOut && selectIn) {
        if(self.type==0){
            [types addObject:@"2"];
        }else{
            [types addObject:@"16"];
             [types addObject:@"18"];
        }
        self.queryModel.transCoinType = @"IN";
    }else if (selectOut && !selectIn) {
        if(self.type==0){
            [types addObject:@"2"];
        }else{
            [types addObject:@"16"];
        }
        self.queryModel.transCoinType = @"OUT";
    }
    self.queryModel.types = types;
    self.queryModel.endTime = [NSString stringWithFormat:@"%@ 23:59:59",self.endDateButton.titleLabel.text];
    self.queryModel.startTime = [NSString stringWithFormat:@"%@ 00:00:00",self.beginDateButton.titleLabel.text];
    if (self.filterBlock) {
        self.filterBlock(self.queryModel,self.selectArr);
    }
}


- (void)selectDateWithIsEnd:(BOOL)isEnd
{
    WS(weakSelf);
    NSDate *minDate = [[NSDate date] offsetYears:-1];
    [BRDatePickerView showDatePickerWithTitle:@"" dateType:BRDatePickerModeYMD defaultSelValue:nil minDate:minDate maxDate:[NSDate date] isAutoSelect:NO themeColor:nil resultBlock:^(NSString *selectValue) {
        SS(strongSelf);
        if (isEnd) {
            [strongSelf.endDateButton setTitle:selectValue forState:UIControlStateNormal];
        }else {
            [strongSelf.beginDateButton setTitle:selectValue forState:UIControlStateNormal];
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
