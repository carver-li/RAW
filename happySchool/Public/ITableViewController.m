//
//  ITableViewController.m
//  iPhoto
//
//  Created by carver on 15/6/6.
//  Copyright (c) 2015年 carver. All rights reserved.
//

#import "ITableViewController.h"
#define NoneDataLabelTag 6667760

@interface ITableViewController ()

@end

@implementation ITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MainBackgroundColor;
    [self configureLeftBarButtonUniformly];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)removeNoneDataTip {
    UIView *label = [self.view viewWithTag:NoneDataLabelTag];
    [label removeFromSuperview];
}

@end
