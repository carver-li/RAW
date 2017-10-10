//
//  GLClick.m
//  DiDiHu
//
//  Created by Kowloon on 15/3/10.
//  Copyright (c) 2015年 GLSX. All rights reserved.
//

#import "GLClick.h"
#import "GLEngine.h"

static NSString *kLocalClick = @"kLocalClick";

@interface GLClick ()

@property (nonatomic, copy) NSString *appKey;

+ (GLClick *)shareClick;

@end

@implementation GLClick

+ (GLClick *)shareClick{
    static GLClick *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (void)startWithAppkey:(NSString *)appKey{
    [GLClick shareClick].appKey = appKey;
    [[GLClick shareClick] sendClick];
}

+ (void)logEvent:(NSString *)eventName code:(NSInteger)code seconds:(CGFloat)seconds{
    GLClick *click = [GLClick shareClick];
    NSDictionary *param = @{@"cp": click.appKey,
                            @"pp": eventName,
                            @"ec": [NSString stringWithFormat:@"%ld", (long)code],
                            @"e": [NSString stringWithFormat:@"%d", (int)(seconds*1000)],
                            @"t": [[NSDate date] stringWithFormat:@"yyyyMMddHHmm"]};
    NSMutableString *event = [NSMutableString string];
    [param enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (event.length > 0) {
            [event appendFormat:@"&"];
        }
        [event appendFormat:@"%@=%@", key, obj];
    }];
    
    [click saveClick:event];
}

- (NSMutableArray *)localClick{
    NSArray *local = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalClick];
    if (local && [local isKindOfClass:[NSArray class]]) {
        return [NSMutableArray arrayWithArray:local];
    }
    
    return [NSMutableArray array];
}

- (void)saveClick:(NSString *)event{
    if (event.length == 0) {
        return;
    }
    
    NSMutableArray *local = [self localClick];
    [local addObject:event];
    [[NSUserDefaults standardUserDefaults] setObject:local forKey:kLocalClick];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sendClick{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *local = [self localClick];
        if ([local count] > 0) {
            [[GLEngine shareEngine] sendBatchClick:local];
        }
    });
}

+ (void)removeClick:(NSArray *)events{
    NSMutableArray *local = [[GLClick shareClick] localClick];
    [local removeObjectsInArray:events];
    [[NSUserDefaults standardUserDefaults] setObject:local forKey:kLocalClick];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
