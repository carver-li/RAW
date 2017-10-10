//
//  GLEngine.m
//  DiDiHu
//
//  Created by Kowloon on 15/3/10.
//  Copyright (c) 2015年 GLSX. All rights reserved.
//

#import "GLEngine.h"
#import "GTMBase64.h"
#import "GLClick.h"

@implementation GLEngine

- (id)initWithDefaultSettings{
    self = [super initWithHostName:@"gsc.didihu.com.cn" apiPath:@"batch" customHeaderFields:nil];
    
    if (self) {
        
    }
    
    return self;
}

+ (GLEngine *)shareEngine{
    static GLEngine *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithDefaultSettings];
    });
    
    return sharedInstance;
}

- (MKNetworkOperation *)sendBatchClick:(NSArray *)batch{
    
    if (batch.count == 0) {
        return nil;
    }
    
    MKNetworkOperation *op = nil;
    
    
    NSString *string = [batch componentsJoinedByString:@"|"];
    
    
    NSData *base64 = [GTMBase64 encodeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *content = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"batch": content};
    ASLog(@"GLClick:%@, %@", param, string);
    
    op = [self operationWithPath:nil params:param httpMethod:kHTTPMethodPost];
    
    [op addHeader:@"Accept-Encoding" withValue:@"gzip"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSString *resultString = completedOperation.responseString;
        NSLog(@"Network Success:\n%@,Result:\n%@",completedOperation.url,resultString);
        
        id result = completedOperation.responseJSON;
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [[result objectForKey:@"code"] integerValue];
            if (code == 0) {
                ASLog(@"GSC:%@",batch);
                [GLClick removeClick:batch];
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];
    
    [self enqueueOperation:op];
    
    return op;
}



@end
