//
//  GoomeEngine.h
//  BusOnline
//
//  Created by Kowloon on 13-6-18.
//  Copyright (c) 2013年 Goome. All rights reserved.
//

#import "MKNetworkEngine.h"

typedef void (^HttpRequestBlock) (NSArray* result);
typedef void (^HttpRequestCommonBlock) (id result);
typedef void (^HttpRequestResultsBlock) (NSArray* result, id otherResult);

#define kNetworkParamKeyShowErrorDefaultMessage @"showErrorDefaultMessage"
#define kNetworkParamKeyCancelOperationsFromURL @"CancelOperationsFromURL"
#define kNetworkParamKeyReturnDataFromKey       @"ReturnDataFromKey"

#define kNetworkParamKeyFileMimeType @"FileMimeTypeHttpContentKey"
#define kNetworkParamKeyFileName @"FileNameHttpContentKey"

static NSString * const kNetworkDataKey                  = @"data";
static NSString * const kNetworkSuccessKey               = @"status";
static NSString * const kNetworkMessageKey               = @"msg";
static NSString * const kNetworkErrorCodeKey             = @"errcode";

@class BCImage;

@interface ALEngine : MKNetworkEngine

typedef void (^ALCompletionBlock)(id result);

typedef void (^ResponseBlock)(NSError *error, id result);

- (id)initWithDefaultSettings;

+ (ALEngine *)shareEngine;

-(MKNetworkOperation *) sendRequestWithURL:(NSString *)URL
                                HTTPMethod:(NSString *)method
                                parameters:(NSDictionary *)parameters
                           otherParameters:(NSDictionary *)other
                                  delegate:(id)delegate
                           responseHandler:(ResponseBlock)responseBlock;

- (MKNetworkOperation *) sendRequestWithURL:(NSString *)URL
                                 HTTPMethod:(NSString *)method
                                 parameters:(NSDictionary *)parameters
                             postParameters:(NSDictionary *)postParameters
                            otherParameters:(NSDictionary *)other
                                   delegate:(id)delegate
                            responseHandler:(ResponseBlock)responseBlock;

- (MKNetworkOperation *) sendRequestWithURL:(NSString *)URL
                                 HTTPMethod:(NSString *)method
                                 parameters:(NSDictionary *)parameters
                             postParameters:(NSDictionary *)postParameters
                            otherParameters:(NSDictionary *)other
                                   fileDict:(NSDictionary *)fileDict
                                   delegate:(id)delegate
                            responseHandler:(ResponseBlock)responseBlock;

+ (void)cancelOperationsWithClass:(id)Class;

@end
