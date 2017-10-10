//
//  ICollectionViewController.m
//  iZhaoPian
//
//  Created by carver on 15/10/7.
//  Copyright © 2015年 carver. All rights reserved.
//

#import "ICollectionViewController.h"

#define NoneDataLabelTag 6667760

@interface ICollectionViewController ()

@end

@implementation ICollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.view.backgroundColor = MainBackgroundColor;
    [self configureLeftBarButtonUniformly];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

-(void)updateNoneDataTip:(NSString *)tip isEmpty:(BOOL)isEmpty {
    UIView *label = [self.view viewWithTag:NoneDataLabelTag];
    [label removeFromSuperview];
    
    if (isEmpty) {
        UILabel *noneDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, CGRectGetHeight(self.view.frame))];
        noneDataLabel.textAlignment = NSTextAlignmentCenter;
        noneDataLabel.textColor = [UIColor lightGrayColor];
        noneDataLabel.tag = NoneDataLabelTag;
        noneDataLabel.backgroundColor = [UIColor clearColor];
        
        if (tip) {
            noneDataLabel.text = tip;
        }
        else {
            noneDataLabel.text = @"^_^,空空如也！";
        }
        
        [self.view addSubview:noneDataLabel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
