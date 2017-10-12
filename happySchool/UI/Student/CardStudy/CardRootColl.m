//
//  CardRootColl.m
//  KCard
//
//  Created by 李伟光 on 2017/10/12.
//

#import "CardRootColl.h"

@interface CardRootColl() {
    
}

@property (weak, nonatomic) IBOutlet UILabel *chapterLabel;

@end

@implementation CardRootColl

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadData:(NSString *)chapter {
    _chapterLabel.text = chapter;
}

@end
