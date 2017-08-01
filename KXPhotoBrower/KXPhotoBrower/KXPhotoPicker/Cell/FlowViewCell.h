//
//  FlowViewCell.h
//  KXPhotoBrower
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 kit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+My.h"
#import "KXAlbumModel.h"

@interface FlowViewCell : UICollectionViewCell

@property (nonatomic, weak) KXAlbumModel *model;

@end
