//
//  NaboxPayWalletView.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "ChooseAssetsListView.h"
#import "ChooseAssetsListViewCell.h"
@interface ChooseAssetsListView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleAndIconArr;


@end

@implementation ChooseAssetsListView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self updateUI];
}

- (void)updateUI
{
    self.titleLabel.text = KLocalizedString(@"chooseNetwork");
    
    self.tableView.rowHeight = kChooseAssetsListViewCellHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = kColorLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:kChooseAssetsListViewCell bundle:nil] forCellReuseIdentifier:kChooseAssetsListViewCell];
    [self.tableView reloadData];
//    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseChain)];
//    [self addGestureRecognizer:tapGesture];
}

- (void)chooseChain{
    [self hideView];
}


- (IBAction)closeButtonClick:(id)sender {
    [self hideView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.titleAndIconArr lastObject] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseAssetsListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChooseAssetsListViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.iconImage.image = ImageNamed(self.titleAndIconArr[1][indexPath.row]);
    cell.iconNameLabel.text = self.titleAndIconArr[0][indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock) { self.selectBlock(self.titleAndIconArr[0][indexPath.row],self.titleAndIconArr[1][indexPath.row]);
        [self hideView];
    }
}

-(NSMutableArray *)titleAndIconArr
{
    if (!_titleAndIconArr) {
        _titleAndIconArr = [NSMutableArray array];
         NSArray *titleArr= @[@"Ethereum",@"NULS",@"NERVE",@"BSC",@"Heco"];
        NSArray *iconArr = @[@"logo_Ethereum",@"logo_NULS",@"logo_NERVE",@"logo_BSC",@"logo_Heco"];
         [_titleAndIconArr addObject:titleArr];
        [_titleAndIconArr addObject:iconArr];
    }
    return _titleAndIconArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
