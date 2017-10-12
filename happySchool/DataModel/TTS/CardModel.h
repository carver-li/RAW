//
//  CardModel.h
//  KCard
//
//  Created by 李伟光 on 2017/10/11.
//

#import "BaseDataModel.h"

@interface CardModel : BaseDataModel

@property (nonatomic,strong) NSString <Optional> *cardName;
@property (nonatomic,strong) NSString <Optional> *cardIcon;
@property (nonatomic,strong) NSString <Optional> *cardIntroduce;

@end
