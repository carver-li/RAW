//
//  FileHelper.m
//  iPhoto
//
//  Created by Carver on 15/7/2.
//  Copyright (c) 2015年 carver. All rights reserved.
//

#import "FileHelper.h"

#define LocalOrderFileName [NSString stringWithFormat:@"%@_local_orders.json",[UserInfo currentUser].identify]
#define LocalPhotosFileName(orderId) [NSString stringWithFormat:@"%@_shopping_cart_photos_%@.json",[UserInfo currentUser].identify,orderId]

@implementation FileHelper

+(NSString *)getHomeDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    return libraryDirectory;
}

+(NSString *)createUserDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *userDirectory = [libraryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_user_directory",[UserInfo currentUser].identify]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:userDirectory]) {
        [fileManager createDirectoryAtPath:userDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return userDirectory;
}

+(NSString *)createSubDirectory:(NSString *)subDirectoryName {
    NSString *userDirectory = [FileHelper createUserDirectory];
    NSString *subDirectory = [userDirectory stringByAppendingPathComponent:subDirectoryName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:subDirectory]) {
        [fileManager createDirectoryAtPath:subDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return subDirectory;
}

+(BOOL)isFileExist:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        return true;
    }
    
    return false;
}

+(NSString *)getFilePathByName:(NSString *)fileName {
    NSString *userDirectory = [self createUserDirectory];
    NSString *filePath = [userDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        NSMutableArray *items = [NSMutableArray array];
        //convert object to data
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:items
                                                          options:NSJSONWritingPrettyPrinted error:nil];
        [fileManager createFileAtPath:filePath contents:jsonData attributes:nil];
    }
    
    return filePath;
}

+(NSString *)getFilePath:(NSString *)subDirectoryName withame:(NSString *)fileName {
    NSString *subDirectory = [FileHelper createSubDirectory:subDirectoryName];
    NSString *filePath = [subDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        NSMutableArray *items = [NSMutableArray array];
        //convert object to data
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:items
                                                          options:NSJSONWritingPrettyPrinted error:nil];
        [fileManager createFileAtPath:filePath contents:jsonData attributes:nil];
    }
    
    return filePath;
}

+(NSString *)createAlbumTemplateDirectory:(NSString *)directoryName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *userDirectory = [libraryDirectory stringByAppendingPathComponent:@"album_template_directory"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:userDirectory]) {
        [fileManager createDirectoryAtPath:userDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return [userDirectory stringByAppendingPathComponent:directoryName];
}

+(NSString *)getAlbumTemplateFilePath:(NSString *)templateId withFileName:(NSString *)fileName {
    NSString *fileDirectory = [FileHelper createAlbumTemplateDirectory:templateId];
    NSString *filePath = [fileDirectory stringByAppendingPathComponent:fileName.lastPathComponent];
    return filePath;
}

+(NSString *)getLocalOrderFilePath {
    NSString *userFilePath = [FileHelper getFilePathByName:LocalOrderFileName];
    return userFilePath;
}

+(NSString *)getLocalPhotoFilePath:(NSString *)orderId {
    if (orderId == nil) {
        orderId = @"-1";
    }
    
    NSString *userFilePath = [FileHelper getFilePathByName:LocalPhotosFileName(orderId)];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:userFilePath]) {
        NSMutableArray *items = [NSMutableArray array];
        //convert object to data
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:items
                                                          options:NSJSONWritingPrettyPrinted error:nil];
        [fileManager createFileAtPath:userFilePath contents:jsonData attributes:nil];
    }
    
    return userFilePath;
}

+(void)savePhoto:(NSString *)filePath withPhoto:(UIImage *)photo {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filePath contents:UIImageJPEGRepresentation(photo, 0.8) attributes:nil];
}

+(void)savePngPhoto:(NSString *)filePath withPhoto:(UIImage *)photo {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:filePath contents:UIImagePNGRepresentation(photo) attributes:nil];
}

+(void)removeFileAtPath:(NSString *)filePath {
    if (filePath == nil) {
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

+(NSString *)getLocalAlbumFilePath:(NSString *)albumType {
    return [FileHelper getLocalJsonFilePath:LocalAlbumFileName(albumType)];
}

+(NSString *)getLocalJsonFilePath:(NSString *)jsonFileName {
    NSString *userFilePath = [FileHelper getFilePathByName:jsonFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:userFilePath]) {
        //convert object to data
        NSMutableArray *items = [NSMutableArray array];
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:items
                                                          options:NSJSONWritingPrettyPrinted error:nil];
        [fileManager createFileAtPath:userFilePath contents:jsonData attributes:nil];
    }
    
    return userFilePath;
}

//获取相册图片
+(NSString *)getAlbumPhotoPath:(NSString *)fileName {
    NSString *localDirectory = [self createUserDirectory];
    return [localDirectory stringByAppendingPathComponent:fileName];
}

+(BOOL)saveAlbumPhoto:(NSString *)fileName withPhoto:(UIImage *)photo {
    NSString *filePath = [self getAlbumPhotoPath:fileName];
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:&error];
    }
    
    BOOL result = [fileManager createFileAtPath:filePath contents:UIImageJPEGRepresentation(photo, 0.8) attributes:nil];
    return result;
}

+(BOOL)copyAlbumPhoto:(NSString *)fileName toAlbumPhoto:(NSString *)toFileName {
    NSString *filePath = [self getAlbumPhotoPath:fileName];
    NSString *toFilePath = [self getAlbumPhotoPath:toFileName];
    NSError *error = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager copyItemAtPath:filePath toPath:toFilePath error:&error];
    }

    return error?NO:YES;
}

+(BOOL)checkAlbumPhotoExist:(NSString *)fileName {
    NSString *filePath = [self getAlbumPhotoPath:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    }
    
    return NO;
}

+(void)deleteAlbumPhoto:(NSString *)fileName {
    NSString *filePath = [self getAlbumPhotoPath:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

+(UIImage *)getAlbumBGImage {
    return nil;
}

+(void)deleteAlbumBGImage {
    
}

@end
