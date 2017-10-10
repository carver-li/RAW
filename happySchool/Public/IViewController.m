//
//  IViewController.m
//  iPhoto
//
//  Created by carver on 15/5/20.
//  Copyright (c) 2015年 carver. All rights reserved.
//

#import "IViewController.h"
#import "Utility.h"
#define NoneDataLabelTag 6667760

@implementation IViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MainBackgroundColor;
    [self configureLeftBarButtonUniformly];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([Utility IOS7]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.isHideStatusBar;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

-(void)updateNoneDataTip:(NSString *)tip isEmpty:(BOOL)isEmpty {
    UIView *label = [self.view viewWithTag:NoneDataLabelTag];
    [label removeFromSuperview];
    
    if (isEmpty) {
        UILabel *noneDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, CGRectGetHeight(self.view.frame)-44.0)];
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
