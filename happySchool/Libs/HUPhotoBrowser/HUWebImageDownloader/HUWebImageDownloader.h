//
//  HUWebImageDownloader.h
//  HUPhotoBrowser
//
//  Created by mac on 16/2/25.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HUWebImageOption) {
    HUWebImageOptionNone,
    HUWebImageOptionMemoryOnely,
    HUWebImageOptionMemoryAndDisk,
};

typedef void(^HUDownloadCompletionBlock)(UIImage *image, NSError *error, NSURL *imageUrl);

@class HUWebImageDownloadOperation;
@interface HUWebImageDownloader : NSObject

+ (instancetype)sharedInstance;
+ (NSString *)cacheKeyForURL:(NSURL *)url;
+ (UIImage *)imageFromDiskCacheForKey:(NSString *)key;
+ (UIImage *)imageFromMemoryCacheForKey:(NSString *)key;
+ (HUWebImageDownloadOperation *)downloadImageWithURL:(NSURL *)url completed:(HUDownloadCompletionBlock)completeBlock;
+ (HUWebImageDownloadOperation *)downloadImageWithURL:(NSURL *)url option:(HUWebImageOption)option completed:(HUDownloadCompletionBlock)completeBlock;

- (NSString *)cacheKeyForURL:(NSURL *)url;
- (UIImage *)imageFromDiskCacheForKey:(NSString *)key;
- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key;
- (void)saveImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;


- (HUWebImageDownloadOperation *)downloadImageWithURL:(NSURL *)url completed:(HUDownloadCompletionBlock)completeBlock;


- (HUWebImageDownloadOperation *)downloadImageWithURL:(NSURL *)url option:(HUWebImageOption)option completed:(HUDownloadCompletionBlock)completeBlock;

@property (nonatomic) BOOL shouldCacheImagesInMemory;

@end
