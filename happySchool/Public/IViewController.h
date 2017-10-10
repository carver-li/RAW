//
//  IViewController.h
//  iPhoto
//
//  Created by carver on 15/5/20.
//  Copyright (c) 2015年 carver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"
#import "UIViewController+HUD.h"
#import "Constants.h"
#import "MJRefresh.h"
#import "Utility.h"

@interface IViewController : UIViewController

@property (nonatomic,assign) BOOL isHideStatusBar;

-(void)updateNoneDataTip:(NSString *)tip isEmpty:(BOOL)isEmpty;
-(void)removeNoneDataTip;



@end
