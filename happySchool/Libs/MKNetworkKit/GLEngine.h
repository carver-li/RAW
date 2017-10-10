//
//  GLEngine.h
//  DiDiHu
//
//  Created by Kowloon on 15/3/10.
//  Copyright (c) 2015年 GLSX. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface GLEngine : MKNetworkEngine

- (id)initWithDefaultSettings;

+ (GLEngine *)shareEngine;

- (MKNetworkOperation *)sendBatchClick:(NSArray *)batch;

@end
