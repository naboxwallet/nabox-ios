//
//  GDAutoCompleteView.h
//  GDAutoComplete
//
//  Created by Admin on 2018/5/22.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GDAutoCompleteView;

@protocol GDAutoCompleteViewDelegate <NSObject>
@optional;

- (void)autoCompleteView:(GDAutoCompleteView *)autoCompleteView didChanged:(NSString *)text;
- (void)autoCompleteView:(GDAutoCompleteView *)autoCompleteView didSelectIndex:(NSInteger)index text:(NSString *)text;

@end

@interface GDAutoCompleteView : UIButton

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id<GDAutoCompleteViewDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *titleArr;

/** 是否为点击出现下拉框 默认NO */
@property (nonatomic, assign) BOOL isTouch;

/** 最大下拉显示个数 默认4 */
@property (nonatomic, assign) NSInteger maxShowCount;

/** 占位文字 默认为 请输入or请选择 */
@property (nonatomic, copy) NSString *placeholder;
@end
