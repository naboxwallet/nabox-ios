//
//  UIImage+Common.h
//  SimplicityWeather
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2018年 SimplicityWeather. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionBlock)( NSError *error);

typedef NS_ENUM(NSUInteger ,GradientType) {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
};


@interface UIImage (Common)

- (NSString *)saveImageToTmpWithCompressLevel:(CGFloat)compressionQuality;

- (NSString *)saveImageToTmpWithSize:(CGFloat)maxFileSize;

+ (UIImage *)imageWithUIView:(UIView*)view;

+ (UIImage *)imageWithColor:(UIColor*)color;

- (UIImage *)roundedRectWithSize:(CGSize)size radius:(CGFloat)r;

- (UIImage *)transformtoSize:(CGSize)newSize;

+ (UIImage*)imageWithBase64String:(NSString*)base64String;

- (NSString*)toBase64String;


- (UIImage *)imageTintedWithColor:(UIColor *)color;
- (UIImage *)imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction;

//渐变
+(UIImage*)imageWithFrame:(CGSize)size Colors:(NSArray*)colors GradientType:(GradientType)gradientType;

- (id)roundedSize:(CGSize)size radius:(NSInteger)r;
/**
 获取图片上某一点的颜色
 
 @param point  图片内的一个点。范围是 [0, image.width-1],[0, image.height-1]
 超出图片范围则返回nil
 */
- (UIColor *) getPixelColorAtLocation:(CGPoint)point;

- (instancetype)imageWithOverlayColor:(UIColor *)overlayColor;


/**
 *  根据颜色返回一张图片
 *
 *  @param color 颜色
 *  @param rect  大小
 *
 *  @return 背景图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect;
/**
 *  保存图片到相册
 */
-(void)imageWriteToSavedPhotosAlbum:(UIImage *)image result:(CompletionBlock) completionBlock;

/**
 *  压缩上传图片到指定字节
 *
 *  @param image     压缩的图片
 *  @param maxLength 压缩后最大字节大小
 *
 *  @return 压缩后图片的二进制
 */
+ (NSData *)compressImage:(UIImage *)image toMaxLength:(NSInteger) maxLength maxWidth:(NSInteger)maxWidth;

/**
 *  获得指定size的图片
 *
 *  @param image   原始图片
 *  @param newSize 指定的size
 *
 *  @return 调整后的图片
 */
+ (UIImage *)resizeImage:(UIImage *) image withNewSize:(CGSize) newSize;

/**
 *  通过指定图片最长边，获得等比例的图片size
 *
 *  @param image       原始图片
 *  @param imageLength 图片允许的最长宽度（高度）
 *
 *  @return 获得等比例的size
 */
+ (CGSize)scaleImage:(UIImage *) image withLength:(CGFloat) imageLength;

///对指定图片进行拉伸
+ (UIImage*)resizableImage:(NSString *)name;

@end

