//
//  KXPhotoBrowerController.h
//  KXPhotoBrower
//
//  Created by mac on 2017/8/2.
//  Copyright © 2017年 kit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnBlock)();

@class KXAlbumModel;

@interface KXPhotoBrowerController : UIViewController

@property (nonatomic, copy) ReturnBlock returnBlock;

@property (nonatomic, strong) NSMutableArray <KXAlbumModel *> *dataArray;
@property (nonatomic, assign) NSUInteger currentIndex;

@end
