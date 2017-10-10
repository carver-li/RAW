//
//  UserInfo.m
//  爱车汇
//
//  Created by Sean on 14-5-20.
//  Copyright (c) 2014年 GLSX. All rights reserved.
//

#import "UserInfo.h"

#define kLocalUserData @"LocalUserData"

@implementation UserInfo

-(id)init
{
    if (self=[super init]) {
        self.level = @"V1";
        self.leveldiscount = @"1";
        self.identify = @"";
        self.displayid = @"";
        self.begoodcount = 0;
        self.score = 0;
        self.printcount = 0;
        self.couponcount = 0;
        self.remarkcount = 0;
        self.leveldiscount = @"1";
        self.myFocusList = [NSMutableArray array];
        self.myUnfocusList = [NSMutableArray array];
        self.localOrderList = [NSMutableArray array];
        self.myPostAlertIds = [NSMutableArray array];
        self.noPostage = 49;
        self.signcount = 0;
        self.signamount = 0;
    }
    
    return self;
}

+ (UserInfo *)currentUser {
    static UserInfo *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithLocal];
    });
    
    return sharedInstance;
}

- (instancetype)initWithLocal {
    if (self = [self init]) {
        NSDictionary *data = [self localUserData];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            self.name = [data getStringValueForKey:@"name" defaultValue:@""];
            self.displayid = [data getStringValueForKey:@"displayid" defaultValue:@""];
            self.nickname = [data getStringValueForKey:@"nickname" defaultValue:@""];
            self.mobile = [data getStringValueForKey:@"mobile" defaultValue:@""];
            self.password = [data getStringValueForKey:@"password" defaultValue:@""];
            self.sessionKey = [data getStringValueForKey:@"sessionKey" defaultValue:@""];
            self.identify = [data getStringValueForKey:@"identify" defaultValue:@""];
            
            self.thumb = [data getStringValueForKey:@"thumb" defaultValue:@""];
            self.thumbsmall = [data getStringValueForKey:@"thumbsmall" defaultValue:@""];
            self.sex = [data getStringValueForKey:@"sex" defaultValue:@""];
            self.cityname = [data getStringValueForKey:@"city" defaultValue:@""];
            self.cityCode = [data getStringValueForKey:@"cityCode" defaultValue:@""];
            self.begoodcount = [data getIntValueForKey:@"begoodcount" defaultValue:0];
            self.score = [data getIntValueForKey:@"score" defaultValue:0];
            self.printcount = [data getIntValueForKey:@"printcount" defaultValue:0];
            self.couponcount = [data getIntValueForKey:@"couponcount" defaultValue:0];
            self.remarkcount = [data getIntValueForKey:@"remarkcount" defaultValue:0];
            self.level = [data getStringValueForKey:@"level" defaultValue:@""];
            self.leveldiscount = [data getStringValueForKey:@"leveldiscount" defaultValue:@""];
        }
    }
    
    return self;
}

- (NSDictionary *)dictionary{
    return @{@"identify": [NSString stringWithFormat:@"%@",self.identify?self.identify:@""],
             @"sessionKey": [NSString stringWithFormat:@"%@",self.sessionKey?self.sessionKey:@""],
             @"name": [NSString stringWithFormat:@"%@",self.name?self.name:@""],
             @"displayid": [NSString stringWithFormat:@"%@",self.displayid?self.displayid:@""],
             @"nickname": [NSString stringWithFormat:@"%@",self.nickname?self.nickname:@""],
             @"mobile": [NSString stringWithFormat:@"%@",self.mobile?self.mobile:@""],
             @"thumb": [NSString stringWithFormat:@"%@",self.thumb?self.thumb:@""],
             @"thumbsmall": [NSString stringWithFormat:@"%@",self.thumbsmall?self.thumbsmall:@""],
             @"sex": [NSString stringWithFormat:@"%@",self.sex?self.sex:@"M"],
             @"begoodcount": [NSString stringWithFormat:@"%d",self.begoodcount],
             @"score": [NSString stringWithFormat:@"%d",self.score],
             @"city": [NSString stringWithFormat:@"%@",self.cityname?self.cityname:@""],
             @"cityCode": [NSString stringWithFormat:@"%@",self.cityCode?self.cityCode:@""],
             @"printcount": [NSString stringWithFormat:@"%d",self.printcount],
             @"couponcount": [NSString stringWithFormat:@"%d",self.couponcount],
             @"remarkcount": [NSString stringWithFormat:@"%d",self.remarkcount],
             @"level": [NSString stringWithFormat:@"%@",self.level],
             @"leveldiscount": [NSString stringWithFormat:@"%@",self.leveldiscount]};
}

- (NSDictionary *)localUserData {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLocalUserData];
}

-(void)login:(NSDictionary*)logindata
{
    [self refreshAccountInfo:logindata];
}

- (void)refreshAccountInfo:(NSDictionary*)accountdata
{
    self.identify = [NSString stringWithFormat:@"%@",[accountdata objectForKey:@"id"]];
    self.sessionKey = [accountdata objectForKey:@"sessionKey"];
    self.name = [accountdata objectForKey:@"name"];
    self.displayid = [accountdata objectForKey:@"displayid"];
    self.nickname = [accountdata objectForKey:@"nickname"];
    self.thumb = [accountdata objectForKey:@"thumb"];
    self.thumbsmall = [accountdata objectForKey:@"thumbsmall"];
    self.sex = [accountdata objectForKey:@"sex"];
    self.begoodcount = [[accountdata objectForKey:@"begoodcount"] intValue];
    self.score = [[accountdata objectForKey:@"score"] intValue];
    self.printcount = [[accountdata objectForKey:@"printcount"] intValue];
    self.couponcount = [[accountdata objectForKey:@"couponcount"] intValue];
    self.remarkcount = [[accountdata objectForKey:@"remarkcount"] intValue];
    self.cityname = [accountdata objectForKey:@"city"];
    self.cityCode = [accountdata objectForKey:@"cityCode"];
    self.level = [accountdata objectForKey:@"level"];
    self.leveldiscount = [accountdata objectForKey:@"leveldiscount"];
    
    [self updateLocalUserInfo];
}

-(void)logout
{
    self.identify = @"";
    self.displayid = @"";
    self.name = @"";
    self.mobile = @"";
    self.password = @"";
    self.sessionKey = @"";
    self.thumb = @"";
    self.thumbsmall = @"";
    self.sex = @"";
    self.cityname = @"";
    self.cityCode = @"";
    self.level = @"V1";
    self.leveldiscount = @"1";
    
    self.begoodcount = 0;
    self.score = 0;
    self.printcount = 0;
    self.couponcount = 0;
    self.remarkcount = 0;
    self.leveldiscount = @"1";
    self.myFocusList = [NSMutableArray array];
    self.myUnfocusList = [NSMutableArray array];
    self.localOrderList = [NSMutableArray array];
    self.noPostage = 49;
    self.signcount = 0;
    self.signamount = 0;
    
    [self updateLocalUserInfo];
}

- (void)updateLocalUserInfo {
    //更新本地缓存
    if (self.mobile && self.mobile.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.mobile forKey:@"MobileKey"];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[self dictionary] forKey:kLocalUserData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isLogin {
    return [UserInfo currentUser].sessionKey.length > 0;
}

@end
