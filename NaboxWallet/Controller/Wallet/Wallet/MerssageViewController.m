//
//  MerssageViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "MerssageViewController.h"
#import "MessageTableViewCell.h"
#import "MessageModeViewController.h"
#import "CommonWebViewController.h"
#import "TradingRecordViewController.h"
#import "ReadSysMsgModel.h"
#import "ComfireAlertView.h"
#import "ReadUserMsgModel.h"

@interface MerssageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) MsgListModel *sysMsgCountModel;
@property (nonatomic ,strong) MsgListModel *agentMsgCountModel;
@property (nonatomic ,strong) MsgListModel *userMsgModel;

@property (nonatomic ,strong) MsgListModel *reqUserMsgModel;
@property (nonatomic ,assign)BOOL haveMore;

@end

@implementation MerssageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KLocalizedString(@"message_center");
    self.navigationItem.rightBarButtonItem = [self getBarbuttonItemWith:KLocalizedString(@"all_read") titleColor:KColorDarkGray withAction:@selector(setMsgAllRead)];
    self.userMsgModel = [MsgListModel new];
    self.reqUserMsgModel = [MsgListModel new];
    if (!self.reqUserMsgModel.language.length) {
        DLog(@"获取语言失败");
        self.reqUserMsgModel.language = @"CHS";
    }
    self.reqUserMsgModel.size = 10;
    self.reqUserMsgModel.current = 1;
    [self tableView];
//    [self loadMessageCount];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self loadMessageCount];
}

- (void)loadMessageCount{
    MsgListModel *dataModel = [MsgListModel new];
    dataModel.resClassStr = NSStringFromClass([MsgListModel class]);
    [NetUtil requestWithType:RequestTypeGet path:API_MSG_SYSTEM_NOREAD dataModel:dataModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        self.sysMsgCountModel = dataObj;
        [self.tableView reloadData];
    }];
    
    MsgListModel *agentModel = [MsgListModel new];
            NSArray *wallets = [UserDefaultsUtil getAllWallet];
            if (wallets) {
                NSMutableArray *addressArray = [NSMutableArray new];
                for (NSDictionary *dic in wallets) {
                    [addressArray addObject:[dic objectForKey:@"address"]];
                }
                agentModel.addressList = addressArray;
            }
    NSString *formUrl = [self appenFormUrlWith:@"addressList" andArray:agentModel.addressList];
    NSString *reqUrl = [NSString stringWithFormat:@"%@?%@&type=IOS&terminal=%@&language=%@",API_MSG_AGENT_NOREAD,formUrl,TERMINAL,[LanguageUtil getUserLanguageStr]];
    agentModel.resClassStr = NSStringFromClass([MsgListModel class]);
    [NetUtil requestWithType:RequestTypePost path:reqUrl dataModel:agentModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        DLog(@"cccc %@",[dataObj mj_keyValues]);
        self.agentMsgCountModel = dataObj;
        [self.tableView reloadData];
    }];
    
    return;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HTTP_BASE,API_MSG_AGENT_NOREAD];
    NSDictionary* parametersDictionary = @{@"addressList":@"tNULSeBaMrNP548LVMEvppNThEjaMd2izU6jL6",@"terminal":TERMINAL,@"language":[LanguageUtil getUserLanguageStr],@"type":@"IOS"};
                AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8;" forHTTPHeaderField:@"Content-Type"];
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                [manager POST:url parameters:parametersDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task,id  _Nullable responseObject) {
                    DLog(@"节点未读数量: %@",responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task,NSError * _Nonnull error) {
                    NSLog(@"%@",error);
                }];
    
}

- (void)loadData{
    NSArray *wallets = [UserDefaultsUtil getAllWallet];
    if (wallets) {
        NSMutableArray *addressArray = [NSMutableArray new];
        for (NSDictionary *dic in wallets) {
            [addressArray addObject:[dic objectForKey:@"address"]];
        }
        self.reqUserMsgModel.addressList = addressArray;
    }
    self.reqUserMsgModel.resClassStr = NSStringFromClass([MsgListModel class]);
    [NetUtil requestWithType:RequestTypePost path:API_MSG_USER dataModel:self.reqUserMsgModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        MsgListModel *tempModel = dataObj;
        self.haveMore = tempModel.list.count == KPageSize;
        if (self.reqUserMsgModel.current == 1) {
            self.userMsgModel.list = [UserMsgSubArrayModel mj_objectArrayWithKeyValuesArray:tempModel.list];
        }else{
            NSMutableArray *tempArr = [NSMutableArray new];
            [tempArr addObjectsFromArray:self.userMsgModel.list];
            [tempArr addObjectsFromArray:[UserMsgSubArrayModel mj_objectArrayWithKeyValuesArray:tempModel.list]];
            self.userMsgModel.list = tempArr;
        }
        if (self.userMsgModel.list.count == 0) {
            self.placeholderView.coverImageView.image = ImageNamed(@"png_Blank pages3");
            self.tableView.tableFooterView = self.placeholderView;
        }
        [self.tableView reloadData];
    }];
}

- (void)setMsgAllRead{
    
    ComfireAlertView *addView = [ComfireAlertView instanceView];
    addView.title = KLocalizedString(@"hint");
    addView.info = KLocalizedString(@"all_read_hint");
    WS(weakSelf);
    addView.popBlock = ^(NSInteger type) {
        SS(strongSelf);
        if (type) {
            MsgListModel *agentModel = [MsgListModel new];
//            NSDictionary *walletDic = [UserDefaultsUtil getNowWallet];
            NSArray *wallets = [UserDefaultsUtil getAllWallet];
                NSMutableArray *addressArray = [NSMutableArray new];
                for (NSDictionary *dic in wallets) {
                    [addressArray addObject:[dic objectForKey:@"address"]];
                }
            NSString *formUrl = [self appenFormUrlWith:@"addressList" andArray:addressArray];
            NSString *reqUrl = [NSString stringWithFormat:@"%@?%@&type=IOS&terminal=%@&language=%@",API_MSG_READ_ALL,formUrl,TERMINAL,[LanguageUtil getUserLanguageStr]];
            [NetUtil requestWithType:RequestTypePost path:reqUrl dataModel:agentModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
                if (success) {
                    [strongSelf loadData];
                    [strongSelf loadMessageCount];
                }else{
                    [self.view makeToast:message];
                }
            }];
            
            
        }
    };
    [addView showInController:self preferredStyle:TYAlertControllerStyleAlert];
    
   
    
    
//    return;
//    ComfireAlertView *addView = [ComfireAlertView instanceView];
//    addView.title = KLocalizedString(@"hint");
//    addView.info = KLocalizedString(@"all_read_hint");
//    WS(weakSelf);
//    addView.popBlock = ^(NSInteger type) {
//        SS(strongSelf);
//        if (type) {
//            NSDictionary *walletDic = [UserDefaultsUtil getNowWallet];
//            NSString *url = [NSString stringWithFormat:@"%@%@",HTTP_BASE,API_MSG_READ_ALL];
//            NSDictionary* parametersDictionary = @{@"addressList":walletDic[@"address"],@"terminal":TERMINAL};
//            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8;application/json" forHTTPHeaderField:@"Content-Type"];
//            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//            [manager POST:url parameters:parametersDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task,id  _Nullable responseObject) {
//                
//            } failure:^(NSURLSessionDataTask * _Nullable task,NSError * _Nonnull error) {
//                NSLog(@"%@",error);
//            }];
//        }
//    };
//    [addView showInController:self preferredStyle:TYAlertControllerStyleAlert];
    
}

//下拉刷新
- (void)headerRefresh
{
    self.reqUserMsgModel.current = 1;
    [self loadData];
    
}

//上拉刷新
- (void)footerRefresh
{
    if (self.haveMore) {
        self.reqUserMsgModel.current ++;
        [self loadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1+1+self.userMsgModel.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KMessageTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = KColorWhite;
    //    cell.messageMode = indexPath.section % 2 ? MessgeModeSystem : MessgeModeOther;
    if (indexPath.section == 0) {
        cell.messageMode = MessgeModeSystem;
        cell.sysMsgCountModel = self.sysMsgCountModel;
    }else if (indexPath.section == 1){
        cell.messageMode = MessgeModeAgent;
        cell.agentMsgCountModel = self.agentMsgCountModel;
    }else{
        cell.messageMode = MessgeModeOther;
        UserMsgSubArrayModel *model = self.userMsgModel.list[indexPath.section-2];
        cell.userMsgModel = model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >1) {
        UserMsgSubArrayModel *model = self.userMsgModel.list[indexPath.section-2];
        CGFloat height = [Common getTextHeightWithText:model.summary font:kSetSystemFontOfSize(12) width:KSCREEN_WIDTH - 115];
//        DLog(@"height :%lf",height);
        return 90-14+height;
    }else{
        return 90;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        MessageModeViewController *modeVC = [[MessageModeViewController alloc] init];
        modeVC.mode = MessgeModeSystem;
        [self.navigationController pushViewController:modeVC animated:YES];
    }else if (indexPath.section == 1){
        MessageModeViewController *modeVC = [[MessageModeViewController alloc] init];
        modeVC.mode = MessgeModeAgent;
        [self.navigationController pushViewController:modeVC animated:YES];
    }else{
        TradingRecordViewController *vc = [TradingRecordViewController new];
        UserMsgSubArrayModel *model = self.userMsgModel.list[indexPath.section-2];
        model.readState = 1;
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
        NSDictionary *dic = [model.extParams mj_JSONObject];
        NSString *txHex = [dic objectForKey:@"txHex"];
        NSString *address = [dic objectForKey:@"address"];
        NSString *contractAddress = [dic objectForKey:@"contractAddress"];
        NSString *coinType = [dic objectForKey:@"coinType"];
//        ReadUserMsgModel*reqModel = [ReadUserMsgModel new];
//        reqModel.txHex = txHex;
//        reqModel.isAdd = YES;
//        [NetUtil requestWithType:RequestTypePost path:API_MSG_READ_USER dataModel:reqModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
//
//        }];
        
        TransDetailRequestModel *transModel = [TransDetailRequestModel new];
        transModel.address = model.address;
        transModel.txHex = txHex;
        transModel.contractAddress = contractAddress;
        transModel.coinType = coinType;
        vc.txHash = txHex;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
        return FLT_MIN;
    }
    return KLineHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return KLineHeight;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = KColorWhite;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:KMessageTableViewCellID bundle:nil] forCellReuseIdentifier:KMessageTableViewCellID];
        //        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 10)];
        [self setupRefreshFortableView:_tableView headerReresh:YES footderReResh:YES];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}


- (NSString *)appenFormUrlWith:(NSString *)key andArray:(NSArray *)array{
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i< array.count; i++) {
        if (i>0) {
            [str appendString:@"&"];
        }
        [str appendString:[NSString stringWithFormat:@"%@=%@",key,array[i]]];
    }
    return str;
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
