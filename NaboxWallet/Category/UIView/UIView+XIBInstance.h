//
//  UIView+XIBInstance.h
//  SimplicityWeather
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2018年 SimplicityWeather. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XIBInstance)
+(instancetype)instanceView;

+ (UINib *)loadNibNamed:(NSString*)nibName;
+ (UINib *)loadNibNamed:(NSString*)nibName bundle:(NSBundle *)bundle;

+ (instancetype)loadInstanceFromNib;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle;
@end
