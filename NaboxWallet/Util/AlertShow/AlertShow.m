//
//  AlertShow.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "AlertShow.h"

@implementation AlertShow

+(void)alertShowWithContent:(NSString *)content Message:(NSString *)message Seconds:(CGFloat)second
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:content message: message preferredStyle:UIAlertControllerStyleAlert];
    [KAppDelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(cancelAlter:) userInfo:alert repeats:NO];
}

+(void)alertShowWithViewController:(UIViewController *)viewController content:(NSString *)content Message:(NSString *) message Seconds:(CGFloat)second
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:content message: message preferredStyle:UIAlertControllerStyleAlert];
    [viewController presentViewController:alert animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(cancelAlter:) userInfo:alert repeats:NO];
}

+(void)cancelAlter:(NSTimer *)sender
{
    UIAlertController *promptAlert = (UIAlertController*)[sender userInfo];
    [promptAlert dismissViewControllerAnimated:YES completion:nil];
    promptAlert =NULL;
}

+(void)alertShowWithContent:(NSString *)content Message:(NSString *)message  buttonTitle:(NSString *)buttonTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:content message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [KAppDelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

+(void)showWithViewController:(UIViewController *)viewController Title:(NSString*)titleStr Message:(NSString*)msg LeftBtnTitle:(NSString*)leftTitle RightBtnTitle:(NSString*)rightTitle ClickLeftBtn:(AlertBlock)leftAction ClickRightBtn:(AlertBlock)rightAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleStr message:msg preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *rightAlert = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (rightAction) {
            rightAction(nil);
        }
    }];
    
    if (leftTitle.length) {
        UIAlertAction *leftAlert = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (leftAction) {
                leftAction(nil);
            }
        }];
        [alert addAction:leftAlert];
    }
    [alert addAction:rightAlert];
    [viewController presentViewController:alert animated:YES completion:nil];
}

+(void)showWithViewController:(UIViewController *)viewController Title:(NSString*)titleStr Message:(NSString*)msg BtnTitle:(NSString*)btnTitle ClickBtn:(AlertBlock)btnAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleStr message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAlert = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (btnAction) {
            btnAction(nil);
        }
    }];
    
    [alert addAction:okAlert];
    [viewController presentViewController:alert animated:YES completion:nil];
}
@end
