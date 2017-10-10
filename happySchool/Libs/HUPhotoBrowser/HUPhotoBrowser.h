//
//  HUPhotoBrowser.h
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DismissBlock)(UIImage *image, NSInteger index);
typedef void(^RightActionBlock)(NSInteger index);

@interface HUPhotoBrowser : UIView

/*
 * @param imageView    点击的imageView
 * @param URLStrings   加载的网络图片的urlString
 * @param index        点击的图片在所有要展示图片中的位置
 */

+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings atIndex:(NSInteger)index;

/*
 * @param imageView    点击的imageView
 * @param withImages   加载的本地图片
 * @param index        点击的图片在所有要展示图片中的位置
 */

+ (instancetype)showFromImageView:(UIImageView *)imageView withImages:(NSArray *)images atIndex:(NSInteger)index;

+ (instancetype)showFromImageView:(UIImageView *)imageView withImages:(NSArray *)images atIndex:(NSInteger)index rightActionTitle:(NSString *)actionTitle action:(RightActionBlock)block;
+ (instancetype)showFromImageView:(UIImageView *)imageView withImages:(NSArray *)images placeholderImage:(UIImage *)image atIndex:(NSInteger)index rightActionTitle:(NSString *)actionTitle action:(RightActionBlock)block;

/*
 * @param imageView    点击的imageView
 * @param URLStrings   加载的网络图片的urlString
 * @param image        占位图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param dismiss      photoBrowser消失的回调
 */
+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings placeholderImage:(UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block;

+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings placeholderImage:(UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block rightActionTitle:(NSString *)actionTitle action:(RightActionBlock)block;

/*
 * @param imageView    点击的imageView
 * @param withImages   加载的本地图片
 * @param image        占位图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param dismiss      photoBrowser消失的回调
 */
+ (instancetype)showFromImageView:(UIImageView *)imageView withImages:(NSArray *)images placeholderImage:(UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic,assign) CGFloat adjustHeight;
@property (nonatomic,strong) NSString *backgroundImageName;;

- (void)reloadPhotoBrowser;

@end
