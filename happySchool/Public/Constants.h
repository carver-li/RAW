//
//  Constants.h
//  iPhoto
//
//  Created by carver on 15/5/20.
//  Copyright (c) 2015年 carver. All rights reserved.
//

#import "Utility.h"

#ifndef iPhoto_Constants_h
#define iPhoto_Constants_h

/***************    服务器    ***************/
//内部环境
//#define BASE1 @"http://192.168.1.200"
#define BASE1 @"http://mobile.showtou.com"
#define OSSHOST1 @"http://imagestest.showtou.com"
#define OSSBuckect1 @"showtoutest"

//生产环境
#define BASE2 @"https://mobile.izhaopian.cn"
#define OSSHOST2 @"http://images.showtou.com"
#define OSSBuckect2 @"showtou"

/***************    高宽    ***************/
#define kWindowWidth                    CGRectGetWidth([UIScreen mainScreen].bounds)
#define kWindowHeight                   CGRectGetHeight([UIScreen mainScreen].bounds)
#define KWindowScale                    kWindowHeight/kWindowWidth
#define KStatusBarHeight                20.0f
#define KNAVIGATION_BAR_HEIGHT          44.0f
#define kTabBarHeight                   49.0f

#define kWindowHeightWithoutTabbar (kWindowHeight - kTabBarHeight)
#define KWindowHeightWithoutNavigationBar (kWindowHeight - 64)
#define kWindowHeightWithoutNavigationBarAndTabbar (KWindowHeightWithoutNavigationBar - kTabBarHeight)

#define kContentFrameWithoutNavigationBar CGRectMake(0, 0, kWindowWidth, KWindowHeightWithoutNavigationBar)

/***************    颜色    ***************/
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define MainBackgroundColor RGB(246, 246, 246)  //#F6F6F6
#define MainBlueColor       RGB(34, 85, 171)   //#
#define MainYellowColor     RGB(197, 98, 44)   //#

#define Text333             RGB(51, 51, 51)     //#333333
#define Text666             RGB(102, 102, 102)  //#666666
#define Text999             RGB(153, 153, 153)  //#999999

#define TextInvalidColor    RGB(174, 174, 174)
#define TextLightGrayColor  RGB(234, 234, 234)  //eaeaea
#define TextLightRedColor   RGB(236, 140, 67)
#define TextRedColor        RGB(250, 67, 67)
#define TableHeaderFooterBackgroundColor RGB(208, 208, 208)

#define ILocalizedString(text) NSLocalizedString(text, nil)

/***************    分享登录    ***************/
//微信
#define kWXAPP_ID @"wx764a610a9c24b2a5"
#define kWXAPP_SECRET @"1c326f4162274016cc3cc99657e98f12"

//QQ
#define kQQAPP_ID @"1104612883"
#define kQQAPP_KEY @"wInJoi4jsb0DiqFC"

//友盟
#define UMSOCIAL_APPKEY @"5572b24067e58e4d6a003978"

//新浪微博
#define SINAAPP_KEY @"1317693734"
#define SINAAPP_SECRET @"2fd56ee5300ce06ed6ddeb7fa353ed7c"

//个推生产环境
#define kGETUIAppId           @"b1ghXhwhfr6gUwYEATUMP3"
#define kGETUIAppKey          @"KsJwNHF5JG83G3n0br73S4"
#define kGETUIAppSecret       @"bmAOslK9QXAC0APv5PXIDA"

//个推开发环境
#define kGETUIAppIdDev           @"ZVsmR7fW9m9uQQqhq2a5h9"
#define kGETUIAppKeyDev          @"ARaJnKQOMM99bVZ6aTFi92"
#define kGETUIAppSecretDev       @"WBhVIRHGLo82dfc51hWYo6"

//高德地图
#define LBS_KEY     @"a001f7e75e4098b6b1ac659a7d576434"
#define LBS_KEY_Dev @"b516af5e78712a4c3a63ff340fc76158"

//定义宏（限制输入内容）
/*
 使用方式
 NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
 NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
 BOOL basic = [string isEqualToString:filtered];
 */
#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kNumbers     @"0123456789"
#define kNumbersPeriod  @"0123456789."
#define kSpecificSymbol @" "

//Size by string
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define DDH_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

/***************    统计网络请求    ***************/
#define kEventNetworkError @"network_error"
#define kEventNetworkHttpError @"network_http_error"
#define kEventNetworkRequest @"network_request"

/***************    统计使用功能次数    ***************/
#define kEventCategoryList @"Category_List"

#define kEventFlush5Inch @"event_Flush_5_Inch"
#define kEventFlush6Inch @"event_Flush_6_Inch"
#define kEventFlush7Inch @"event_Flush_7_Inch"
#define kEventFlush8Inch @"event_Flush_8_Inch"
#define kEventFlushLOMO @"event_Flush_LOMO"
#define kEventSeeTopic @"event_see_topic"
#define kEventPrintFullPhoto @"event_Print_Full_Photo"
#define kEventPrintLOMO @"event_Print_LOMO"
#define kEventPrintIDPhoto @"event_Print_ID_Photo"
#define kEventAlbum6Inch @"event_Album_6_Inch"
#define kEventAlbum8Inch @"event_Album_8_Inch"
#define kEventPublishEditPhoto @"event_Publish_Edit_Photo"
#define kEventPrintLOMOEditPhoto @"event_Print_LOMO_Edit_Photo"
#define kEventAddPaster @"event_add_paster"
#define kEventLottery @"event_lottery"
#define kEventPeopleRecommend @"event_people_recommend"
#define kEventPrintWall @"event_print_wall"
#define kEventCalendar @"event_calendar"
#define kEventPostCard @"event_postcard"
#define KEventNewAlbum8Inch @"event_new_album_8_inch"

/***************    当前位置信息    ***************/
#define LatitudeKey @"LatitudeKey"
#define LongitudeKey @"LongitudeKey"
#define NowCityKey @"NowCityKey"

/***************    支付    ***************/
#define ALipayPartner @"2088811861073441"
#define ALipaySeller @"showtou@qq.com"
#define ALipayPrivateKey @"MIICXQIBAAKBgQDPWb+DR57ZYuKJjR5jsMcJ4zhFXnWKokhYAIuYBiiuShXPnY/a1Oe2OjFK+iuMsf+k3drouJ5HvzakvUqo+0wW1lG45zUUahiSpO3P3+ncm5K8BqecIZGnV3/8jV9G3fKqyRSkr1MseaupWCf7bla6qIssdwp6FME7mVDVE5EiqwIDAQABAoGAL9wgV1X1tWmcrnEzPYF1P7QBrglSijBREHb3wZxSUYBqLmTI6pLP9QDTleHOoYgIYO6Qc70BU8AwBbBnhj+S3Rwe2+j4FUEofLonJdlObpKNrVxCmSY9+hmnHVjspl5/7VnCKPyUge9CmAVaXmscRy/A7FFmv1VhSzgKBPNI9ikCQQDwtr/iTgcj1OrSZVIhv7BFOPztgzJ/kLuIWOnJsb7HCX8PcZan0dySu6hck1IA+6UDiC5liuUbYDz+QIqW8TK1AkEA3ISdzhZ7+6/zQYkmsryYqgP68LraxLHDwf/g9UwZRcztnySoi1Afwk5ueljgGTfHAEcS8kG265e28ky1JlV73wJBANK+HLaju6qKQWAcZtC3QzsHjqDeyTpX22ee+GemHzGgxcYem1in6mXot5j9PcEwj6LM+lnaRYU3N48dsHhACTUCQF9f+ESfUuZrlkFdCWC60yiNaiZeGqqB3BH3EpvlWvTmikuPdloywFmwxHWkJOCjUC2dj+M5at0AlD690IeQ528CQQC+AAlDAZM73q+ZRSl4Vn8i3e4iZPcQ/SzfDserX+kx+jmtSiISKx5KifHf+fp+YvAEZcKuvhtrRn73Ta8TozH3"

#define AlertRedDotHomeTag          0
#define AlertRedDotPrintTag         1
#define AlertRedDotDiscoveryTag     3
#define AlertRedDotMyTag            4

//新用户引导标志
#define kNewUserGuideForHome            @"NewUserGuideForHome"
#define kNewUserGuideForFlush           @"NewUserGuideForFlush"
#define kNewUserGuideForDiscovery       @"NewUserGuideForDiscovery"
#define kNewUserGuideForPrivateMessage  @"NewUserGuideForPrivateMessage"
#define kNewUserGuideForPhoneShell      @"NewUserGuideForPhoneShell"
#define kNewUserGuideForCreateAlbum     @"NewUserGuideForCreateAlbum"
#define kNewUserGuideForCreatePostcard  @"NewUserGuideForCreatePostcard"
#define kNewUserGuideForCreateCalendar  @"NewUserGuideForCreateCalendar"
#define kNewUserGuideForEditAlbum12     @"NewUserGuideForEditAlbum12"
#define kNewUserGuideForPreviewAlbum12  @"NewUserGuideForPreviewAlbum12"

#define kClearOldVersionAlbum @"ClearOldVersionAlbum"

//camera 360 带裁剪和旋转功能
#define Camera360DevKey @"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"

//不带裁剪和旋转功能
#define Camera360Key @"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"

#endif
