//
//  StudentRootViewController.m
//  happySchool
//
//  Created by 李伟光 on 2017/9/30.
//

#import "StudentRootViewController.h"
#import "StudentRootCell.h"

@interface StudentRootViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *rootCollectionView;

@property (strong, nonatomic) NSArray *functionList;

@end

@implementation StudentRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"学生天地"];
    
    self.functionList = @[@[@"课程表",@"function_address_book"],@[@"通讯录",@"function_address_book"]];
    
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
