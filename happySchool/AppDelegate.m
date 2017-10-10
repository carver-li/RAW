//
//  AppDelegate.m
//  happySchool
//
//  Created by 李伟光 on 2017/9/30.
//

#import "AppDelegate.h"
#import "BaseViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setCommonUI];
    
    BaseViewController *baseViewController = [[AppDelegate mainStoryBoard] instantiateViewControllerWithIdentifier:@"BaseViewController"];
    INavigationController *nav = [[INavigationController alloc] initWithRootViewController:baseViewController];
    self.window.rootViewController = nav;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)setCommonUI {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if ([Utility IOS8]) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:MainBlueColor] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance]setShadowImage:[UIImage new]];
        [[UINavigationBar appearance] setTranslucent:NO];
    }else {
        [UINavigationBar appearance].barTintColor = MainBlueColor;
    }
    
    //导航栏颜色
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName,nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    //导航栏按钮颜色
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.8]} forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    //tabbar按钮颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MainBlueColor} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MainYellowColor} forState:UIControlStateSelected];
    
    //tabbar颜色
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    if ([Utility IOS8]) {
        [UITabBar appearance].translucent = NO;
    }
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
    [[UITableViewCell appearance] setSelectedBackgroundView:selectedBackgroundView];
}

+ (AppDelegate *)appDelegate{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

+ (UINavigationController *)baseNavigationController {
    UINavigationController *nav = (UINavigationController *)[AppDelegate appDelegate].window.rootViewController;
    return nav;
}

+ (UIViewController *)baseViewController {
    UIViewController *nav = [AppDelegate appDelegate].window.rootViewController;
    
    if ([nav isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)nav).rootViewController;
    }
    else {
        return nav;
    }
}

+ (UIStoryboard *)mainStoryBoard {
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

@end
