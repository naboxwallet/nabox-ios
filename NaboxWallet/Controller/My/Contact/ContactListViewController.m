//
//  ContactListViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "ContactListViewController.h"
#import "ContactorListCell.h"
#import "ContactViewController.h"
#import "ComfireAlertView.h"
@interface ContactListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *contactsArray;
@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = KLocalizedString(@"Contacts");
    self.navigationItem.rightBarButtonItem = [self getBarButtonItemWithImage:ImageNamed(@"icon_add") action:@selector(addContactAction)];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self loadData];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)loadData{
    self.contactsArray = [ContactsUtil getContacts];
    if (self.contactsArray.count == 0) {
        self.placeholderView.coverImageView.image = ImageNamed(@"png_Blank pages5");
        self.placeholderView.coverLabel.text = KLocalizedString(@"no_contact_at_present");
        self.tableView.tableFooterView = self.placeholderView;
    }else{
        self.tableView.tableFooterView = nil;
    }
    [self.tableView reloadData];
}

- (void)headerRefresh
{
    [self.tableView.mj_header endRefreshing];
}

- (void)footerRefresh
{
    [self.tableView.mj_footer endRefreshing];
}

- (void)addContactAction{
    ContactViewController *vc = [ContactViewController new];
    WS(weakSelf);
    vc.block = ^{
        SS(strongSelf);
        strongSelf.contactsArray = [ContactsUtil getContacts];
        [strongSelf loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contactsArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactorListCell *cell = [tableView dequeueReusableCellWithIdentifier:kContactorListCell forIndexPath:indexPath];
    ContactsModel *model = self.contactsArray[indexPath.row];
    cell.icon.image = ImageNamed(model.iconName);
    cell.nameLabel.text = model.name;
    cell.addressLabel.text = model.address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.contactsArray.count > indexPath.row && self.selectBlock) {
        self.selectBlock(self.contactsArray[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:KLocalizedString(@"delete") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        WS(weakSelf);
        ComfireAlertView *addView = [ComfireAlertView instanceView];
        addView.title = KLocalizedString(@"hint");
        addView.info = KLocalizedString(@"delete_contact");
        addView.popBlock = ^(NSInteger type) {
            SS(strongSelf);
            if (type) {
                [ContactsUtil deleteContacts:indexPath.row];
                [strongSelf loadData];
                [strongSelf.tableView reloadData];
            }
        };
        [addView showInController:self preferredStyle:TYAlertControllerStyleAlert];
    }];
    topRowAction.backgroundColor = KColorRed;
    return @[topRowAction];
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
    return FLT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return iPhoneX ? KSafeAreaHeight : KLineHeight;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.rowHeight = kContactorListCellHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [_tableView registerNib:[UINib nibWithNibName:kContactorListCell bundle:nil] forCellReuseIdentifier:kContactorListCell];
        [self setupRefreshFortableView:_tableView headerReresh:YES footderReResh:YES];
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
