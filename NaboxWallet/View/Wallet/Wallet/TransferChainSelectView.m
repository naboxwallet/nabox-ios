//
//  TransferChainSelectView.m
//  NaboxWallet
//
//  Created by Admin on 2021/4/14.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "TransferChainSelectView.h"

@interface TransferChainSelectCCell ()

@end

@implementation TransferChainSelectCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView setCircleWithRadius:6];
        [self.contentView setborderWithBorderColor:KColorClear Width:1];
        self.contentView.backgroundColor = KColorGray6;
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        [self.contentView setborderWithBorderColor:KColorSkin1 Width:1];
        self.contentView.backgroundColor = KColorWhite;
        self.nameLabel.textColor = KColorSkin1;
    } else {
        [self.contentView setborderWithBorderColor:KColorClear Width:1];
        self.contentView.backgroundColor = KColorGray6;
        self.nameLabel.textColor = KColorDarkGray;
    }
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"Chain";
        _nameLabel.textColor = KColorDarkGray;
        _nameLabel.font = kSetSystemFontOfSize(12);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [_nameLabel sizeToFit];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _nameLabel;
}

@end

@interface TransferChainSelectView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger selectIndex;//选择下标
@end

@implementation TransferChainSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setChainArr:(NSArray *)chainArr
{
    _chainArr = chainArr;
    self.selectIndex = -1;
    
    //一个时默认选中第一个
    if (chainArr.count == 1) {
        self.selectIndex = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(transferChainSelect:)]) {
            [self.delegate transferChainSelect:[self.chainArr firstObject]];
        }
        if (self.selectChainBlock) {
            self.selectChainBlock([self.chainArr firstObject]);
        }
    }
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.chainArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TransferChainSelectCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TransferChainSelectCCell class]) forIndexPath:indexPath];
    cell.nameLabel.text = self.chainArr[indexPath.row];
    cell.isSelected = self.selectIndex == indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndex == indexPath.row) {
        return;
    }
    self.selectIndex = indexPath.row;
    [collectionView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(transferChainSelect:)]) {
        [self.delegate transferChainSelect:self.chainArr[indexPath.row]];
    }
    if (self.selectChainBlock) {
        self.selectChainBlock(self.chainArr[indexPath.row]);
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        int limit = 5;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 15;
        flowLayout.minimumInteritemSpacing = 15;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake((KSCREEN_WIDTH - 15 * (limit + 1 )) / limit, 30);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = KColorWhite;
        [_collectionView registerClass:[TransferChainSelectCCell class] forCellWithReuseIdentifier:NSStringFromClass([TransferChainSelectCCell class])];
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _collectionView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
