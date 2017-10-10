//
//  NSArray+ASCategory.m
//  Supplement
//
//  Created by Kowloon on 12-4-28.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import "NSArray+ASCategory.h"
#import "NSObject+ASCategory.h"

@implementation NSArray (ASCategory)

- (NSArray *)sortedArrayUsingDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [self sortedArrayUsingDescriptors:sortDescriptors];
}

- (id)objectAtTheIndex:(NSUInteger)index
{
    if (![self isKindOfClass:[NSArray class]]) {
        return nil;
    } else if (index >= self.count) {
        return nil;
    } else {
        return [self objectAtIndex:index];
    }
}

- (id)firstObject{
    return [self objectAtTheIndex:0];
}

@end
