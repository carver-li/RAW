//
//  CardDetailViewController.h
//  KCard
//
//  Created by 李伟光 on 2017/10/12.
//

#import "IViewController.h"

typedef NS_OPTIONS(NSInteger, Status) {
    NotStart            = 0,
    Playing             = 2, //高异常分析需要的级别
    Paused              = 4,
};

@interface CardDetailViewController : IViewController

@property (nonatomic,strong) NSURL *pathUrl;

@property (nonatomic, assign) Status state;
@property (nonatomic, assign) BOOL hasError;
@property (nonatomic, assign) BOOL isCanceled;
@property (nonatomic, assign) BOOL isViewDidDisappear;

@end
