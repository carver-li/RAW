//
//  HUPhotoBrowserCell.m
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 jinhuadiqigan. All rights reserved.
//

#import "HUPhotoBrowserCell.h"
#import "hu_const.h"
#import "UIImageView+HUWebImage.h"

@interface HUPhotoBrowserCell () <UIScrollViewDelegate> {
    UIImageView *bgImageView;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;

@end

@implementation HUPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self setupView];
        [self addGestureRecognizer:self.singleTap];
        [self addGestureRecognizer:self.doubleTap];
    }
    return self;
}

- (void)setupView {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.maximumZoomScale = 2;
    _scrollView.minimumZoomScale = 0.5;
    _scrollView.delegate = self;

    [self addSubview:_scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:imageView];
    _imageView = imageView;
}

- (void)resetZoomingScale {
    
    if (self.scrollView.zoomScale !=1) {
         self.scrollView.zoomScale = 1;
    }
   
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    
    if (self.backgroundImageName) {
        [_imageView removeFromSuperview];
        
        if (bgImageView == nil) {
            bgImageView = [[UIImageView alloc] init];
            [bgImageView setContentMode:UIViewContentModeScaleAspectFit];
            
            if (self.backgroundImageName.length > 0) {
                bgImageView.image = [UIImage imageNamed:self.backgroundImageName];
            }
            else {
                bgImageView.backgroundColor = self.backgroundColor;
            }
            
            [_scrollView insertSubview:bgImageView atIndex:0];
        }
        
        bgImageView.frame = _scrollView.bounds;
        
        CGFloat marginX = 20.0;
        CGFloat marginY = marginX*_imageView.image.size.height/_imageView.image.size.width;
        
        _imageView.frame = CGRectMake(marginX, marginY, CGRectGetWidth(bgImageView.bounds)-2.0*marginX, CGRectGetHeight(bgImageView.bounds)-marginY*2.0-self.adjustHeight);
        [bgImageView addSubview:_imageView];
    }
    else {
        _imageView.frame = _scrollView.bounds;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (self.backgroundImageName) {
        return bgImageView;
    }
    else {
        return self.imageView;
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    if (self.backgroundImageName) {
        bgImageView.center = [self centerOfScrollViewContent:scrollView];
    }
    else {
        self.imageView.center = [self centerOfScrollViewContent:scrollView];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoCellDidZommingNotification object:_indexPath];
}

#pragma mark - gesture handler

- (void)doubleTapGestrueHandle:(UITapGestureRecognizer *)sender {
    CGPoint p = [sender locationInView:self];
    if (self.scrollView.zoomScale <=1.0) {
        CGFloat scaleX = p.x + self.scrollView.contentOffset.x;
        CGFloat scaley = p.y + self.scrollView.contentOffset.y;
        [self.scrollView zoomToRect:CGRectMake(scaleX, scaley, 10, 10) animated:YES];
    }
    else {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}

- (void)singleTapGestrueHandle:(UITapGestureRecognizer *)sender {
    if (self.tapActionBlock) {
        self.tapActionBlock(sender);
    }
    
}

#pragma mark - private

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

#pragma mark - getter

- (UITapGestureRecognizer *)doubleTap {
    if (!_doubleTap) {
        _doubleTap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestrueHandle:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired = 1;
    }
    return _doubleTap;
}

- (UITapGestureRecognizer *)singleTap {
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestrueHandle:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
    }
    return _singleTap;
}

@end
