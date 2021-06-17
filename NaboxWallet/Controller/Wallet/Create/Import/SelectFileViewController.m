//
//  SelectFileViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "SelectFileViewController.h"
#import "FileListTableViewCell.h"

@interface SelectFileViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *keystoreArr;
@end

@implementation SelectFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KLocalizedString(@"add_keystore_file");
    self.keystoreArr = [KeyStoreModel mj_objectArrayWithKeyValuesArray:[UserDefaultsUtil getAllKeyStore]];
    [self tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.keystoreArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KFileListTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.keystoreArr.count > indexPath.row) {
        KeyStoreModel *model = self.keystoreArr[indexPath.row];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@%@",model.alias,model.address];
        cell.tiemLabel.text = model.time;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.keystoreArr.count > indexPath.row) {
        KeyStoreModel *model = self.keystoreArr[indexPath.row];
        NSString *str = [NSString stringWithFormat:@"%@%@",model.alias,model.address];
        return [Common getTextHeightWithText:str font:kSetSystemFontOfSize(13) width:KSCREEN_WIDTH - 85] + 15 + 38;
    }
    return KFileListTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.keystoreArr.count > indexPath.row) {
        KeyStoreModel *model = self.keystoreArr[indexPath.row];
        if (model.address) {
            NSInteger type = 0;
            if ([model.address hasPrefix:@"Ns"]) {
                type = 1;
            }else {
                type = 0;
            }
            if (self.selctIndex == type) {
                if (self.keystoreBlock) {
                    self.keystoreBlock(model);
                }
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = KColorWhite;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = kColorLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        [_tableView registerNib:[UINib nibWithNibName:KFileListTableViewCellID bundle:nil] forCellReuseIdentifier:KFileListTableViewCellID];
        _tableView.tableFooterView = [UIView new];
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
