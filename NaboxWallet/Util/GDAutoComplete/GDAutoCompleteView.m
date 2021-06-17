//
//  GDAutoCompleteView.m
//  GDAutoComplete
//
//  Created by Admin on 2018/5/22.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import "GDAutoCompleteView.h"

static NSString *kCellID = @"UITableViewCell";
static CGFloat   cellHeight = 35;

@interface GDAutoCompleteView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *imageViewButton;
@property (nonatomic, assign) CGRect viewFrame;
@property (nonatomic, assign) BOOL isShow;
@end

@implementation GDAutoCompleteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 2;
        self.clipsToBounds =  YES;
        self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        self.layer.borderWidth = 1;
        self.maxShowCount = 4;
        _isShow = NO;
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius = 2;
        self.clipsToBounds =  YES;
        self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        self.layer.borderWidth = 1;
        self.maxShowCount = 4;
        _isShow = NO;
    }
    return self;
}



- (void)layoutSubviews
{
    if (!_textField.frame.size.width || !_textField.frame.size.height) {
        self.textField.frame = CGRectMake(14, 0, self.frame.size.width - 28, self.frame.size.height);
    }
    [self imageViewButton];
}

- (void)textFieldTextChanged:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(autoCompleteView:didChanged:)]) {
        [self.delegate autoCompleteView:self didChanged:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)tapClick
{
    self.isShow = !self.isShow;
    [self animateTableView:self.tableView show:self.isShow];
}

- (void)setTitleArr:(NSMutableArray *)titleArr
{
    _titleArr = titleArr;
    [_tableView reloadData];
    if (!self.isTouch) {
        self.isShow = titleArr.count;
        [self animateTableView:self.tableView show:self.isShow];
    }
}

- (void)animateTableView:(UITableView *)tableView show:(BOOL)show
{
    if (show) {
        
        [self.superview addSubview:self.tableView];
        [self.superview bringSubviewToFront:self.tableView];
//        [self bringSubviewToFront:self.textField];
        NSInteger count = self.titleArr.count>self.maxShowCount?self.maxShowCount:self.titleArr.count;
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.alpha = 1.f;
            self.tableView.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y + self.frame.size.height, self.frame.size.width, count * cellHeight);
        }];
    }else{
        [self.superview sendSubviewToBack:self.tableView];
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.alpha = 0.f;
            self.tableView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+ self.frame.size.height, self.frame.size.width, 0);
        } completion:^(BOOL finished) {
            if (self.tableView.superview) {
                [self.tableView removeFromSuperview];
            }
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.textField.text = self.titleArr[indexPath.row];
    self.isShow = NO;
    [self animateTableView:tableView show:self.isShow];
    if (self.delegate && [self.delegate respondsToSelector:@selector(autoCompleteView:didSelectIndex:text:)]) {
        [self.delegate autoCompleteView:self didSelectIndex:indexPath.row text:self.titleArr[indexPath.row]];
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if (!placeholder.length) {
        self.textField.placeholder = self.isTouch?@"请选择":@"请输入";
    }else{
        self.textField.placeholder = placeholder;
    }
     [_textField setValue:KSetHEXColor(0x191919) forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setIsTouch:(BOOL)isTouch
{
    _isTouch = isTouch;
    self.textField.enabled = !isTouch;
    if (!self.placeholder.length) {
        self.textField.placeholder = isTouch?@"请选择":@"请输入";
    }
    if (isTouch) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self addGestureRecognizer:tap];
    }
}

- (void)setIsShow:(BOOL)isShow
{
    _isShow = isShow;
    
    [UIView animateWithDuration:0.3 animations:^{
        if (!isShow) {
            self.imageViewButton.transform = CGAffineTransformIdentity;
        }else{
            if ([self getRadianDegreeFromTransform:self.imageViewButton.transform] == 0) {
                self.imageViewButton.transform = CGAffineTransformRotate(self.imageViewButton.transform, -M_PI_2);
            }
            NSLog(@"angle:%lf",[self getRadianDegreeFromTransform:self.imageViewButton.transform]);
        }
    }];
}

- (CGFloat)getRadianDegreeFromTransform:(CGAffineTransform)transform
{
    CGFloat rotate = acosf(transform.a);
    // 旋转180度后，需要处理弧度的变化
    if (transform.b < 0) {
        rotate = M_PI*2 - rotate;
    }
    return rotate;
}

- (void)setMaxShowCount:(NSInteger)maxShowCount
{
    _maxShowCount = maxShowCount;
}

- (UIImageView *)imageViewButton
{
    if (!_imageViewButton) {
        _imageViewButton = [[UIImageView alloc] init];
        _imageViewButton.frame = CGRectMake(self.frame.size.width - 38, (self.frame.size.height - 8 )/2, 12, 7);
        _imageViewButton.image = [UIImage imageNamed:@"arrow_down.jpg"];
        _imageViewButton.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageViewButton];
    }
    return _imageViewButton;
}

-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, self.frame.size.width - 28, self.frame.size.height)];
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:14];
//        [_textField setValue:KSetHEXColor(0x191919) forKeyPath:@"_placeholderLabel.textColor"];
        [_textField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:(UIControlEventEditingChanged)];
        [self addSubview:_textField];
    }
    return _textField;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.frame = CGRectMake(self.frame.origin.x, self.frame.size.height, self.frame.size.width, 0);
        _tableView.rowHeight = cellHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:kCellID];
        _tableView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _tableView.layer.borderWidth = 1;
        _tableView.layer.cornerRadius = 2;
        _tableView.clipsToBounds = YES;
//        [self.superview addSubview:_tableView];
    }
    return _tableView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
