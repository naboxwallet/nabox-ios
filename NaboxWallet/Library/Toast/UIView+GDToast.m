//
//  UIView+GDToast.m
//  Admin
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019年 Admin. All rights reserved.
//

#import "UIView+GDToast.h"

@implementation UIView (GDToast)

/**
 快速显示吐司，默认3秒，正常提示
 @param message   消息内容
 */
- (void)showNormalToast:(NSString *)message
{
    [self showToast:message duration:3 type:GDToastShowTypeNormal];
}

- (void)showToast:(NSString *)message duration:(NSTimeInterval)duration type:(GDToastShowType)type
{
    if (!message.length) {
        return;
    }
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.cornerRadius = 22;
    style.messageFont = [UIFont systemFontOfSize:14];
//    style.verticalPadding = 15;
    style.horizontalPadding = 15;
    style.imageSize = CGSizeMake(24, 24);
    UIImage *image = [[UIImage alloc] init];
    if (type == GDToastShowTypeNormal) {
        style.cornerRadius = 18.5;
        style.backgroundColor = KColorBlack;
        image = nil;
    }else if (type == GDToastShowTypeSuccess) {
        style.backgroundColor = KSetHEXColor(0x62a566);
        image = ImageNamed(@"complete");
    }else if (type == GDToastShowTypeWarning) {
        style.backgroundColor = KSetHEXColor(0xfdaf17);
        image = ImageNamed(@"warn");
    }else if (type == GDToastShowTypeFail) {
        style.backgroundColor = KSetHEXColor(0xfd461f);
        image = ImageNamed(@"fall");
    }
    [self makeToast:message duration:duration position:CSToastPositionCenter title:nil image:image style:style completion:^(BOOL didTap) {
        
    }];
}

@end
