//
//  ITableViewController.h
//  iPhoto
//
//  Created by carver on 15/6/6.
//  Copyright (c) 2015年 carver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"
#import "UIViewController+HUD.h"
#import "MJRefresh.h"
#import "Constants.h"

@interface ITableViewController : UITableViewController

-(void)updateNoneDataTip:(NSString *)tip isEmpty:(BOOL)isEmpty;
-(void)removeNoneDataTip;

@end
