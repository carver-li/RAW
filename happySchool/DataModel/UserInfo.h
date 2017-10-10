//
//  UserInfo.h
//  爱车汇
//
//  Created by Sean on 14-5-20.
//  Copyright (c) 2014年 GLSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+ASCategory.h"

@interface UserInfo : NSObject

@property (nonatomic,copy) NSString *identify;

//登录账号
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *sessionKey;

//用户信息
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *displayid;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,copy) NSString *level;
@property (nonatomic,copy) NSString *leveldiscount;
@property (nonatomic,copy) NSString *thumbsmall;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,assign) int begoodcount;
@property (nonatomic,assign) int score;
@property (nonatomic,assign) int printcount;
@property (nonatomic,assign) int couponcount;
@property (nonatomic,assign) int remarkcount;
@property (nonatomic,assign) BOOL issign;
@property (nonatomic,assign) int signcount;
@property (nonatomic,assign) int signamount;

//位置信息
@property (nonatomic,copy) NSString *detailAddress;
@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lon;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *cityname;
@property (nonatomic,strong) NSString *cityCode;

//价格信息
@property (nonatomic,strong) NSArray *priceInfoList;
@property (nonatomic,assign) int noPostage;     //订单免运费价格

//等级信息
@property (nonatomic,strong) NSArray *levelInfoList;

//我的关注用户，并包括应该启动前的关注用户，只有本次应用启动新关注的用户
@property (nonatomic,strong) NSMutableArray *myFocusList;
@property (nonatomic,strong) NSMutableArray *myUnfocusList;

//用户本地订单列表
@property (nonatomic,strong) NSMutableArray *localOrderList;

//订单照片最后上传时间，当最后上传时间在5分钟前，进入确认订单页面，尝试重置上传失败照片状态
@property (nonatomic,strong) NSDate *latestUploadDate;

//记录推送通知被点赞超过一定数量的发布ID
@property (nonatomic,strong) NSMutableArray *myPostAlertIds;

//缓存贴纸数据
@property (nonatomic,strong) NSArray *imageMarkGroups;

+ (UserInfo *)currentUser;

- (void)login:(NSDictionary*)logindata;

- (void)refreshAccountInfo:(NSDictionary*)accountdata;

- (void)logout;

- (void)updateLocalUserInfo;

+ (BOOL)isLogin;

@end
