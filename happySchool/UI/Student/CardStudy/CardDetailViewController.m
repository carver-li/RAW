//
//  CardDetailViewController.m
//  KCard
//
//  Created by 李伟光 on 2017/10/12.
//

#import "CardDetailViewController.h"
#import "CardModel.h"
#import <AVFoundation/AVFoundation.h>
#import "iflyMSC/iflyMSC.h"
#import "TTSConfig.h"
#import "PcmPlayer.h"
#import "PopupView.h"
#import "AlertView.h"

@interface CardDetailViewController ()<IFlySpeechSynthesizerDelegate> {
    BOOL showImage;
    NSInteger currentIndex;
    CardModel *currentCard;
    
    NSString *chapterPath;
}

@property (weak, nonatomic) IBOutlet UIView *rootContainerView;

@property (strong, nonatomic) NSArray *cardList;

@property (strong, nonatomic) UIImageView *cardImageView;
@property (strong, nonatomic) UILabel *cardNamelabel;

//播放
@property (nonatomic, strong) IFlySpeechSynthesizer * iFlySpeechSynthesizer;
@property (nonatomic, strong) PcmPlayer *audioPlayer;

@property (nonatomic, strong) PopupView *popUpView;
@property (nonatomic, strong) AlertView *inidicateView;

@end

@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    currentIndex = 0;
    chapterPath = [_pathUrl path];
    [self setTitle:[chapterPath lastPathComponent]];
    
    [self initSynthesizer];
    [self loadData];
    [self loadCardView];
}

- (void)loadData {
    NSString *jsonPath = [chapterPath stringByAppendingPathComponent:@"ChapterData.json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    
    id JsonObject=[NSJSONSerialization JSONObjectWithData:jsonData
                                                  options:NSJSONReadingAllowFragments
                                                    error:nil];
    
    self.cardList = [CardModel arrayOfModelsFromDictionaries:JsonObject error:nil];
    currentCard = [self.cardList objectAtIndex:currentIndex];
}

- (void)loadCardView {
    for (UIView *subView in _rootContainerView.subviews) {
        [subView removeFromSuperview];
    }
    
    showImage = NO;
    UIImage *testImage = [UIImage imageWithContentsOfFile:[chapterPath stringByAppendingPathComponent:currentCard.cardIcon]];
    
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
    
    _cardNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView1.frame.size.width, containerView1.frame.size.height)];
    _cardNamelabel.textAlignment = NSTextAlignmentCenter;
    _cardNamelabel.adjustsFontSizeToFitWidth = YES;
    _cardNamelabel.backgroundColor = [UIColor whiteColor];
    _cardNamelabel.font = [UIFont boldSystemFontOfSize:containerView1.frame.size.height/2.0];
    _cardNamelabel.text = currentCard.cardName;
    [containerView1 addSubview:_cardNamelabel];
    
    _cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, containerView1.frame.size.width, containerView1.frame.size.height)];
    _cardImageView.backgroundColor = [UIColor clearColor];
    _cardImageView.image = testImage;
    [containerView2 addSubview:_cardImageView];
    
    [containerView1 addTapGestureRecognizerWithTarget:self action:@selector(onFlip)];
    
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onNext:)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [containerView1 addGestureRecognizer:leftGesture];
    
    UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onPrevious:)];
    rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [containerView1 addGestureRecognizer:rightGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - 事件

- (void)back:(id)sender {
    [_inidicateView hide];
    [_iFlySpeechSynthesizer stopSpeaking];
    
    [super back:sender];
}

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
    if (_audioPlayer != nil && _audioPlayer.isPlaying == YES) {
        [_audioPlayer stop];
    }
    
    self.hasError = NO;
    [NSThread sleepForTimeInterval:0.05];
    
    [_inidicateView setText: @"正在缓冲..."];
    [_inidicateView show];
    
    [_popUpView removeFromSuperview];
    self.isCanceled = NO;
    
    _iFlySpeechSynthesizer.delegate = self;
    
    [_iFlySpeechSynthesizer startSpeaking:currentCard.cardIntroduce];
    if (_iFlySpeechSynthesizer.isSpeaking) {
        _state = Playing;
    }
}

- (IBAction)onPrevious:(id)sender {
    if (currentIndex > 0) {
        currentIndex--;
        currentCard = [self.cardList objectAtIndex:currentIndex];
        
        [self loadCardView];
    }
    else {
        [self showTip:@"没有上一张了！"];
    }
}

- (IBAction)onNext:(id)sender {
    if (currentIndex < [self.cardList count]-1) {
        currentIndex++;
        currentCard = [self.cardList objectAtIndex:currentIndex];
        
        [self loadCardView];
    }
    else {
        [self showTip:@"没有下一张了！"];
    }
}

#pragma mark - 设置合成参数
- (void)initSynthesizer
{
    CGFloat posY = (KWindowHeightWithoutNavigationBar-100)/2.0;
    _popUpView = [[PopupView alloc] initWithFrame:CGRectMake(100, posY, 0, 0) withParentView:self.view];
    
    _inidicateView =  [[AlertView alloc]initWithFrame:CGRectMake(100, posY, 0, 0)];
    _inidicateView.ParentView = self.view;
    [self.view addSubview:_inidicateView];
    [_inidicateView hide];
    
    //pcm播放器初始化
    _audioPlayer = [[PcmPlayer alloc] init];
    
    TTSConfig *instance = [TTSConfig sharedInstance];
    if (instance == nil) {
        return;
    }
    
    //合成服务单例
    if (_iFlySpeechSynthesizer == nil) {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
    //设置语速1-100
    [_iFlySpeechSynthesizer setParameter:instance.speed forKey:[IFlySpeechConstant SPEED]];
    
    //设置音量1-100
    [_iFlySpeechSynthesizer setParameter:instance.volume forKey:[IFlySpeechConstant VOLUME]];
    
    //设置音调1-100
    [_iFlySpeechSynthesizer setParameter:instance.pitch forKey:[IFlySpeechConstant PITCH]];
    
    //设置采样率
    [_iFlySpeechSynthesizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //设置发音人
    [_iFlySpeechSynthesizer setParameter:instance.vcnName forKey:[IFlySpeechConstant VOICE_NAME]];
    
    //设置文本编码格式
    [_iFlySpeechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
}

#pragma mark - 合成回调 IFlySpeechSynthesizerDelegate

/**
 开始播放回调
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onSpeakBegin
{
    [_inidicateView hide];
    self.isCanceled = NO;
    if (_state  != Playing) {
        [_popUpView showText:@"开始播放"];
    }
    _state = Playing;
}



/**
 缓冲进度回调
 
 progress 缓冲进度
 msg 附加信息
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onBufferProgress:(int) progress message:(NSString *)msg
{
    NSLog(@"buffer progress %2d%%. msg: %@.", progress, msg);
}




/**
 播放进度回调
 
 progress 缓冲进度
 
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos
{
    NSLog(@"speak progress %2d%%.", progress);
}


/**
 合成暂停回调
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onSpeakPaused
{
    [_inidicateView hide];
    [_popUpView showText:@"播放暂停"];
    
    _state = Paused;
}


/**
 合成结束（完成）回调
 
 对uri合成添加播放的功能
 ****/
- (void)onCompleted:(IFlySpeechError *) error
{
    NSLog(@"%s,error=%d",__func__,error.errorCode);
    
    if (error.errorCode != 0) {
        [_inidicateView hide];
        [_popUpView showText:[NSString stringWithFormat:@"错误码:%d",error.errorCode]];
        return;
    }
    NSString *text ;
    if (self.isCanceled) {
        text = @"播放已取消";
    }
    else if (error.errorCode == 0) {
        text = @"播放结束";
    }
    else {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
        self.hasError = YES;
        NSLog(@"%@",text);
    }
    
    [_inidicateView hide];
    [_popUpView showText:text];
    
    _state = NotStart;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
