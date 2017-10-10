//
//  BaseDataModel.h
//  iPhoto
//
//  Created by carver on 15/5/23.
//  Copyright (c) 2015年 carver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSONModel.h"

@interface BaseDataModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *identify;

- (NSString *)getUUIDString;

@end
