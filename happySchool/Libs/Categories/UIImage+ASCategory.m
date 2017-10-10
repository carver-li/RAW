//
//  UIImage+ASCategory.m
//  FollowMe
//
//  Created by Kowloon on 12-7-13.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import "UIImage+ASCategory.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
    ImageFileFormatPNG,
    ImageFileFormatJPEG
} ImageFileFormat;

// Return a bitmap context using alpha/red/green/blue byte values
CGContextRef CreateRGBABitmapContext (CGImageRef inImage)
{
	CGContextRef context = NULL;
	CGColorSpaceRef colorSpace;
	void *bitmapData;
	size_t bitmapByteCount;
	size_t bitmapBytesPerRow;
	size_t pixelsWide = CGImageGetWidth(inImage);
	size_t pixelsHigh = CGImageGetHeight(inImage);
	bitmapBytesPerRow	= (pixelsWide * 4);
	bitmapByteCount	= (bitmapBytesPerRow * pixelsHigh);
	colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL)
	{
		fprintf(stderr, "Error allocating color space\n"); return NULL;
	}
	// allocate the bitmap & create context
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL)
	{
		fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
	context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
	if (context == NULL)
	{
		free (bitmapData);
		fprintf (stderr, "Context not created!");
	}
	
    //	free (bitmapData);
	CGColorSpaceRelease( colorSpace );
	return context;
}

// Return Image Pixel data as an RGBA bitmap
unsigned char *RequestImagePixelData(UIImage *inImage)
{
	CGImageRef img = [inImage CGImage];
	CGSize size = [inImage size];
	CGContextRef cgctx = CreateRGBABitmapContext(img);
	
	if (cgctx == NULL)
		return NULL;
	
	CGRect rect = {{0,0},{size.width, size.height}};
	CGContextDrawImage(cgctx, rect, img);
	unsigned char *data = CGBitmapContextGetData (cgctx); 
	CGContextRelease(cgctx);
	return data;
}

@implementation UIImage (ASCategory)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color withSize:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size {
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)doImageBlacknWhite:(UIImage *)originalImage
{
    
    CGColorSpaceRef colorSapce = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate(nil, originalImage.size.width, originalImage.size.height, 8, originalImage.size.width, colorSapce, (CGBitmapInfo)kCGImageAlphaNone);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    
    CGContextDrawImage(context, CGRectMake(0, 0, originalImage.size.width, originalImage.size.height), [originalImage CGImage]);
    
    CGImageRef bwImage = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSapce);
    
    
    UIImage *resultImage = [UIImage imageWithCGImage:bwImage]; // This is result B/W image.
    //imgtempFrame.image=resultImage;
    
    CGImageRelease(bwImage);
    
    return resultImage;
}

+(UIImage *)rotateImage:(UIImage *)aImage{
    
    CGImageRef imgRef = aImage.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat scaleRatio = 1;
    
    CGFloat boundHeight;
    
    UIImageOrientation orient = aImage.imageOrientation;
    
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
    
}

+ (CGSize) fitSize: (CGSize)thisSize inSize: (CGSize) aSize
{
	CGFloat scale;
	CGSize newsize;
	
	if(thisSize.width<aSize.width && thisSize.height < aSize.height)
	{
		newsize = thisSize;
	}
	else
	{
		if(thisSize.width >= thisSize.height)
		{
			scale = aSize.width/thisSize.width;
			newsize.width = aSize.width;
			newsize.height = thisSize.height*scale;
		}
		else
		{
			scale = aSize.height/thisSize.height;
			newsize.height = aSize.height;
			newsize.width = thisSize.width*scale;
		}
	}
	return newsize;
}

// Proportionately resize, completely fit in view, no cropping
+ (UIImage *) image: (UIImage *) image fitInSize: (CGSize) viewsize
{
	// calculate the fitted size
	CGSize size = [UIImage fitSize:image.size inSize:viewsize];
	
	UIGraphicsBeginImageContext(size);
    
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	[image drawInRect:rect];
	
	UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newimg;
}

#pragma mark -

+ (UIImage*)blackWhite:(UIImage*)inImage
{
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	size_t w = CGImageGetWidth(inImageRef);
	size_t h = CGImageGetHeight(inImageRef);
    
	int wOff = 0;
	int pixOff = 0;
	
	for(GLuint y = 0;y< h;y++)
	{
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++)
		{
			//int alpha = (unsigned char)imgPixel[pixOff];
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			int bw = (int)((red+green+blue)/3.0);
			
			imgPixel[pixOff] = bw;
			imgPixel[pixOff+1] = bw;
			imgPixel[pixOff+2] = bw;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	
	NSInteger dataLength = w*h* 4;
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
	// prep the ingredients
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	size_t bytesPerRow = 4 * w;
    
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	// make the cgimage
	CGImageRef imageRef = CGImageCreate(w, h,
                                        bitsPerComponent,
                                        bitsPerPixel,
                                        bytesPerRow,
                                        colorSpaceRef,
                                        bitmapInfo,
                                        provider,
                                        NULL, NO, renderingIntent);
	
	UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
	
	CFRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	return my_Image;
}

+ (UIImage*)cartoon:(UIImage*)inImage
{
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	size_t w = CGImageGetWidth(inImageRef);
	size_t h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
	for(GLuint y = 0;y< h;y++)
	{
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++)
		{
			//int alpha = (unsigned char)imgPixel[pixOff];
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			int ava = (int)((red+green+blue)/3.0);
			
			int newAva = ava>128 ? 255 : 0;
			
			imgPixel[pixOff] = newAva;
			imgPixel[pixOff+1] = newAva;
			imgPixel[pixOff+2] = newAva;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	
	NSInteger dataLength = w*h* 4;
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
	// prep the ingredients
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	size_t bytesPerRow = 4 * w;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	// make the cgimage
	CGImageRef imageRef = CGImageCreate(w, h,
                                        bitsPerComponent,
                                        bitsPerPixel,
                                        bytesPerRow,
                                        colorSpaceRef,
                                        bitmapInfo,
                                        provider, NULL, NO, renderingIntent);
	
	UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
	
	CFRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	return my_Image;
}

+ (UIImage*)memory:(UIImage*)inImage
{
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	size_t w = CGImageGetWidth(inImageRef);
	size_t h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
	for(GLuint y = 0;y< h;y++)
	{
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++)
		{
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			red = green = blue = ( red + green + blue ) /3;
			
			red += red*2;
			green = green*2;
			
			if(red > 255)
				red = 255;
			if(green > 255)
				green = 255;
			
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	
	NSInteger dataLength = w*h* 4;
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
	// prep the ingredients
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	size_t bytesPerRow = 4 * w;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	// make the cgimage
	CGImageRef imageRef = CGImageCreate(w, h,
                                        bitsPerComponent,
                                        bitsPerPixel,
                                        bytesPerRow,
                                        colorSpaceRef,
                                        bitmapInfo,
                                        provider, NULL, NO, renderingIntent);
	
	UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
	
	CFRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	return my_Image;
}

+ (UIImage*)bopo:(UIImage*)inImage
{
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	size_t w = CGImageGetWidth(inImageRef);
	size_t h = CGImageGetHeight(inImageRef);
	
	//printf("w:%d,h:%d",w,h);
	
	int i, j, m, n;
	int bRowOff;
	int width = 8;
	int height = 8;
	int centerW = width /2;
	int centerH = height /2;
	
	//fix the image to right size
	int modw = w%width;
	int modh = h%height;
	if(modw)	w = w - modw;
	if(modh)	h = h - modh;
	
	int br, bg, bb;
	int tr, tg, tb;
	
	double offset;
	//double **weight= malloc(height*width*sizeof(double));
	NSMutableArray *wei = [[NSMutableArray alloc] init];
	for(m = 0; m < height; m++)
	{
		NSMutableArray *t1 = [[NSMutableArray alloc] init];
		for(n = 0; n < width; n++)
		{
			[t1 addObject:[NSNull null]];
		}
		[wei	addObject:t1];
	}
	
	int total = 0;
	int max = (int)(pow(centerH, 2) + pow(centerW, 2));
	
	for(m = 0; m < height; m++)
	{
		for(n = 0; n < width; n++)
		{
			offset = max - (int)(pow((m - centerH), 2) + pow((n - centerW), 2));
			total += offset;
			//weight[m][n] = offset;
			[[wei objectAtIndex:m] insertObject:[NSNumber numberWithDouble:offset] atIndex:n];
		}
	}
	for(m = 0; m < height; m++)
	{
		for(n = 0; n < width; n++)
		{
			//weight[m][n] = weight[m][n] / total;
			double newVal = [[[wei objectAtIndex:m] objectAtIndex:n] doubleValue]/total;
			[[wei objectAtIndex:m] replaceObjectAtIndex:n
                                             withObject:[NSNumber numberWithDouble:newVal]];
		}
	}
	bRowOff = 0;
	for(j = 0; j < h; j+=height)
	{
		int bPixOff = bRowOff;
		
		for(i = 0; i < w; i+=width)
		{
			int bRowOff2 = bPixOff;
			
			tr = tg = tb = 0;
			
			for(m = 0; m < height; m++)
			{
				int bPixOff2 = bRowOff2;
				
				for(n = 0; n < width; n++)
				{
					tr += 255 - imgPixel[bPixOff2];
					tg += 255 - imgPixel[bPixOff2+1];
					tb += 255 - imgPixel[bPixOff2+2];
					
					bPixOff2 += 4;
				}
				
				bRowOff2 += w*4;
			}
			bRowOff2 = bPixOff;
			
			for(m = 0; m < height; m++)
			{
				int bPixOff2 = bRowOff2;
				for(n = 0; n < width; n++)
				{
					
					//offset = weight[m][n];
					offset =  [[[wei objectAtIndex:m] objectAtIndex:n] doubleValue];
					br = 255 - (int)(tr * offset);
					bg = 255 - (int)(tg * offset);
					bb = 255 - (int)(tb * offset);
					
					if(br < 0)
						br = 0;
					if(bg < 0)
						bg = 0;
					if(bb < 0)
						bb = 0;
					imgPixel[bPixOff2] = br;
					imgPixel[bPixOff2 +1] = bg;
					imgPixel[bPixOff2 +2] = bb;
					
					bPixOff2 += 4; // advance background to next pixel
				}
				bRowOff2 += w*4;
			}
			bPixOff += width*4; // advance background to next pixel
		}
		bRowOff += w * height*4;
	}
	
	NSInteger dataLength = w*h* 4;
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
	// prep the ingredients
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	size_t bytesPerRow = 4 * w;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	// make the cgimage
	CGImageRef imageRef = CGImageCreate(w, h,
                                        bitsPerComponent,
                                        bitsPerPixel,
                                        bytesPerRow,
                                        colorSpaceRef,
                                        bitmapInfo,
                                        provider, NULL, NO, renderingIntent);
	
	UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
	
	CFRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	return my_Image;
}

+(UIImage*)scanLine:(UIImage*)inImage
{
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	size_t w = CGImageGetWidth(inImageRef);
	size_t h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
	for(GLuint y = 0;y< h;y+=2)
	{
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++)
		{
			//int alpha = (unsigned char)imgPixel[pixOff];
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			int newR,newG,newB;
			int rr = red *2;
			newR = rr > 255 ? 255 : rr;
			int gg = green *2;
			newG = gg > 255 ? 255 : gg;
			int bb = blue *2;
			newB = bb > 255 ? 255 : bb;
			
			imgPixel[pixOff] = newR;
			imgPixel[pixOff+1] = newG;
			imgPixel[pixOff+2] = newB;
			
			pixOff += 4;
		}
		wOff += w * 4 *2;
	}
	
	NSInteger dataLength = w*h* 4;
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
	// prep the ingredients
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	size_t bytesPerRow = 4 * w;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	// make the cgimage
	CGImageRef imageRef = CGImageCreate(w, h, 
                                        bitsPerComponent, 
                                        bitsPerPixel, 
                                        bytesPerRow, 
                                        colorSpaceRef, 
                                        bitmapInfo, 
                                        provider, NULL, NO, renderingIntent);
	
	UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
	
	CFRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	return my_Image;
}

+ (UIImage *)imageWithContentsOfFileNamed:(NSString *)name
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    if (filePath) {
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        return image;
    } else {
        return nil;
    }
}

+ (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.frame.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[view.layer renderInContext:context];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 * 截取部分图像
 *
 **/
+ (UIImage*)getSubImage:(UIImage *)image mCGSize:(CGSize)mCGSize centerBool:(BOOL)centerBool
{
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    float imgwidth = image.size.width;
    float imgheight = image.size.height;
    float viewwidth = mCGSize.width;
    float viewheight = mCGSize.height;
    CGRect rect;
    if(centerBool)
        rect = CGRectMake((imgwidth-viewwidth)/2, (imgheight-viewheight)/2, viewwidth, viewheight);
    else{
        if (viewheight < viewwidth) {
            if (imgwidth <= imgheight) {
                rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
            }else {
                float width = viewwidth*imgheight/viewheight;
                float x = (imgwidth - width)/2 ;
                if (x > 0) {
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
                }
            }
        }else {
            if (imgwidth <= imgheight) {
                float height = viewheight*imgwidth/viewwidth;
                if (height < imgheight) {
                    rect = CGRectMake(0, 0, imgwidth, height);
                }else {
                    rect = CGRectMake(0, 0, viewwidth*imgheight/viewheight, imgheight);
                }
            }else {
                float width = viewwidth*imgheight/viewheight;
                if (width < imgwidth) {
                    float x = (imgwidth - width)/2 ;
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgheight);
                }
            }
        }
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

//等比例压缩
- (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    if (defineWidth >= sourceImage.size.width) {
        return sourceImage;
    }
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageCutForSize:(UIImage *)sourceImage targetSize:(CGSize)size {
    CGFloat imageWidth = sourceImage.size.width;
    CGFloat imageHeight = sourceImage.size.height;
    
    CGFloat cutWidth = size.width;
    CGFloat cutHeight = size.height;
    CGFloat imageRatio = imageWidth/imageHeight;
    CGFloat cutRatio;
    CGSize cutSize;
    
    if (imageHeight >= imageWidth) {
        cutRatio = cutWidth/cutHeight;
    }
    else {
        cutRatio = cutHeight/cutWidth;
    }
    
    if (imageRatio > cutRatio) {
        cutSize = CGSizeMake(imageHeight*cutRatio, imageHeight);
    }
    else {
        cutSize = CGSizeMake(imageWidth, imageWidth/cutRatio);
    }
    
    UIImage *cutImage = [sourceImage imageCompressForSize:sourceImage targetSize:cutSize];
    return cutImage;
}

//居中裁剪某个比例的最大竖起方向图片
- (UIImage *)imageCutForVerticalSize:(UIImage *)sourceImage targetSize:(CGSize)size {
    CGFloat imageWidth = sourceImage.size.width;
    CGFloat imageHeight = sourceImage.size.height;
    
    CGFloat cutWidth = size.width;
    CGFloat cutHeight = size.height;
    CGFloat imageRatio = imageWidth/imageHeight;
    CGFloat cutRatio;
    CGSize cutSize;
    
    cutRatio = cutWidth/cutHeight;
    
    if (imageRatio >= cutRatio) {
        imageHeight = imageWidth/cutRatio;
    }
    else {
        imageWidth = imageHeight*cutRatio;
    }
    
    cutSize = CGSizeMake(imageWidth, imageHeight);
    
    UIImage *cutImage = [sourceImage imageCompressForSize:sourceImage targetSize:cutSize];
    return cutImage;
}

- (UIImage *)fixOrientation:(UIImage *)srcImg {
    if (srcImg.imageOrientation == UIImageOrientationUp)
        return srcImg;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)posterizeImageWithCompression:(UIImage *)compressImage withSize:(CGSize)needSize compressionQuality:(CGFloat)compressionQuality {
    
    if (MIN(compressImage.size.width, compressImage.size.height) < needSize.width
        || MAX(compressImage.size.width, compressImage.size.height) <= needSize.height) {
        return compressImage;
    }
    
    CGFloat newWidth = 0.0;
    
    if (compressImage.size.width > compressImage.size.height) {//横拍相片
        
        newWidth = needSize.height;
        
        CGFloat newHeight = compressImage.size.height*newWidth/compressImage.size.width;
        
        //若计算出的高度小于需求的尺寸，根据最小需求高度重新计算宽度
        if (newHeight < needSize.width) {
            newHeight = needSize.width;
            newWidth = compressImage.size.width*newHeight/compressImage.size.height;
        }
        
        if (newWidth < needSize.height) {
            newWidth = needSize.height;
        }
    }
    else {  //竖拍相片
        newWidth = compressImage.size.width*needSize.height/compressImage.size.height;
        
        //若计算出的宽度小于需求的尺寸，设置为最小需求宽度
        if (newWidth < needSize.width) {
            newWidth = needSize.width;
        }
    }
    
    UIImage *newSizeImage = [compressImage imageCompressForWidth:compressImage targetWidth:newWidth];
    
    NSData *newSizeImageData = UIImageJPEGRepresentation(newSizeImage, compressionQuality);
    UIImage *resultImage = [[UIImage alloc] initWithData:newSizeImageData];
    
    return resultImage;
}

- (UIImage*)filteredImage:(NSString*)filterName
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:self];
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    
    if([filterName isEqualToString:@"CIVignetteEffect"]){
        // parameters for CIVignetteEffect
        CGFloat R = MIN(self.size.width, self.size.height)/2;
        CIVector *vct = [[CIVector alloc] initWithX:self.size.width/2 Y:self.size.height/2];
        [filter setValue:vct forKey:@"inputCenter"];
        [filter setValue:[NSNumber numberWithFloat:0.9] forKey:@"inputIntensity"];
        [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    }
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

//获取图片某点颜色
- (UIColor *)colorAtPixel:(CGPoint)point {
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIImage*) imageToTransparent:(UIImage*) image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        //把绿色变成黑色，把背景色变成透明
//        if ((*pCurPtr & 0x65815A00) == 0x65815a00)    // 将背景变成透明
//        {
//            uint8_t* ptr = (uint8_t*)pCurPtr;
//            ptr[0] = 0;
//        }
//        else
//            if ((*pCurPtr & 0x00FF0000) == 0x00ff0000)    // 将绿色变成黑色
//        {
//            uint8_t* ptr = (uint8_t*)pCurPtr;
//            ptr[3] = 0; //0~255
//            ptr[2] = 0;
//            ptr[1] = 0;
//        }
//        else
            if ((*pCurPtr & 0xFFFFFF00) == 0xFFFFFF00)    // 将白色变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
//            ptr[0] = 0;
            ptr[3] = 255; //0~255
            ptr[2] = 22;
            ptr[1] = 0;
        }
//        else
//        {
//            // 改成下面的代码，会将图片转成想要的颜色
//            uint8_t* ptr = (uint8_t*)pCurPtr;
//            ptr[3] = 0; //0~255
//            ptr[2] = 0;
//            ptr[1] = 0;
//        }
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider =CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight,8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast |kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true,kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    
    return resultUIImage;
}

/** 颜色变化 */
void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

//裁剪正方
/**
 *  剪切图片为正方形
 *
 *  @param image   原始图片比如size大小为(400x200)pixels
 *  @param newSize 正方形的size比如400pixels
 *
 *  @return 返回正方形图片(400x400)pixels
 */
+ (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize
{
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height)
    {
        //image原始高度为200，缩放image的高度为400pixels，所以缩放比率为2
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        //设置绘制原始图片的画笔坐标为CGPoint(-100, 0)pixels
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    }
    else
    {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    //创建画板为(400x400)pixels
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    }
    else
    {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将image原始图片(400x200)pixels缩放为(800x400)pixels
    CGContextConcatCTM(context, scaleTransform);
    //origin也会从原始(-100, 0)缩放到(-200, 0)
    [image drawAtPoint:origin];
    
    //获取缩放后剪切的image图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

// 将UIView转成UIImage
+ (UIImage *)getImageFromView:(UIView *)theView
{
    CGSize orgSize = theView.bounds.size ;
    UIGraphicsBeginImageContextWithOptions(orgSize, YES, theView.layer.contentsScale * 2);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext() ;
    
    return image ;
}

@end
