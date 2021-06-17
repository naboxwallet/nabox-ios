//
//  UIView+ZHFrame.h
//  Admin
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZHFrame)
- (CGPoint)origin;
- (void)setOrigin:(CGPoint) point;

- (CGSize)size;
- (void)setSize:(CGSize) size;

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)tail;
- (void)setTail:(CGFloat)tail;

- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGFloat)right;
- (void)setRight:(CGFloat)right;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@end
