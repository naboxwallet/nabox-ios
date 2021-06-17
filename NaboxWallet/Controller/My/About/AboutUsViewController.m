//
//  AboutUsViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutUsCell.h"
#import "SettingCell.h"
#import "CommonWebViewController.h"
#import "VersionManageModel.h"
@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>


@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *titleArray;
@property (nonatomic ,strong) VersionManageModel* dataModel;

@end

@implementation AboutUsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = KLocalizedString(@"about_us");
    self.view.backgroundColor = KColorBg;
     self.tableView.backgroundColor = [UIColor whiteColor];
     [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self getVersion];
}

- (void)getVersion
{
    VersionManageModel *versionModel = [[VersionManageModel alloc] init];
    versionModel.resClassStr = NSStringFromClass([VersionManageModel class]);
    versionModel.isAdd = YES;
    versionModel.language = [LanguageUtil getUserLanguageStr];
    [NetUtil requestWithType:RequestTypeGet path:API_VERSION dataModel:versionModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        if (success) {
            self.dataModel = dataObj;
            [self.tableView reloadData];
        }
    }];
}

- ( UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCell forIndexPath:indexPath];

    cell.leftLabel.text = self.titleArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.rightLabel.text = @"";
    }else if (indexPath.row == 1){
//        cell.rightLabel.text = self.dataModel.version;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        cell.rightLabel.text = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        CommonWebViewController *vc = [[CommonWebViewController alloc]init];
        vc.title = KLocalizedString(@"version_log");
        vc.docType = DocumentTypeVersionLogs;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(NSArray *)titleArray
{
    if (!_titleArray) {
        
       _titleArray =  @[KLocalizedString(@"version_log"),KLocalizedString(@"updated_version")];
       
    }
    return _titleArray;
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 77;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
//        make.top.equalTo(self.view).offset(KNavbarAndStatusHieght);
            make.height.mas_equalTo(77*2+180);
        }];
        [_tableView registerNib:[UINib nibWithNibName:kSettingCell bundle:nil] forCellReuseIdentifier:kSettingCell];
       
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 180)];
        UIImageView *headImageView = [[UIImageView alloc]initWithImage:ImageNamed(@"user_about_nabox")];
        [headView addSubview:headImageView];
        headImageView.center = headView.center;
        _tableView.tableHeaderView = headView;
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headView);
            make.centerY.equalTo(headView);
        }];
        
//        UIView *line = [[UIView alloc]init];
//        [headView addSubview:line];
//        line.backgroundColor = KSetHEXColor(0xE9EBF3);
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.right.equalTo(headView);
//            make.left.equalTo(self.view).offset(16);
//            make.height.mas_equalTo(1);
//        }];
    }
    return _tableView;
}




@end
