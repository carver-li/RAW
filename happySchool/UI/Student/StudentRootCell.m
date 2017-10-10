//
//  StudentRootCell.m
//  happySchool
//
//  Created by 李伟光 on 2017/9/30.
//

#import "StudentRootCell.h"

@interface StudentRootCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation StudentRootCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[MainBlueColor colorWithAlphaComponent:0.4] CGColor];
}

- (void)fillData:(NSString *)name withIcon:(NSString *)iconName {
    _imageView.image = [UIImage imageNamed:iconName];
    _nameLabel.text = name;
}

@end
