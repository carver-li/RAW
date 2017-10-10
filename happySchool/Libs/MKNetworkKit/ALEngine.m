//
//  GoomeEngine.m
//  BusOnline
//
//  Created by Kowloon on 13-6-18.
//  Copyright (c) 2013年 Goome. All rights reserved.
//

#import "ALEngine.h"
#import "GLClick.h"

@interface ALEngine ()

- (MKNetworkOperation *) sendRequestWithURL:(NSString *)URL
                                 HTTPMethod:(NSString *)method
                                 parameters:(NSDictionary *)parameters
                             postParameters:(NSDictionary *)postParameters
                            otherParameters:(NSDictionary *)other
                                   fileDict:(NSDictionary *)fileDict
                                   delegate:(id)delegate
                          completionHandler:(ALCompletionBlock)completionBlock
                               errorHandler:(MKNKErrorBlock)errorBlock;

@end

@implementation ALEngine

- (id)initWithDefaultSettings{
    self = [super initWithHostName:[Utility serviceURLString] apiPath:@"" customHeaderFields:nil];
    
    if(self) {
        
    }
    
    return self;
}

+ (ALEngine *)shareEngine{
    static ALEngine *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithDefaultSettings];
    });
    
    return sharedInstance;
}

+ (void) cancelOperationsWithClass:(id)Class{
    [self cancelOperationsMatchingBlock:^BOOL (MKNetworkOperation* op) {
        return [op.className isEqualToString:NSStringFromClass([Class class])];
    }];
}

-(MKNetworkOperation *) sendRequestWithURL:(NSString *)URL
                                HTTPMethod:(NSString *)method
                                parameters:(NSDictionary *)parameters
                           otherParameters:(NSDictionary *)other
                                  delegate:(id)delegate
                           responseHandler:(ResponseBlock)responseBlock {
    [Utility event:kEventNetworkRequest];
    
    return [self sendRequestWithURL:URL HTTPMethod:method parameters:parameters postParameters:nil otherParameters:other fileDict:nil delegate:delegate completionHandler:^(id result) {
        responseBlock(nil, result);
    } errorHandler:^(NSError *error) {
        if (other) {
            BOOL isShow = [other getBoolValueForKey:kNetworkParamKeyShowErrorDefaultMessage defaultValue:YES];
            if (isShow) {
                [self showErrMsg:error];
            }
        }
        else {
            [self showErrMsg:error];
        }
        
        responseBlock(error, nil);
    }];
}

- (MKNetworkOperation *) sendRequestWithURL:(NSString *)URL
                                 HTTPMethod:(NSString *)method
                                 parameters:(NSDictionary *)parameters
                             postParameters:(NSDictionary *)postParameters
                            otherParameters:(NSDictionary *)other
                                   delegate:(id)delegate
                            responseHandler:(ResponseBlock)responseBlock {
    return [self sendRequestWithURL:URL HTTPMethod:method parameters:parameters postParameters:postParameters otherParameters:other fileDict:nil delegate:delegate completionHandler:^(id result) {
        responseBlock(nil, result);
    } errorHandler:^(NSError *error) {
        if (other) {
            BOOL isShow = [other getBoolValueForKey:kNetworkParamKeyShowErrorDefaultMessage defaultValue:YES];
            if (isShow) {
                [self showErrMsg:error];
            }
        }
        else {
            [self showErrMsg:error];
        }
        
        responseBlock(error, nil);
    }];
}

- (MKNetworkOperation *) sendRequestWithURL:(NSString *)URL
                                 HTTPMethod:(NSString *)method
                                 parameters:(NSDictionary *)parameters
                             postParameters:(NSDictionary *)postParameters
                            otherParameters:(NSDictionary *)other
                                   fileDict:(NSDictionary *)fileDict
                                   delegate:(id)delegate
                            responseHandler:(ResponseBlock)responseBlock {
    return [self sendRequestWithURL:URL HTTPMethod:method parameters:parameters postParameters:postParameters otherParameters:other fileDict:fileDict delegate:delegate completionHandler:^(id result) {
        responseBlock(nil, result);
    } errorHandler:^(NSError *error) {
        if (other) {
            BOOL isShow = [other getBoolValueForKey:kNetworkParamKeyShowErrorDefaultMessage defaultValue:YES];
            if (isShow) {
                [self showErrMsg:error];
            }
        }
        else {
            [self showErrMsg:error];
        }
        
        responseBlock(error, nil);
    }];
}

- (MKNetworkOperation *) sendRequestWithURL:(NSString *)URL
                                 HTTPMethod:(NSString *)method
                                 parameters:(NSDictionary *)parameters
                             postParameters:(NSDictionary *)postParameters
                            otherParameters:(NSDictionary *)other
                                   fileDict:(NSDictionary *)fileDict
                                   delegate:(id)delegate
                          completionHandler:(ALCompletionBlock)completionBlock
                               errorHandler:(MKNKErrorBlock)errorBlock {
    BOOL fromData = YES;
    
    if (other) {
        fromData = [other getBoolValueForKey:kNetworkParamKeyReturnDataFromKey defaultValue:YES];
    }
    
    NSDate *startDate = [NSDate date];
    
    //Build Param
    NSMutableDictionary *params = [ALEngine dictionaryFromQuery:URL usingEncoding:NSUTF8StringEncoding];
    if (parameters) {
        [params addEntriesFromDictionary:parameters];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [params setValue:[formatter stringFromDate:[NSDate date]] forKey:@"timestamp"];
    [params setValue:@"json" forKey:@"format"];
    [params setValue:@"ios" forKey:@"channel"];
    [params setValue:[self bundleVersion] forKey:@"clientVersion"];
    
    if ([UserInfo isLogin]) {
        [params setValue:[UserInfo currentUser].sessionKey forKey:@"sessionKey"];
        [postParameters setValue:[UserInfo currentUser].sessionKey forKey:@"sessionKey"];
    }
    
    [params setValue:[self createSign:params withMethod:URL] forKey:@"sign"];
    
    if ([method isEqualToString:kHTTPMethodPost] || [method isEqualToString:kHTTPMethodPut]) {
        if ([URL rangeOfString:@"http"].location == NSNotFound) {
            URL = [NSString stringWithFormat:@"%@%@?%@", [Utility serviceURLString],URL,[params urlEncodedKeyValueString]];
        }
        else {
            URL = [NSString stringWithFormat:@"%@?%@", URL,[params urlEncodedKeyValueString]];
        }
        
        params = [NSMutableDictionary dictionaryWithDictionary:postParameters];
        [params setValue:[self createSign:params withMethod:URL] forKey:@"sign"];
    }
    else {
        if ([URL rangeOfString:@"http"].location == NSNotFound) {
            URL = [NSString stringWithFormat:@"%@%@",[Utility serviceURLString],URL];
        }
    }
    
    MKNetworkOperation *op = nil;
    
    if ([URL rangeOfString:@"http"].location == NSNotFound) {
        op = [self operationWithPath:URL
                              params:params
                          httpMethod:method];
    }
    else {
        op = [self operationWithURLString:URL
                                   params:params
                               httpMethod:method];
    }
    
    if (fileDict) {
        for (NSString *key in [fileDict allKeys]) {
            NSString *mimeType = @"image/jpg";
            NSString *fileName = [key stringByAppendingPathExtension:@"jpg"];
            
            if ([other objectForKey:kNetworkParamKeyFileMimeType]) {
                mimeType = [other objectForKey:kNetworkParamKeyFileMimeType];
            }
            
            if ([other objectForKey:kNetworkParamKeyFileName]) {
                fileName = [other objectForKey:kNetworkParamKeyFileName];
            }
            
            [op addData:[fileDict objectForKey:key] forKey:key mimeType:mimeType fileName:fileName];
        }
    }
    
    [op addHeader:@"Accept-Encoding" withValue:@"gzip"];
    
    if (delegate) {
        op.className = NSStringFromClass([delegate class]);
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        ASLog(@"%@", completedOperation.readonlyRequest.allHTTPHeaderFields);
        ASLog(@"Network Success:\n%@,Result:\n%@",completedOperation.url,completedOperation.responseString);
        
        if ([[params objectForKey:@"method"] isEqualToString:@"glsx.common.active.accountfunctions"]){
            CGFloat seconds = fabs([startDate timeIntervalSinceNow]);
            [GLClick logEvent:@"stat-client-mobile-ios-index" code:0 seconds:seconds];
        }
        
        id result = completedOperation.responseJSON;
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            result = [Utility nestedDictionaryByReplacingNullsWithNil:result];
            if (!fromData) {
                completionBlock(result);
                return;
            }
            
            NSInteger code = -1;
            if ([result objectForKey:@"resultCode"] != nil) {
                code = [result getIntValueForKey:@"resultCode" defaultValue:-1];
            }
            else {
                code = [result getIntValueForKey:@"code" defaultValue:-1];
            }
            
            if (code == 0) {
                completionBlock(result);
            }
            else {
                NSString *msg = [result getStringValueForKey:@"result" defaultValue:@""];
                
                if ([msg isEqualToString:@""]) {
                    msg = [result getStringValueForKey:@"msg" defaultValue:@""];
                }
                
                if (code == 1) {
                    msg = @"登录过期，请重新登录！";
                }
                
                NSError *err = [[NSError alloc] initWithDomain:@"" code:code userInfo:@{NSLocalizedDescriptionKey:msg}];
                errorBlock(err);
            }
        }
        else if (result && [result isKindOfClass:[NSArray class]]) {
            completionBlock(result);
        }
        else{
            NSError *err = [[NSError alloc] initWithDomain:@"" code:1 userInfo:@{NSLocalizedDescriptionKey:@""}];
            errorBlock(err);
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [Utility event:kEventNetworkHttpError];
        
        if ([[params objectForKey:@"method"] isEqualToString:@"glsx.common.active.accountfunctions"]){
            CGFloat seconds = fabs([startDate timeIntervalSinceNow]);
            [GLClick logEvent:@"stat-client-mobile-ios-index" code:error.code seconds:seconds];
        }
        
        NSError *err = [[NSError alloc] initWithDomain:@"" code:error.code userInfo:@{NSLocalizedDescriptionKey:[error localizedDescription]}];
        errorBlock(err);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (NSString *)createSign:(NSDictionary *)params withMethod:(NSString *)method {
    if (params == nil || params.count == 0) {
        return nil;
    }
    
    NSString *sign = @"";
    NSMutableDictionary *signDictionary = [NSMutableDictionary dictionaryWithDictionary:params];
    [signDictionary setObject:method forKey:@"method"];
    
    NSArray *keys = [signDictionary.allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSString *key in keys) {
        sign = [NSString stringWithFormat:@"%@%@=%@||",sign, key,signDictionary[key]];
    }
    
    sign = [sign substringToIndex:sign.length - 2];
    
    return [Utility MD5:sign];
}

- (void)showErrMsg:(NSError *)err{
    NSString *msg = @"";
    NSInteger code = 0;
    
    if (err.localizedDescription.length > 0) {
        if (err.code == 500
            || [err.localizedDescription isEqualToString:@"未能找到使用指定主机名的服务器。"]) {
            code = 1;
        }
        else {
            msg = err.localizedDescription;
        }
    }
    else if (err.code > 0) {
        code = err.code;
    }
    
    if (err && err.code == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameSessionInvalid object:self];
        msg = @"登录过期，请重新登录！";
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [Utility showErrorMsg:[UIApplication sharedApplication].keyWindow type:code msg:msg];
    });
}

+ (NSMutableDictionary *)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    NSScanner *scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return pairs;
}

@end
