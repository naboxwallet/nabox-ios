//
//  SelectSkinViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "SelectSkinViewController.h"
#import "WalletSkinCollectionViewCell.h"
#import "CardCollectionViewFlowLayout.h"
#import "WalletFinishViewController.h"
#import "BackUpChooseTypeViewController.h"
@interface SelectSkinViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *pageLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIView *colorView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nextButtonBottom;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGFloat dragStartX;
@property (nonatomic, assign) CGFloat dragEndX;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation SelectSkinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateUI];
    
}

- (void)updateUI
{
    self.walletModel.colorIndex = @0;
    
    if (self.skinType == SelectSkinTypeImport) {
        self.navigationItem.title = KLocalizedString(@"import_wallet");
        self.infoLabel.text = [NSString stringWithFormat:@"%@%@%@",
                               KLocalizedString(@"give"),
                               self.walletModel.alias,
                               KLocalizedString(@"choice_a_skin")];
        [self.nextButton setTitle:KLocalizedString(@"next") forState:UIControlStateNormal];
    }else if (self.skinType == SelectSkinTypeCreate) {
        self.navigationItem.title = KLocalizedString(@"add_wallet");
        self.infoLabel.text = KLocalizedString(@"choice_you_like_wallet_skin");
        [self.nextButton setTitle:KLocalizedString(@"next") forState:UIControlStateNormal];
    }else if (self.skinType == SelectSkinTypeUpdate) {
        self.navigationItem.title = KLocalizedString(@"change_wallet_skin");
        self.infoLabel.text = KLocalizedString(@"choice_a_skin");
        [self.nextButton setTitle:KLocalizedString(@"sure") forState:UIControlStateNormal];
    }
    
    [self.bgView setShadowWithOpacity:0.4];
    [self updateSkinUIWithIndex:_selectedIndex];
    
    CardCollectionViewFlowLayout *flowLayout = [[CardCollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 12;
    flowLayout.minimumInteritemSpacing = 12;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(KSCREEN_WIDTH - 50, KWalletSkinCollectionViewCellHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 25, 5, 25);
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:KWalletSkinCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:KWalletSkinCollectionViewCellID];
    
    if (iPhone5) {
        self.nextButtonBottom.constant = 10;
    }
}

//配置cell居中
- (void)fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = KSCREEN_WIDTH / 20.0f;
    if (_dragStartX -  _dragEndX >= dragMiniDistance) {
        _selectedIndex -= 1;//向右
    }else if(_dragEndX -  _dragStartX >= dragMiniDistance){
        _selectedIndex += 1;//向左
    }
    NSInteger maxIndex = [_collectionView numberOfItemsInSection:0] - 1;
    _selectedIndex = _selectedIndex <= 0 ? 0 : _selectedIndex;
    _selectedIndex = _selectedIndex >= maxIndex ? maxIndex : _selectedIndex;
    [self scrollToCenter];
    [self updateSkinUIWithIndex:_selectedIndex];
}

//滚动到中间
- (void)scrollToCenter {
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)updateSkinUIWithIndex:(NSInteger)index
{
    self.pageLabel.text = [NSString stringWithFormat:@"%ld",index + 1];
    self.nameLabel.text = self.dataArr[1][index];
    self.colorView.backgroundColor = [self.dataArr lastObject][index];
    //赋值选择
    self.walletModel.colorIndex = [NSNumber numberWithInteger:index];
    self.walletModel.skinName = self.nameLabel.text;
    self.walletModel.skinImageName = [self.dataArr firstObject][index];
}

//手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}

#pragma mark -
#pragma mark CollectionDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.dataArr firstObject] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WalletSkinCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KWalletSkinCollectionViewCellID forIndexPath:indexPath];
    cell.skinImageView.image = ImageNamed([self.dataArr firstObject][indexPath.row]);
    return cell;
}


- (IBAction)nextButtonClick:(id)sender {
    if (self.skinType == SelectSkinTypeImport) {
        WalletFinishViewController *resultVC = [[WalletFinishViewController alloc] init];
        resultVC.walletModel = self.walletModel;
        [self.navigationController pushViewController:resultVC animated:YES];
    }else if (self.skinType == SelectSkinTypeCreate) {
        BackUpChooseTypeViewController *vc = [BackUpChooseTypeViewController new];
        vc.walletModel = self.walletModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.skinType == SelectSkinTypeUpdate) {
        //保存
        NSDictionary *walletDict = [self.walletModel mj_keyValues];
        [UserDefaultsUtil saveNowWallet:walletDict];
        [UserDefaultsUtil saveToAllWallet:walletDict];
        if (self.selectBlock) {
            self.selectBlock(self.walletModel);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = @[@[@"png_wallet2_word",
                       @"png_wallet1_word",
                       @"png_wallet3_word",
                       @"png_wallet5_word",
                       @"png_wallet4_word"],
                     @[KLocalizedString(@"skin_name1"),
                       KLocalizedString(@"skin_name2"),
                       KLocalizedString(@"skin_name3"),
                       KLocalizedString(@"skin_name4"),
                       KLocalizedString(@"skin_name5")],
                     @[KColorSkin1,
                       KColorSkin2,
                       KColorSkin3,
                       KColorSkin4,
                       KColorSkin5]];
    }
    return _dataArr;
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
