//
//  UIView+CSLayer.m
//  SimplicityWeather
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2018年 SimplicityWeather. All rights reserved.
//

#import "UIView+CSLayer.h"

@implementation UIView (CSLayer)

#pragma mark
#pragma mark----------------------- circle or corner radius -----------------------
#pragma mark
- (void)setCircle {
    [self setCircleWithRadius:self.frame.size.width / 2];
}

- (void)setCircleByHeight{
    [self setCircleWithRadius:self.frame.size.height / 2];
}

- (void)setCircleWithRadius:(CGFloat)radius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}


- (void)setCircleWithBezierPath
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.frame.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setTopLeftAndTopRightCircleWithBezierPathRadius:(CGFloat)radius
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(radius, self.frame.size.height)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setBottomLeftAndTopRightCircleWithBezierPathRadius:(CGFloat)radius
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, self.frame.size.height)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (UIImage *)setCircleAndImageView
{
    //开始对imageView进行画图
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    //使用贝塞尔曲线画出一个圆形图
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.frame.size.width] addClip];
    [self drawRect:self.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束画图
    UIGraphicsEndImageContext();
    return image;
}

- (CAShapeLayer *)setWaterDrop
{
    CGFloat ridio = CGRectGetHeight(self.bounds) / 5;
    CGFloat width = CGRectGetWidth(self.bounds);
    if (width < ridio * 4) {
        NSLog(@"view宽度过窄");
        return nil;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetMidX(self.bounds), 0)];
    [path addQuadCurveToPoint:CGPointMake(CGRectGetMidX(self.bounds) - ridio * 2, ridio * 3) controlPoint:CGPointMake(CGRectGetMidX(self.bounds) - ridio * 2, ridio * 1.8)];
    [path addArcWithCenter:CGPointMake(CGRectGetMidX(self.bounds), ridio * 3) radius:ridio * 2 startAngle:-M_PI endAngle:0 clockwise:NO];
    [path addQuadCurveToPoint:CGPointMake(CGRectGetMidX(self.bounds), 0) controlPoint:CGPointMake(CGRectGetMidX(self.bounds) + ridio * 2, ridio * 1.8)];
    [path closePath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    return layer;
}


- (void)setCircleAndShadowWithRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.f, 0.5f);
    self.layer.shadowOpacity = 0.15f;
    self.layer.shadowRadius = 2.5f;
}

#pragma mark
#pragma mark----------------------- border and background color -----------------------
#pragma mark
- (void)setborder {
    self.layer.borderColor = KColorBg.CGColor;
    self.layer.borderWidth = 1;
}

-(void)setborderWithBorderWidth:(CGFloat)width
{
    self.layer.borderColor = KColorBg.CGColor;
    self.layer.borderWidth = width;
}

-(void)setborderWithBorderColor:(UIColor *)color Width:(CGFloat)width
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width ;
}

- (void)setImaginaryLineBorderWithColor:(UIColor *)color Width:(CGFloat)width
{
    CAShapeLayer *border = [CAShapeLayer layer];
    
    //虚线的颜色
    border.strokeColor = color.CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:8];
    
    //设置路径
    border.path = path.CGPath;
    
    border.frame = self.bounds;
    //虚线的宽度
    border.lineWidth = width;
    
    //设置线条的样式
    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @4];
    
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds = YES;
    [self.layer addSublayer:border];
    
}

- (void)setImaginaryLineBorderNoRadiusWithColor:(UIColor *)color Width:(CGFloat)width
{
    CAShapeLayer *border = [CAShapeLayer layer];
    
    //虚线的颜色
    border.strokeColor = color.CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0];
    //设置路径
    border.path = path.CGPath;
    border.frame = self.bounds;
    //虚线的宽度
    border.lineWidth = width;
    
    //设置线条的样式
    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@3, @3];
    self.layer.masksToBounds = YES;
    [self.layer addSublayer:border];
    
}

- (void)setClearColor {
    [self setBackgroundColor:[UIColor clearColor]];
}

#pragma mark
#pragma mark----------------------- shadow -----------------------
#pragma mark
- (void)setShadow {
    [self setShadowWithOpacity:0.5f];
}

- (void)setShadowWithOpacity:(CGFloat)opacity {
    [self.layer setShadowOpacity:opacity];
    [self.layer setShadowRadius:3];
    [self.layer setShadowOffset:CGSizeMake(0, 1)];
}

- (void)setShadowWithOpacity:(CGFloat)opacity radius:(CGFloat)radius {
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = radius;
    [self.layer setShadowOpacity:opacity];
    [self.layer setShadowRadius:3];
    [self.layer setShadowOffset:CGSizeMake(0, 1)];
}

-(void)addShadowonBottom
{
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowRadius = 0.7;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint p1 = CGPointMake(0.0, 0.0+self.frame.size.height);
    CGPoint p2 = CGPointMake(0.0+self.frame.size.width, p1.y);
    CGPoint c1 = CGPointMake((p1.x+p2.x)/256 , p1.y+1.50);
    CGPoint c2 = CGPointMake(c1.x*255, c1.y);
    
    [path moveToPoint:p1];
    [path addCurveToPoint:p2 controlPoint1:c1 controlPoint2:c2];
    
    self.layer.shadowPath = path.CGPath;
}

-(void)addShadowonTop
{
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowRadius = 0.7;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint p1 = CGPointMake(0.0, 0.0);
    CGPoint p2 = CGPointMake(0.0+self.frame.size.width, p1.y);
    CGPoint c1 = CGPointMake((p1.x+p2.x)/4 , p1.y-2.5);
    CGPoint c2 = CGPointMake(c1.x*3, c1.y);
    
    [path moveToPoint:p1];
    [path addCurveToPoint:p2 controlPoint1:c1 controlPoint2:c2];
    
    self.layer.shadowPath = path.CGPath;
}

-(void)addGrayGradientShadow
{
    self.layer.shadowOpacity = 0.4;
    
    CGFloat rectWidth = 10.0;
    CGFloat rectHeight = self.frame.size.height;
    
    CGMutablePathRef shadowPath = CGPathCreateMutable();
    CGPathMoveToPoint(shadowPath, NULL, 0.0, 0.0);
    CGPathAddRect(shadowPath, NULL, CGRectMake(0.0-rectWidth, 0.0, rectWidth, rectHeight));
    CGPathAddRect(shadowPath, NULL, CGRectMake(self.frame.size.width, 0.0, rectWidth, rectHeight));
    
    self.layer.shadowPath = shadowPath;
    CGPathRelease(shadowPath);
    
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.layer.shadowRadius = 10.0;
}

-(void)addMovingShadow
{
    static float step = 0.0;
    if (step>20.0) {
        step = 0.0;
    }
    
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowRadius = 1.5;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint p1 = CGPointMake(0.0, 0.0+self.frame.size.height);
    CGPoint p2 = CGPointMake(0.0+self.frame.size.width, p1.y);
    CGPoint c1 = CGPointMake((p1.x+p2.x)/4 , p1.y+step);
    CGPoint c2 = CGPointMake(c1.x*3, c1.y);
    
    [path moveToPoint:p1];
    [path addCurveToPoint:p2 controlPoint1:c1 controlPoint2:c2];
    
    self.layer.shadowPath = path.CGPath;
    step += 0.1;
    [self performSelector:@selector(addMovingShadow) withObject:nil afterDelay:1.0/30.0];
}

-(void)removeShadow
{
    self.layer.shadowOpacity =0;
    self.layer.shadowRadius = 0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint p1 = CGPointMake(0.0, 0.0);
    CGPoint p2 = CGPointMake(0.0+self.frame.size.width, p1.y);
    CGPoint c1 = CGPointMake(0 , 0);
    CGPoint c2 = CGPointMake(0, 0);
    
    [path moveToPoint:p1];
    [path addCurveToPoint:p2 controlPoint1:c1 controlPoint2:c2];
    
    self.layer.shadowPath = path.CGPath;
}

@end
