//
//  NotificationConstants.h
//  iPhoto
//
//  Created by Carver on 15/7/13.
//  Copyright (c) 2015年 carver. All rights reserved.
//

#ifndef iPhoto_NotificationConstants_h
#define iPhoto_NotificationConstants_h

//应用状态
#define kNotificationNameApplicationBecomeActive @"NotificationNameApplicationBecomeActive"

//登录
#define kNotificationNameLoginSuccessfully @"NotificationNameLoginSuccessfully"
#define kNotificationNameCancelLogin @"NotificationNameCancelLogin"
#define kNotificationNameSessionInvalid @"NotificationNameSessionInvalid"

//图片墙
#define kNotificationNameRefreshPhotoWall @"NotificationNameRefreshPhotoWall"
#define kNotificationNameReportPhoto @"NotificationNameReportPhoto"
#define kNotificationNameStartPostNew @"NotificationNameStartPostNew"
#define kNotificationNameStartAddComment @"NotificationNameStartAddComment"
#define kNotificationNameRefreshPrintPhotoWall @"NotificationNameRefreshPrintPhotoWall"

//发现
#define kNotificationNameFindTreasure @"NotificationNameFindTreasure"
#define kNotificationNameStartFindTreasure @"NotificationNameStartFindTreasure"
#define kNotificationNameFindTreasure @"NotificationNameFindTreasure"

#define kNotificationNamePayForWebResult @"NotificationNamePayForWebResult"

//冲印
#define kNotificationNameBuyPrintCouponSuccess @"NotificationNameBuyPrintCouponSuccess"

//订单
#define kNotificationNameLocalOrderSubmit @"NotificationNameLocalOrderSubmit"
#define kNotificationNameRefreshPrintCouponOrderList @"NotificationNameRefreshPrintCouponOrderList"

//支付
#define kNotificationNameOrderPaySuccess @"kNotificationNameOrderPaySuccess"

//信息
#define kNotificationNameRefreshFocusList @"NotificationNameRefreshFocusList"
#define kNotificationNameNewComment @"NotificationNameNewComment"
#define kNotificationNameNewWhisper @"NotificationNameNewWhisper"

//刷新任务状态
#define kNotificationNameRefreshTaskStatus @"NotificationNameRefreshTaskStatus"

#define kNotificationNameResetStatusBar @"NotificationNameResetStatusBar"

//贴纸+弹幕
#define kNotificationNamePasterViewEditing @"NotificationNamePaterViewEditing"

//推送消息类型定义
#define APNS_Type_message                   0   //系统消息提醒
#define APNS_Type_my_alert                  1   //个人通知提醒
#define APNS_Type_person_message            2   //评论透传消息
#define APNS_Type_coupon_alert              3   //优惠券发放提醒
#define APNS_Type_Photo_alert               4   //图片通知消息
#define APNS_Type_Deliver_alert             5   //发货通知消息
#define APNS_Type_url                       6   //链接

#define kNotificationNameShowAlertDot         @"NotificationNameShowAlertDot"
#define kNotificationNameHideAlertDot         @"NotificationNameHideAlertDot"

#endif
