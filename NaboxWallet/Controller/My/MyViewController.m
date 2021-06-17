//
//  MyViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "MyViewController.h"
#import "MineTableViewCell.h"
#import "ContactListViewController.h"
#import "ManageWalletViewController.h"
#import "CommonWebViewController.h"
#import "AboutUsViewController.h"
#import "SetingViewController.h"
#import "WalletManageViewController.h"
#import "MerssageViewController.h"

#define KMineHeadImageHeight    276

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *titleAndIconArr;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = [self getBarButtonItemWithImage:ImageNamed(@"icon_message") action:@selector(messageAction:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:true];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)messageAction:(UIBarButtonItem *)sender
{
    MerssageViewController *messageVC = [[MerssageViewController alloc] init];
    [messageVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:messageVC animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.titleAndIconArr lastObject] count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KMineTableViewCellID forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.text = [self.titleAndIconArr lastObject][indexPath.row];
    cell.iconImageView.image = ImageNamed([self.titleAndIconArr firstObject][indexPath.row]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 1) {
        ContactListViewController *vc = [[ContactListViewController alloc]init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 0){
        WalletManageViewController *vc = [[WalletManageViewController alloc]init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){
        CommonWebViewController *vc = [[CommonWebViewController alloc]init];
        vc.title = KLocalizedString(@"help_center");
        vc.docType = DocumentTypeHelpCenter;
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4){
        AboutUsViewController *vc = [[AboutUsViewController alloc]init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        SetingViewController *vc = [[SetingViewController alloc]init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(NSMutableArray *)titleAndIconArr
{
    if (!_titleAndIconArr) {
        _titleAndIconArr = [NSMutableArray array];
        NSArray *titleArr = @[KLocalizedString(@"wallet_manage"),KLocalizedString(@"Contacts"),KLocalizedString(@"setting"),KLocalizedString(@"help_center"),KLocalizedString(@"about_us"),];
        NSArray *iconArr = @[@"user_massage",@"user_contact",@"user_setting",@"user_help",@"user_about",];
        [_titleAndIconArr addObject:iconArr];
        [_titleAndIconArr addObject:titleArr];
    }
    return _titleAndIconArr;
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = KMineTableViewCellHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
       make.top.equalTo(self.view).offset(-KNavbarAndStatusHieght);
        }];
        [_tableView registerNib:[UINib nibWithNibName:KMineTableViewCellID bundle:nil] forCellReuseIdentifier:KMineTableViewCellID];
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, KMineHeadImageHeight)];
        UIImageView *headImageView = [[UIImageView alloc]initWithImage:ImageNamed(@"my_bg")];
        [headView addSubview:headImageView];
        UILabel *headLabel = [[UILabel alloc]init];
        headLabel.text = KLocalizedString(@"Personal_Center");
        [headLabel setFont:[UIFont boldSystemFontOfSize:22]];
        headLabel.textColor = [UIColor whiteColor];
        [headView addSubview:headLabel];
        [headView bringSubviewToFront:headLabel];
        [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(-100);
        }];
        _tableView.tableHeaderView = headView;
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.width.equalTo(_tableView);
            make.height.mas_equalTo(KMineHeadImageHeight);
        }];
        
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
