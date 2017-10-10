//
//  BaseDataModel.m
//  iPhoto
//
//  Created by carver on 15/5/23.
//  Copyright (c) 2015年 carver. All rights reserved.
//

#import "BaseDataModel.h"

@implementation BaseDataModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"identify",@"description":@"desc",@"count":@"countNumber"}];
}

- (NSString *) getUUIDString {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    
    return uuidString;
    
}

@end
