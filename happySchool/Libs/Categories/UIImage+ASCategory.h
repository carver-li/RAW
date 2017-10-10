//
//  UIImage+ASCategory.h
//  FollowMe
//
//  Created by Kowloon on 12-7-13.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>

@interface UIImage (ASCategory)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size;

+ (CGSize) fitSize: (CGSize)thisSize inSize: (CGSize) aSize;
+ (UIImage *) image: (UIImage *) image fitInSize: (CGSize) viewsize;

+ (UIImage*)blackWhite:(UIImage*)inImage;
+ (UIImage*)cartoon:(UIImage*)inImage;
+ (UIImage*)memory:(UIImage*)inImage;
+ (UIImage*)bopo:(UIImage*)inImage;
+ (UIImage*)scanLine:(UIImage*)inImage;

+ (UIImage *)rotateImage:(UIImage *)aImage;
+ (UIImage *)doImageBlacknWhite:(UIImage *)originalImage;

+ (UIImage *)imageWithContentsOfFileNamed:(NSString *)name;
+ (UIImage *)imageFromView:(UIView *)view;
+ (UIImage *)imageFromColor:(UIColor *)color;

+ (UIImage*)getSubImage:(UIImage *)image mCGSize:(CGSize)mCGSize centerBool:(BOOL)centerBool;

- (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

//居中裁剪某个比例的最大图片，可能是横向也可以是竖向与size匹配
- (UIImage *)imageCutForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

//居中裁剪某个比例的最大竖起方向图片
- (UIImage *)imageCutForVerticalSize:(UIImage *)sourceImage targetSize:(CGSize)size;

- (UIImage *)fixOrientation:(UIImage *)srcImg;

+ (UIImage *)posterizeImageWithCompression:(UIImage *)compressImage withSize:(CGSize)needSize  compressionQuality:(CGFloat)compressionQuality;

- (UIImage*)filteredImage:(NSString*)filterName;

//获取图片某点颜色
- (UIColor *)colorAtPixel:(CGPoint)point;

//颜色替换
- (UIImage*)imageToTransparent:(UIImage*)image;

//裁剪正方
+ (UIImage *)squareImageFromImage:(UIImage *)image
                     scaledToSize:(CGFloat)newSize ;

// 将UIView转成UIImage
+ (UIImage *)getImageFromView:(UIView *)theView ;

@end
