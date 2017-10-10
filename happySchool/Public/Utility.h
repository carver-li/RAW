//
//  Utility.h
//
//
//  Created by Sean on 14-5-13.
//  Copyright (c) 2014年 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASSupplement.h"
#import <UMSocialCore/UMSocialCore.h>

@interface Utility : NSObject

+ (BOOL)Is3Inch;
+ (BOOL)IsIPhone5;
+ (BOOL)IsIPhone6;
+ (BOOL)IsIPhone6P;

+ (BOOL)IOS7;
+ (BOOL)IOS8;
+ (BOOL)IOS9;

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

+ (NSString*)MD5:(NSString*)str;

+ (void)setImgViewStyle:(UIView *) myView;

+ (BOOL)determineCellPhoneNumber:(NSString*)str;

+ (void)showMessage:(CGFloat)duration msg:(NSString*)msg;
+ (void)showErrorMsg:(UIView*)view type:(NSInteger)type msg:(NSString*)msg;

+ (NSString*)stringForDate:(NSDate*)date;

+ (NSString*)stringForDate2:(NSDate*)date;

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

+ (UIImage *)captureScreen ;

+ (NSDictionary *)nestedDictionaryByReplacingNullsWithNil:(NSDictionary*)sourceDictionary;

+ (NSString *)timeFormatted:(int)totalSeconds;

+ (BOOL)productionEnvironment;
+ (NSString *)appScheme;
+ (NSString *)serviceURLString;

+ (NSString *)adminUrlString;

//阿里云
+ (NSString *)ossHost;
+ (NSString *)ossBuckect;

//个推
+ (NSString *)geTuiAppId;
+ (NSString *)geTuiAppKey;
+ (NSString *)geTuiAppSecret;

//高德地图
+ (NSString *)lbsKey;

//camera 360
+ (NSString *)camera360Key;

//版本信息
+ (NSString *)versionString;
+ (NSString *)bundleVersionString;
+ (BOOL)initAppVersion; //返回是否新版本
+ (BOOL)showGuide;

+ (void)event:(NSString *)eventId;

+ (NSString *)appendHostIfNeeded:(NSString *)imageUrlString;

//我的页面红点标志，是否有未查看消息
+(BOOL)getNewMessageFlag;
+(void)updateNewMessageFlag:(BOOL)flag;

//未查看系统消息
+(BOOL)getNewSystemMessageFlag;
+(void)updateNewSystemMessageFlag:(BOOL)flag;

//分享网页链接
+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withTitle:(NSString *)title withDescr:(NSString *)descr withImage:(UIImage *)thumImage withWebpageUrl:(NSString *)pageUrl;

+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withTitle:(NSString *)title withDescr:(NSString *)descr withImage:(UIImage *)thumImage withWebpageUrl:(NSString *)pageUrl sharePostId:(NSString *)sharePostId;

//分享图片
+ (void)shareImageToPlatformType:(UMSocialPlatformType)platformType withThumImage:(UIImage *)thumImage withShareImage:(id)shareImage;

+ (NSString *)sinaShareShortURL:(NSString *)shareURL;

@end
