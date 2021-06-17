//
//  ManageLockViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019年 NaboxWallet. All rights reserved.
//

#import "ManageLockViewController.h"
#import "CheckGesturePwdViewController.h"
#import "TQViewController1.h"
#import "TQGesturesPasswordManager.h"
#import "ComfireAlertView.h"
@interface ManageLockViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *aa;
@property (weak, nonatomic) IBOutlet UILabel *ll;

@end

@implementation ManageLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ll.text = KLocalizedString(@"graphic_unlocking");
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([TQGesturesPasswordManager haveLocked]) {
        self.aa.on = YES;
    }else{
        self.aa.on = NO;
    }
}

- (IBAction)changeSwicth:(UISwitch *)sender {
    NSLog(@"%@",sender);
    if (sender.on) {
        TQViewController1 *vc = [TQViewController1 new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ComfireAlertView *addView = [ComfireAlertView instanceView];
        addView.title = KLocalizedString(@"hint");
        addView.info = KLocalizedString(@"close_guesture");
        addView.popBlock = ^(NSInteger type) {
            if (type) {
                self.aa.on = NO;
                 [TQGesturesPasswordManager removeLock];
            }else{
                self.aa.on = YES;
            }
        };
        [addView showInController:self preferredStyle:TYAlertControllerStyleAlert];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
