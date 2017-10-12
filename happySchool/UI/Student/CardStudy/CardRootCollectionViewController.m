//
//  CardRootCollectionViewController.m
//  KCard
//
//  Created by 李伟光 on 2017/10/11.
//

#import "CardRootCollectionViewController.h"
#import "CardDetailViewController.h"
#import "CardRootColl.h"

@interface CardRootCollectionViewController ()

@property (nonatomic,strong) NSMutableArray *cardChapterList;

@end

@implementation CardRootCollectionViewController

static NSString * const reuseIdentifier = @"CardRootColl";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    // Uncomment the following line to preserve selection between presentations
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"CardRootColl" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)initData {
    self.cardChapterList = [NSMutableArray arrayWithCapacity:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    
    NSString *documentDir = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"/CardStudy"];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    //contentsOfDirectoryAtURL的第一个参数是NSURL，我不知道怎么处理
    fileList = [fileManager contentsOfDirectoryAtURL:[NSURL URLWithString:documentDir] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:&error];
    
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSURL *file in fileList) {
        [_cardChapterList addObject:file];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_cardChapterList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (kWindowWidth-50)/4.0;
    return CGSizeMake(width,width+20.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardRootColl *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSURL *url = [self.cardChapterList objectAtIndex:indexPath.row];
    NSString *name = [[url path] lastPathComponent];
    [cell loadData:name];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CardDetailViewController *cardDetailVC = [[CardDetailViewController alloc] initWithNibName:@"CardDetailViewController" bundle:nil];
    cardDetailVC.pathUrl = [self.cardChapterList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:cardDetailVC animated:YES];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
