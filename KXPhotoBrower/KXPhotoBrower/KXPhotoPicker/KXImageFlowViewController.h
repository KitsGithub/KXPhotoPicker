//
//  KXImageFlowViewController.h
//  KXPhotoBrower
//
//  Created by mac on 17/4/20.
//  Copyright © 2017年 kit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KXAlbumModel.h"

@interface KXImageFlowViewController : UIViewController

@property (nonatomic, assign) int kDNImageFlowMaxSeletedNumber;
//相册信息
@property (nonatomic, weak) KXAlbumModel *albumModel;

@end
