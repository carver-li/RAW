//
//  AppDelegate.h
//  happySchool
//
//  Created by 李伟光 on 2017/9/30.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)appDelegate;
+ (UINavigationController *)baseNavigationController;
+ (UIViewController *)baseViewController;

@end

