//
//  ICollectionViewController.h
//  iZhaoPian
//
//  Created by carver on 15/10/7.
//  Copyright © 2015年 carver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"
#import "UIViewController+HUD.h"
#import "MJRefresh.h"
#import "Constants.h"

@interface ICollectionViewController : UICollectionViewController

-(void)updateNoneDataTip:(NSString *)tip isEmpty:(BOOL)isEmpty;

@end
