//
//  KXPhotoBrowerController.h
//  KXPhotoBrower
//
//  Created by mac on 2017/8/2.
//  Copyright © 2017年 kit. All rights reserved.
//

#import "BaseViewController.h"
@class KXAlbumModel;

@interface KXPhotoBrowerController : BaseViewController

@property (nonatomic, strong) NSMutableArray <KXAlbumModel *> *dataArray;
@property (nonatomic, assign) NSUInteger currentIndex;

@end
