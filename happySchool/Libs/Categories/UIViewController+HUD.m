//
//  UIViewController+HUD.m
//  BabyCamera
//
//  Created by Kowloon on 14-8-7.
//  Copyright (c) 2014年 Kowloon. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"

@implementation UIViewController (HUD)

- (void)showHUD{
    [self showHUDFromTitle:@"加载中..."];
}

- (void)setHUDTitle:(NSString *)title{
    [MBProgressHUD HUDForView:self.view].labelText = title;
}

- (void)showHUDFromTitle:(NSString *)title{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if ([[MBProgressHUD allHUDsForView:self.view] count] == 0) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        
        [self setHUDTitle:title];
    });
}

- (void)hideHUD {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
}

- (void)hideHUDFromWindow:(UIWindow *)window {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [MBProgressHUD hideAllHUDsForView:window animated:YES];
    });
}

#pragma mark - 自动消失提示

- (void)showTip:(NSString *)tip{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [Utility showErrorMsg:self.view type:0 msg:tip];
    });
}

- (void)showTipInWindow:(NSString *)tip {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [Utility showErrorMsg:[AppDelegate appDelegate].window type:0 msg:tip];
    });
}

@end
