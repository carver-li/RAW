//
//  ShareMeans.m
//  爱车汇
//
//  Created by Sean on 14-5-13.
//  Copyright (c) 2014年 GLSX. All rights reserved.
//

#import "Utility.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "Toast+UIView.h"
#import <Accelerate/Accelerate.h>

@implementation Utility

//3.5 inch
+(BOOL)Is3Inch {
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    if (height == 480) {
        return YES;
    }
    
    return NO;
}

+(BOOL)IsIPhone5 {
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    if (height == 568) {
        return YES;
    }
    
    return NO;
}

+(BOOL)IsIPhone6 {
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    if (height == 667) {
        return YES;
    }
    
    return NO;
}

+(BOOL)IsIPhone6P {
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    if (height == 736) {
        return YES;
    }
    
    return NO;
}

+(BOOL)IOS7{
    if ([[UIDevice currentDevice]systemVersion].floatValue>=7.0) {
        return YES;
    }
    
    return NO;
}

+(BOOL)IOS8 {
    if ([[UIDevice currentDevice]systemVersion].floatValue>=8.0) {
        return YES;
    }
    
    return NO;
}

+(BOOL)IOS9 {
    if ([[UIDevice currentDevice]systemVersion].floatValue>=9.0) {
        return YES;
    }
    
    return NO;
}

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

+(NSString*)MD5:(NSString*)str {
    const char *concat_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, strlen(concat_str), result);
    NSMutableString *hash =[NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

+(void) setImgViewStyle:(UIView *) myView{
    myView.layer.borderWidth = 1;
    myView.layer.borderColor = [UIColor clearColor].CGColor;
    myView.layer.shadowOffset = CGSizeMake(0, 0);
    myView.layer.shadowRadius = 10;
    myView.layer.shadowOpacity = 0.5;
    myView.layer.shadowPath = [UIBezierPath bezierPathWithRect:myView.bounds].CGPath;
}

+(BOOL)determineCellPhoneNumber:(NSString*)str{
    NSString *regex = @"^1[0-9]{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

+(NSString*)stringForDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [formatter stringFromDate:date];
}

+(NSString*)stringForDate2:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [formatter stringFromDate:date];
}

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}



+(UIImage *)captureScreen {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+(void)showMessage:(CGFloat)duration msg:(NSString*)msg {
    [[AppDelegate baseNavigationController].view makeToast:msg duration:duration position:@"center"];
}

+(void)showErrorMsg:(UIView*)view type:(NSInteger)type msg:(NSString*)msg;{
    switch (type) {
        case 0:
            [view makeToast:msg duration:2.0 position:@"center"];
            break;
        case 1:
            [view makeToast:@"网络开小差，请稍后重试" duration:2.0 position:@"center"];
            break;
        case 2:
            [view makeToast:@"设备不可用" duration:2.0 position:@"center"];
            break;
        case 3:
            [view makeToast:@"设备不存在" duration:2.0 position:@"center"];
            break;
        case 4:
            [view makeToast:@"无效的方法名" duration:2.0 position:@"center"];
            break;
        case 5:
            [view makeToast:@"缺少版本参数" duration:2.0 position:@"center"];
            break;
        case 6:
            [view makeToast:@"无效的版本参数" duration:2.0 position:@"center"];
            break;
        case 7:
            [view makeToast:@"缺少ak参数" duration:2.0 position:@"center"];
            break;
        case 8:
            [view makeToast:@"无效的ak参数" duration:2.0 position:@"center"];
            break;
        case 9:
            [view makeToast:@"缺少时间戳参数" duration:2.0 position:@"center"];
            break;
        case 10:
            [view makeToast:@"无效的时间戳参数" duration:2.0 position:@"center"];
            break;
        case 11:
            [view makeToast:@"缺少签名参数" duration:2.0 position:@"center"];
            break;
        case 12:
            [view makeToast:@"无效签名" duration:2.0 position:@"center"];
            break;
        case 13:
            [view makeToast:@"缺少session参数" duration:2.0 position:@"center"];
            break;
        case 14:
            [view makeToast:@"缺少渠道参数" duration:2.0 position:@"center"];
            break;
        case 15:
            [view makeToast:@"无效的渠道参数" duration:2.0 position:@"center"];
            break;
        case 16:
            [view makeToast:@"无效的session参数" duration:2.0 position:@"center"];
            break;
        case 17:
            [view makeToast:@"参数错误" duration:2.0 position:@"center"];
            break;
        case 18:
            [view makeToast:@"无效数据格式" duration:2.0 position:@"center"];
            break;
        case 19:
            [view makeToast:@"应用调用服务次数超限，包含调用频率超限" duration:2.0 position:@"center"];
            break;
        case 20:
            [view makeToast:@"平台业务逻辑出错" duration:2.0 position:@"center"];
            break;
        case 21:
            [view makeToast:@"不存在的服务" duration:2.0 position:@"center"];
            break;
        case 27:
            [view makeToast:@"不存在的方法名" duration:2.0 position:@"center"];
            break;
        case 33:
            [view makeToast:@"非法的参数" duration:2.0 position:@"center"];
            break;
        default:
            [view makeToast:msg duration:3.0 position:@"center"];
            break;
    }
}


//返回的json字符串null转换“”
+(NSDictionary *) nestedDictionaryByReplacingNullsWithNil:(NSDictionary*)sourceDictionary
{
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:sourceDictionary];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    [sourceDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        object = [sourceDictionary objectForKey:key];
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *innerDict = object;
            [replaced setObject:[self nestedDictionaryByReplacingNullsWithNil:innerDict] forKey:key];
            
        }
        else if([object isKindOfClass:[NSArray class]]){
            NSMutableArray *nullFreeRecords = [NSMutableArray array];
            for (id record in object) {
                
                if([record isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *nullFreeRecord = [self nestedDictionaryByReplacingNullsWithNil:record];
                    [nullFreeRecords addObject:nullFreeRecord];
                }
                else {
                    [nullFreeRecords addObject:record];
                }
            }
            
            [replaced setObject:nullFreeRecords forKey:key];
        }
        else
        {
            if(object == nul) {
                [replaced setObject:blank forKey:key];
            }
        }
    }];
    
    return [NSDictionary dictionaryWithDictionary:replaced];
}


+(NSString *)timeFormatted:(int)totalSeconds{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

+ (BOOL)productionEnvironment{
    NSString *bundleIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    return [bundleIdentifier isEqualToString:@"com.showtou.ipp"];
}

+ (NSString *)appScheme{
    return [Utility productionEnvironment] ? @"iZhaoPian" : @"iZhaoPianDev";
}

+ (NSString *)serviceURLString {
    return [Utility productionEnvironment] ? BASE2 : BASE1;
}


+ (NSString *)adminUrlString {
    return [Utility productionEnvironment] ?@"http://admin.izhaopian.cn":@"http://admin.showtou.com";
}

+ (NSString *)ossHost {
    return [Utility productionEnvironment] ? OSSHOST2 : OSSHOST1;
}

+ (NSString *)ossBuckect {
    return [Utility productionEnvironment] ? OSSBuckect2 : OSSBuckect1;
}

+ (NSString *)geTuiAppId {
    return [Utility productionEnvironment] ? kGETUIAppId : kGETUIAppIdDev;
}

+ (NSString *)geTuiAppKey {
    return [Utility productionEnvironment] ? kGETUIAppKey : kGETUIAppKeyDev;
}

+ (NSString *)geTuiAppSecret {
    return [Utility productionEnvironment] ? kGETUIAppSecret : kGETUIAppSecretDev;
}

+ (NSString *)lbsKey {
    return [Utility productionEnvironment] ? LBS_KEY : LBS_KEY_Dev;
}

+ (NSString *)camera360Key {
    return [Utility productionEnvironment] ? Camera360Key : Camera360DevKey;
}

+ (NSString *)versionString{
	NSString *file = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    NSString *version = [NSString stringWithFormat:@"%@",[dict objectForKey:@"CFBundleShortVersionString"]];
    return version;
}

+ (NSString *)bundleVersionString {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    NSString *version = [NSString stringWithFormat:@"%@",[dict objectForKey:@"CFBundleVersion"]];
    return version;
}

+ (BOOL)showGuide{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"showGuide"];
}

+ (BOOL)initAppVersion {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *old_version = [NSString stringWithFormat:@"%@", [ud objectForKey:@"version"]];
    NSString *new_version = [Utility versionString];
    if ([old_version compareToVersionString:new_version] == NSOrderedAscending) {
        [ud setValue:new_version forKey:@"version"];
        [ud setBool:YES forKey:@"showGuide"];
        
        return YES;
    }
    
	[ud synchronize];
    
    return NO;
}

+ (void)event:(NSString *)eventId{
    [MobClick event:eventId];
}

+ (NSString *)appendHostIfNeeded:(NSString *)imageUrlString {
    if (imageUrlString == nil) {
        return @"";
    }
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@",imageUrlString];
    
    if (![imageUrl containsString:@"http"]) {
        imageUrl = [[Utility serviceURLString] stringByAppendingString:imageUrlString];
    }
    
    return imageUrl;
}

+(BOOL)getNewMessageFlag {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"New_My_Message_Key"];
}

+(void)updateNewMessageFlag:(BOOL)flag {
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:@"New_My_Message_Key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getNewSystemMessageFlag {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"New_System_Message_Key"];
}

+(void)updateNewSystemMessageFlag:(BOOL)flag {
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:@"New_System_Message_Key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withTitle:(NSString *)title withDescr:(NSString *)descr withImage:(UIImage *)thumImage withWebpageUrl:(NSString *)pageUrl
{
    [self shareWebPageToPlatformType:platformType withTitle:title withDescr:descr withImage:thumImage withWebpageUrl:pageUrl sharePostId:nil];
}

+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withTitle:(NSString *)title withDescr:(NSString *)descr withImage:(UIImage *)thumImage withWebpageUrl:(NSString *)pageUrl sharePostId:(NSString *)sharePostId {
    if (platformType == UMSocialPlatformType_Sina) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        messageObject.title = title;
        messageObject.text = [descr stringByAppendingString:[self sinaShareShortURL:pageUrl]];
        
        //创建图片内容对象
        UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:title descr:descr thumImage:thumImage];
        [shareObject setShareImage:thumImage];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
                [[AppDelegate baseViewController] showTipInWindow:@"分享失败"];
            }else{
                NSLog(@"response data is %@",data);
                
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    [[AppDelegate baseViewController] showTipInWindow:resp.message?resp.message:@"分享成功"];
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
    }
    else {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumImage];
        //设置网页地址
        shareObject.webpageUrl = pageUrl;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
                [[AppDelegate baseViewController] showTipInWindow:@"分享失败"];
            }else{
                NSLog(@"response data is %@",data);
                
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    [[AppDelegate baseViewController] showTipInWindow:resp.message?resp.message:@"分享成功"];
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
    }
}

+ (void)shareImageToPlatformType:(UMSocialPlatformType)platformType withThumImage:(UIImage *)thumImage withShareImage:(id)shareImage
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = thumImage;
    [shareObject setShareImage:shareImage];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                [[AppDelegate baseViewController] showTipInWindow:resp.message];
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

+ (NSString *)sinaShareShortURL:(NSString *)shareURL
{
    NSString *wbShortRequestUrl = [NSString stringWithFormat:@"https://api.weibo.com/2/short_url/shorten.json?source=2503029327&url_long=%@",[self urlEncodedString:shareURL]];
    NSData *wbShortUrlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:wbShortRequestUrl]];
    
    NSString *shortShareUrlForWB = [NSString stringWithFormat:@"%@",shareURL];
    
    if (wbShortUrlData) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:wbShortUrlData options:NSJSONReadingMutableLeaves error:nil];
        
        if (resultDic) {
            NSArray *urlsForWB = [resultDic objectForKey:@"urls"];
            
            if (urlsForWB && urlsForWB.count > 0) {
                shortShareUrlForWB = [[urlsForWB objectAtIndex:0] objectForKey:@"url_short"];
                NSLog(@"%@",shortShareUrlForWB);
            }
        }
    }
    
    return shortShareUrlForWB;
}

+ (NSString*)urlEncodedString:(NSString *)string
{
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();@&=+$,?%#[]", kCFStringEncodingUTF8 );
    
    return encodedString;
}

@end
