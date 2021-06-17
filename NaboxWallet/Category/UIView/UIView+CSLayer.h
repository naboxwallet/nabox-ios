//
//  UIView+CSLayer.h
//  SimplicityWeather
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2018年 SimplicityWeather. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CSLayer)

#pragma mark
#pragma mark----------------------- circle or corner radius -----------------------
#pragma mark
/**
 * Set circle.
 */
- (void)setCircle;
- (void)setCircleByHeight;
- (void)setCircleWithRadius:(CGFloat)radius;
- (void)setCircleWithBezierPath;
- (void)setTopLeftAndTopRightCircleWithBezierPathRadius:(CGFloat)radius;
- (void)setBottomLeftAndTopRightCircleWithBezierPathRadius:(CGFloat)radius;
- (UIImage *)setCircleAndImageView;
/**
 * Set waterDrop.
 *
 */
- (CAShapeLayer *)setWaterDrop;


- (void)setCircleAndShadowWithRadius:(CGFloat)radius;

#pragma mark
#pragma mark----------------------- border and background color -----------------------
#pragma mark

/**
 * Set border.
 * gray color
 */
// 添加边框
- (void)setborder;

// 添加边框 自定义边框宽度
- (void)setborderWithBorderWidth:(CGFloat) width;

// 添加边框 自定义边框颜色，宽度
- (void)setborderWithBorderColor:(UIColor *)color Width:(CGFloat)width;

// 添加虚线边框 自定义边框颜色，宽度
- (void)setImaginaryLineBorderWithColor:(UIColor *)color Width:(CGFloat)width;
// 添加虚线边框 自定义边框颜色，宽度(无圆角)
- (void)setImaginaryLineBorderNoRadiusWithColor:(UIColor *)color Width:(CGFloat)width;
/**
 * Set clear color.
 */
- (void)setClearColor;

#pragma mark
#pragma mark----------------------- shadow -----------------------
#pragma mark
/**
 * Set shadow.
 * default opacity is 0.5f.
 * deault shadowRadius is 5.
 * defaul shadowColor is gray
 *
 */
- (void)setShadow;
/**
 *  Set shadow with opacity.
 * deault shadowRadius is 5.
 * defaul shadowColor is gray
 *
 */
- (void)setShadowWithOpacity:(CGFloat)opacity;
- (void)setShadowWithOpacity:(CGFloat)opacity radius:(CGFloat)radius;

/**
 *  底部加阴影
 */
-(void)addShadowonBottom;
/**
 *  加灰色阴影
 */
-(void)addGrayGradientShadow;
/**
 *  顶部加阴影
 */
-(void)addShadowonTop;
/**
 *  移动加阴影
 */
-(void)addMovingShadow;
/**
 *  移除阴影
 */
-(void)removeShadow;

@end
