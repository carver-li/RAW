//
//  UUMessage.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUMessage.h"
#import "NSDate+ASCategory.h"

@implementation UUMessage
- (void)setWithDict:(NSDictionary *)dict{
    
    self.strIcon = dict[@"strIcon"];
    self.strName = dict[@"strName"];
    self.strId = dict[@"strId"];
    self.strTime = [self changeTheDateString:dict[@"strTime"]];
    self.from = [dict[@"from"] intValue];
    
    switch ([dict[@"type"] integerValue]) {
        
        case 0:
            self.type = UUMessageTypeText;
            self.strContent = dict[@"strContent"];
            break;
        
        case 1:
            self.type = UUMessageTypePicture;
            
            if (dict[@"picture"]) {
                self.picture = dict[@"picture"];
            }
            
            if (dict[@"pictureUrl"]) {
                self.pictureUrl = dict[@"pictureUrl"];
            }
            
            break;
        
        case 2:
            self.type = UUMessageTypeVoice;
            
            if (dict[@"voice"]) {
                self.voice = dict[@"voice"];
            }
            
            if (dict[@"voiceUrl"]) {
                self.voiceUrl = dict[@"voiceUrl"];
            }
            
            self.strVoiceTime = dict[@"strVoiceTime"];
            break;
            
        default:
            break;
    }
}

//设置今天，昨天，或者日期
- (NSString *)changeTheDateString:(NSString *)Str
{
    NSDate *lastDate = [NSDate dateFromString:Str withFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [NSDate compareTodayYesterdayTomorrowDate:lastDate];
}

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end
{
    if (!start) {
        self.showDateLabel = YES;
        return;
    }
    
    NSString *subStart = [start substringWithRange:NSMakeRange(0, 19)];
    NSDate *startDate = [NSDate dateFromString:subStart withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *subEnd = [end substringWithRange:NSMakeRange(0, 19)];
    NSDate *endDate = [NSDate dateFromString:subEnd withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //这个是相隔的秒数
    NSTimeInterval timeInterval = [startDate timeIntervalSinceDate:endDate];
    
    //相距5分钟显示时间Label
    if (fabs (timeInterval) > 5*60) {
        self.showDateLabel = YES;
    }else{
        self.showDateLabel = NO;
    }
    
}
@end
