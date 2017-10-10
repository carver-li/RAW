//
//  GLClick.h
//  DiDiHu
//
//  Created by Kowloon on 15/3/10.
//  Copyright (c) 2015年 GLSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ASSupplement.h"

@interface GLClick : NSObject

///---------------------------------------------------------------------------------------
/// @name  开启统计
///---------------------------------------------------------------------------------------


/** 初始化统计模块
 
 @param appKey GSC Key.
 @return void
 */

+ (void)startWithAppkey:(NSString *)appKey;

///---------------------------------------------------------------------------------------
/// @name  事件计时
///---------------------------------------------------------------------------------------

/** 手动事件时长统计, 记录某个页面展示的时长.
 @param eventName 统计的事件名称.
 @param seconds 单位为秒，CGFloat型.
 @param code 事件状态
 @return void.
 */

+ (void)logEvent:(NSString *)eventName code:(NSInteger)code seconds:(CGFloat)seconds;

+ (void)removeClick:(NSArray *)events;

@end
