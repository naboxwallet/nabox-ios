//
//  SelectWalletView.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "SelectWalletView.h"
#import "SelectWalletTableViewCell.h"

@interface SelectWalletView ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *manageButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSArray *walletArr;//钱包数据
@end

@implementation SelectWalletView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.text = KLocalizedString(@"choice_wallet");
    self.walletArr = [WalletModel mj_objectArrayWithKeyValuesArray:[UserDefaultsUtil getAllWallet]];
    [self setSomeView];
    [self getNulsBalance];
}

//获取余额
- (void)getNulsBalance
{
    WS(weakSelf);
    [[CommonHttp sharedInstance] getNulsBalanceWithIsAll:YES balanceBlock:^(NulsBalanceModel * _Nullable balanceModel, NSArray * _Nullable walletArr) {
        SS(strongSelf);
        strongSelf.walletArr = walletArr;
        [strongSelf.tableView reloadData];
    }];
}

- (void)showInView
{
    UIView *view = KAppDelegate.window;
    CGFloat viewWidth = KSCREEN_WIDTH - 50;
    self.bgView = [[UIView alloc] init];
    [self.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideInView)]];
    self.bgView.backgroundColor = [KColorBlack colorWithAlphaComponent:0.f];
    [view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        self.bgView.backgroundColor = [KColorBlack colorWithAlphaComponent:0.4f];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_right).offset(-viewWidth);
        }];
        [self.superview layoutIfNeeded];
    }];
    [self tableView];
}

- (void)hideInView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.backgroundColor = [KColorBlack colorWithAlphaComponent:0.f];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.superview.mas_right);
        }];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)setSomeView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:KSelectWalletTableViewCellID bundle:nil] forCellReuseIdentifier:KSelectWalletTableViewCellID];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 10)];
}


#pragma mark - table datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.walletArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KSelectWalletTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.walletModel = self.walletArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KSelectWalletTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FLT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLT_MIN;
}

#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideInView];
    if (self.walletArr.count > indexPath.row && self.selectBlock) {
        WalletModel *walletModel = self.walletArr[indexPath.row];
        [UserDefaultsUtil saveNowWallet:walletModel.mj_keyValues];
        self.selectBlock(walletModel);
    }
}

- (IBAction)manageButtonClick:(id)sender {
    [self hideInView];
    if (self.manageBlock) {
        self.manageBlock();
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
