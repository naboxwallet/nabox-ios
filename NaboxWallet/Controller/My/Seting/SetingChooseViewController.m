//
//  SetingChooseViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019年 NaboxWallet. All rights reserved.
//

#import "SetingChooseViewController.h"
#import "SetChooseCell.h"
#import "SyncWalletWithDeviceModel.h"
@interface SetingChooseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic ,copy) NSArray *titleArray;
@property (nonatomic ,strong) NSString *language;
@property (nonatomic ,strong) NSString *currency;
@end

@implementation SetingChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == 0) {
        self.navigationItem.title = KLocalizedString(@"language_settings");
        self.language =  [LanguageUtil userLanguage];
    }else if (self.type == 1){
        self.navigationItem.title = KLocalizedString(@"currency_setting");
        self.currency = [UserDefaultsUtil getValueWithKey:KEY_CURRENCY];
    }
    self.navigationItem.rightBarButtonItem = [self getBarbuttonItemWith:KLocalizedString(@"save") titleColor:KColorBlack withAction:@selector(saveAction)];
    self.tableView.backgroundColor = KColorWhite;
}

- (void)saveAction{
    if (self.type == 0) {
        [LanguageUtil setUserLanguage:self.language];
    }else if (self.type == 1) {
        [UserDefaultsUtil saveValue:self.currency forKey:KEY_CURRENCY];
    }
    [AppDelegateTableBar showMain];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:kSetChooseCell forIndexPath:indexPath];
    cell.nameLabel.text = self.titleArray[indexPath.row];
    if (self.type == 0) {
        if ([self.language isEqualToString:@"zh-Hans"] && indexPath.row == 0) {
            cell.tipImage.image = ImageNamed(@"checked");
        }else if ([self.language isEqualToString:@"en"] && indexPath.row == 1){
            cell.tipImage.image = ImageNamed(@"checked");
        }else{
            cell.tipImage.image = ImageNamed(@"");
        }
    }else if (self.type == 1) {
        cell.tipImage.hidden = YES;
        if ([self.currency isEqualToString:@"RMB"] && indexPath.row == 0) {
            cell.tipImage.hidden = NO;
        }else if ([self.currency isEqualToString:@"USD"] && indexPath.row == 1){
            cell.tipImage.hidden = NO;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.type == 0) {
        self.language = indexPath.row == 0 ? @"zh-Hans" : @"en";
    }else if (self.type == 1){
        self.currency = indexPath.row ? @"USD" : @"RMB";
    }
    [self.tableView reloadData];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kSetChooseCellHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        [_tableView registerNib:[UINib nibWithNibName:kSetChooseCell bundle:nil] forCellReuseIdentifier:kSetChooseCell];
        
    }
    return _tableView;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        if (self.type == 0) {
            _titleArray = @[@"简体中文",@"English"];
        }else if(self.type == 1){
            _titleArray = @[KLocalizedString(@"cny"),KLocalizedString(@"usd")];
        }
    }
    return _titleArray;
}


@end
