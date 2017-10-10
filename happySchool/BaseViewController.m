//
//  BaseViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//
// Copyright (c) 2011 Peter Boctor
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "BaseViewController.h"

@interface BaseViewController() <UITabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray *assets;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:@"主页" image:@"tab_home.png" selectedImage:@"tab_home.png" tag:0],
                            [self viewControllerWithTabTitle:@"学生天地" image:@"tab_flush.png" selectedImage:@"tab_flush.png" tag:1],
                            [self viewControllerWithTabTitle:@"我的" image:@"tab_profile.png" selectedImage:@"tab_profile.png" tag:2], nil];
    
    self.tabBarController.delegate = self;
}

- (void)viewWillLayoutSubviews {
    [self.view bringSubviewToFront:centerButton];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*)viewControllerWithTabTitle:(NSString*) title image:(NSString*)image selectedImage:(NSString *)selectedImageName tag:(int)tabTag
{
    UIImage *normalImage = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImgae = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    switch (tabTag) {
        case 0:
        {
            HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            
            INavigationController *nav = [[INavigationController alloc] initWithRootViewController:homeViewController];
            nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage tag:tabTag];
            [nav.tabBarItem setSelectedImage:selectedImgae];
            return nav;
        }
            break;
        case 1:
        {
            StudentRootViewController *studentRootViewController = [[StudentRootViewController alloc] initWithNibName:@"StudentRootViewController" bundle:nil];
            
            INavigationController *nav = [[INavigationController alloc] initWithRootViewController:studentRootViewController];
            nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage tag:tabTag];
            [nav.tabBarItem setSelectedImage:selectedImgae];
            return nav;
        }
            break;
        case 2:
        {
            MineViewController *mineRootViewController = [[MineViewController alloc] initWithNibName:@"MineViewController" bundle:nil];
            mineRootViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage tag:tabTag];
            [mineRootViewController.tabBarItem setSelectedImage:selectedImgae];
            return mineRootViewController;
        }
            break;
        default:
            break;
    }
    
    return [[UIViewController alloc] init];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"当前选择:%ld",(long)item.tag);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
