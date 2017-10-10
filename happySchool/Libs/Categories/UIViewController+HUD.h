//
//  UIViewController+HUD.h
//  Flipboard
//
//  Created by Kowloon on 14-8-7.
//  Copyright (c) 2014年 Kowloon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Utility.h"

@interface UIViewController (HUD)

- (void)showHUD;
- (void)showHUDFromTitle:(NSString *)title;
- (void)hideHUD;
- (void)hideHUDFromWindow:(UIWindow *)window;
- (void)setHUDTitle:(NSString *)title;

- (void)showTip:(NSString *)tip;
- (void)showTipInWindow:(NSString *)tip;

@end
