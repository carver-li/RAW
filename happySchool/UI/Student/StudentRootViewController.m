//
//  StudentRootViewController.m
//  happySchool
//
//  Created by 李伟光 on 2017/9/30.
//

#import "StudentRootViewController.h"
#import "StudentRootCell.h"
#import "TTSUIController.h"
#import "CardRootCollectionViewController.h"

@interface StudentRootViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *rootCollectionView;

@property (strong, nonatomic) NSArray *functionList;

@end

@implementation StudentRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"学生天地"];
    
    self.functionList = @[@[@"语音合成",@"function_address_book"],@[@"卡片识字",@"function_address_book"]];
    
    _rootCollectionView.dataSource = self;
    _rootCollectionView.delegate = self;
    [_rootCollectionView registerNib:[UINib nibWithNibName:@"StudentRootCell" bundle:nil] forCellWithReuseIdentifier:@"StudentRootCell"];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.functionList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = kWindowWidth/4.0;
    return CGSizeMake(width,width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StudentRootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StudentRootCell" forIndexPath:indexPath];
    NSArray *funtion = [self.functionList objectAtIndex:indexPath.row];
    [cell fillData:[funtion objectAtIndex:0] withIcon:[funtion objectAtIndex:1]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            TTSUIController *ttsController = [[TTSUIController alloc] initWithNibName:@"TTSUIController" bundle:nil];
            NSArray *funtion = [self.functionList objectAtIndex:indexPath.row];
            [ttsController setTitle:[funtion objectAtIndex:0]];
            ttsController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ttsController animated:YES];
            break;
        }
        case 1:
        {
            CardRootCollectionViewController *cardVC = [[CardRootCollectionViewController alloc] initWithNibName:@"CardRootCollectionViewController" bundle:nil];
            NSArray *funtion = [self.functionList objectAtIndex:indexPath.row];
            [cardVC setTitle:[funtion objectAtIndex:0]];
            cardVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cardVC animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
