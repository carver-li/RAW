//
//  FileHelper.h
//  iPhoto
//
//  Created by Carver on 15/7/2.
//  Copyright (c) 2015年 carver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

#define LocalAlbumFileName(albumType) [NSString stringWithFormat:@"%@_local_album_%@.json",[UserInfo currentUser].identify,albumType]

#define LocalPostcardFileName [NSString stringWithFormat:@"%@_local_postcard.json",[UserInfo currentUser].identify]

#define LocalDeskCalendarFileName [NSString stringWithFormat:@"%@_local_DeskCalendar.json",[UserInfo currentUser].identify]

@interface FileHelper : NSObject

//获取应用根文件夹
+(NSString *)getHomeDirectory;

//创建用户根文件夹
+(NSString *)createUserDirectory;

//创建用户子文件夹，用于不同的业务.子文件夹位于用户根文件夹下。
+(NSString *)createSubDirectory:(NSString *)subDirectoryName;

//检查文件是否存在
+(BOOL)isFileExist:(NSString *)filePath;

//本地订单Json文件
+(NSString *)getLocalOrderFilePath;

//本地订单图片
+(NSString *)getLocalPhotoFilePath:(NSString *)orderId;
+(void)savePhoto:(NSString *)filePath withPhoto:(UIImage *)photo;
+(void)savePngPhoto:(NSString *)filePath withPhoto:(UIImage *)photo;

+(void)removeFileAtPath:(NSString *)filePath;

//获取相册图片
+(NSString *)getAlbumPhotoPath:(NSString *)fileName;
+(BOOL)saveAlbumPhoto:(NSString *)fileName withPhoto:(UIImage *)photo;
+(BOOL)checkAlbumPhotoExist:(NSString *)fileName;
+(void)deleteAlbumPhoto:(NSString *)fileName;
+(BOOL)copyAlbumPhoto:(NSString *)fileName toAlbumPhoto:(NSString *)toFileName;

//相册背景临时图片
+(UIImage *)getAlbumBGImage;
+(void)deleteAlbumBGImage;

//本地相册Json文件
+(NSString *)getLocalAlbumFilePath:(NSString *)albumType;
+(NSString *)getLocalJsonFilePath:(NSString *)jsonFileName;

//根据文件名获取本地文件路径
+(NSString *)getFilePathByName:(NSString *)fileName;

+(NSString *)getFilePath:(NSString *)directoryName withame:(NSString *)fileName;

//创建12寸相册模板根目录
+(NSString *)createAlbumTemplateDirectory:(NSString *)directoryName;
+(NSString *)getAlbumTemplateFilePath:(NSString *)templateId withFileName:(NSString *)fileName;

@end
