//
//  CardDetailViewController.m
//  KCard
//
//  Created by 李伟光 on 2017/10/12.
//

#import "CardDetailViewController.h"

@interface CardDetailViewController () {
    BOOL showImage;
}

@property (weak, nonatomic) IBOutlet UIView *rootContainerView;

@property (strong, nonatomic) UIImageView *cardImageView;
@property (strong, nonatomic) UILabel *cardNamelabel;

@end

@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    showImage = YES;
    UIImage *testImage = [UIImage imageNamed:@"1"];
    
    CGFloat width = kWindowWidth-20.0;
    CGFloat height = width*testImage.size.height/testImage.size.width;
    
    CGFloat marginX = 10.0;
    CGFloat marginY = (KWindowHeightWithoutNavigationBar-60.0-height)/2.0;
    
    if (marginY < 0) {
        height = KWindowHeightWithoutNavigationBar-60.0 - 20.0;
        width = height*testImage.size.width/testImage.size.height;
        
        marginX = (kWindowWidth-width)/2.0;
        marginY = 10.0;
    }
    
    UIView *containerView1 = [[UIView alloc] initWithFrame:CGRectMake(marginX, marginY, width, height)];
    UIView *containerView2 = [[UIView alloc] initWithFrame:containerView1.bounds];
    
    [_rootContainerView addSubview:containerView1];
    [containerView1 addSubview:containerView2];
    
    _cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, containerView1.frame.size.width, containerView1.frame.size.height)];
    _cardImageView.backgroundColor = [UIColor clearColor];
    _cardImageView.image = testImage;
    [containerView1 addSubview:_cardImageView];
    
    _cardNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView1.frame.size.width, containerView1.frame.size.height)];
    _cardNamelabel.textAlignment = NSTextAlignmentCenter;
    _cardNamelabel.adjustsFontSizeToFitWidth = YES;
    _cardNamelabel.backgroundColor = [UIColor whiteColor];
    _cardNamelabel.font = [UIFont boldSystemFontOfSize:containerView1.frame.size.height/2.0];
    _cardNamelabel.text = @"米";
    [containerView2 addSubview:_cardNamelabel];
    
    [containerView1 addTapGestureRecognizerWithTarget:self action:@selector(onFlip)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - 事件

- (void)onFlip {
    [CATransaction flush];
    
    if (showImage) {
        [UIView transitionFromView:_cardImageView toView:_cardNamelabel duration:1.0f options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
    }
    else {
        [UIView transitionFromView:_cardNamelabel toView:_cardImageView duration:1.0f options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
    }
    
    showImage = !showImage;
}

- (IBAction)onStudy:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
