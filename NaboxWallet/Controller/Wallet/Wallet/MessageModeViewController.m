//
//  MessageModeViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "MessageModeViewController.h"
#import "MessageModeTableViewCell.h"
#import "MessageTableViewCell.h"
#import "ReadUserMsgModel.h"
#import "ReadSysMsgModel.h"
#import "CommonWebViewController.h"
#import "TradingRecordViewController.h"
@interface MessageModeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong)MsgListModel *msgListModel;
@property (nonatomic ,strong)MsgListModel *reqModel;
@property (nonatomic ,assign)BOOL haveMore;
@end

@implementation MessageModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.title = KLocalizedString(@"message_center");
    [self initUI];
    [self tableView];
    self.msgListModel = [MsgListModel new];
    
    self.reqModel = [MsgListModel new];
    if (!self.reqModel.language.length) {
        DLog(@"获取语言失败");
        self.reqModel.language = @"CHS";
    }
    
    self.reqModel.size =KPageSize;
    self.reqModel.current = 1;
     self.reqModel.resClassStr = NSStringFromClass([MsgListModel class]);
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)initUI{
    if (self.mode == MessgeModeSystem)  {
         self.navigationItem.title = KLocalizedString(@"system_message");
    }else if (self.mode == MessgeModeAgent){
//        self.navigationItem.title = KLocalizedString(@"system_message");
        self.navigationItem.title = KLocalizedString(@"entrusted_warning");
    }
}

- (void)loadData{
    NSString *URL;
    if (self.mode == MessgeModeSystem)  {
        URL = API_MSG_SYSTEM_LIST;
    }else if (self.mode == MessgeModeAgent){
        URL = API_MSG_AGENT_LIST;
        NSArray *wallets = [UserDefaultsUtil getAllWallet];
        if (wallets) {
            NSMutableArray *addressArray = [NSMutableArray new];
            for (NSDictionary *dic in wallets) {
                [addressArray addObject:[dic objectForKey:@"address"]];
            }
            self.reqModel.addressList = addressArray;
        }
    }
    [NetUtil requestWithType:RequestTypePost path:URL dataModel:self.reqModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        
        MsgListModel *tempModel = dataObj;
        self.haveMore = tempModel.list.count == KPageSize;
        if (self.reqModel.current == 1) {
            self.msgListModel.list = [UserMsgSubArrayModel mj_objectArrayWithKeyValuesArray:tempModel.list];
        }else{
            NSMutableArray *tempArr = [NSMutableArray new];
            [tempArr addObjectsFromArray:self.msgListModel.list];
            [tempArr addObjectsFromArray:[UserMsgSubArrayModel mj_objectArrayWithKeyValuesArray:tempModel.list]];
            self.msgListModel.list = tempArr;
        }
       
        
        if (!self.msgListModel.list.count) {
            self.placeholderView.coverImageView.image = ImageNamed(@"png_Blank pages3");
            self.tableView.tableFooterView = self.placeholderView;
        }
        [self.tableView reloadData];
        
        if (self.tableView.mj_header.isRefreshing)
        {
            [self.tableView.mj_header endRefreshing];
        }
        
        if (self.tableView.mj_footer.isRefreshing)
        {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

//下拉刷新
- (void)headerRefresh
{
    self.reqModel.current = 1;
    [self loadData];
    
}

//上拉刷新
- (void)footerRefresh
{
    if (self.haveMore) {
        self.reqModel.current ++;
        [self loadData];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.msgListModel.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
     UserMsgSubArrayModel *model = self.msgListModel.list[indexPath.section];
    if (self.mode == MessgeModeSystem)  {
        MessageModeTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:KMessageModeTableViewCellID forIndexPath:indexPath];
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _cell.contentView.backgroundColor = KColorWhite;
        _cell.msgModel = model;
        cell = _cell;
    }else if (self.mode == MessgeModeAgent){
        MessageTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:KMessageTableViewCellID forIndexPath:indexPath];
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _cell.contentView.backgroundColor = KColorWhite;
        _cell.messageMode = MessgeModeOther;
//        for (int i = 0; i < self.msgListModel.list.count; i++) {
//            UserMsgSubArrayModel *model = self.msgListModel.list[i];
//            model.docCode = model.configCode;
//        }
        model.docCode = model.configCode;
        _cell.userMsgModel = model;
        cell = _cell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserMsgSubArrayModel *model = self.msgListModel.list[indexPath.section];
    model.readState = 1;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (self.mode == MessgeModeAgent) {
        NSDictionary *dic = [model.extParams mj_JSONObject];
        NSLog(@"%@",dic);
        NSString *txHex = [dic objectForKey:@"txHex"];
        NSString *address = [dic objectForKey:@"address"];
        NSString *agentHash = [dic objectForKey:@"agentHash"];
     
        
        // 读取节点消息
        ReadUserMsgModel*reqModel = [ReadUserMsgModel new];
        reqModel.txHex = txHex;
        reqModel.isAdd = YES;
        reqModel.address = model.address;
        [NetUtil requestWithType:RequestTypePost path:API_MSG_READ_USER dataModel:reqModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
            
        }];
        
        
        if([model.docCode isEqualToString:@"YELLOW_WARNING"] || [model.docCode isEqualToString:@"YELLOW_WARNING_CREATE"] || [model.docCode isEqualToString:@"YELLOW_WARNING_DEPOSIT"] ){
        }else if([model.docCode isEqualToString:@"RED_STOP"] || [model.docCode isEqualToString:@"RED_STOP_CREATE"] || [model.docCode isEqualToString:@"RED_STOP_DEPOSIT"]){
            //红牌相关 跳转到交易详情页面
            
            TradingRecordViewController *vc = [TradingRecordViewController new];
            TransDetailRequestModel *transModel = [TransDetailRequestModel new];
            transModel.address = address;
            transModel.txHex = txHex;
            vc.txHash = txHex;
//            vc.requestModel = transModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (self.mode == MessgeModeSystem){
//        ReadSysMsgModel *reqModel = [ReadSysMsgModel new];
//        reqModel.msgId = model.id;
//        reqModel.isAdd = YES;
//        [NetUtil requestWithType:RequestTypePost path:API_MSG_READ_SYS dataModel:reqModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
//
//        }];
        
        CommonWebViewController *vc = [CommonWebViewController new];
        vc.title = model.title;
        vc.docCode = model.docCode;
        vc.language = model.language;
        NSString *url = [NSString stringWithFormat:@"&msgId=%@&terminal=%@&readState=%ld",model.id,TERMINAL,model.readState];
        vc.extendUrl = url;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
//#import "ReadUserMsgModel.h"
//#import "ReadSysMsgModel.h"
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
        [_tableView registerNib:[UINib nibWithNibName:KMessageModeTableViewCellID bundle:nil] forCellReuseIdentifier:KMessageModeTableViewCellID];
         [_tableView registerNib:[UINib nibWithNibName:KMessageTableViewCellID bundle:nil] forCellReuseIdentifier:KMessageTableViewCellID];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 10)];
         [self setupRefreshFortableView:_tableView headerReresh:YES footderReResh:YES];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
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
