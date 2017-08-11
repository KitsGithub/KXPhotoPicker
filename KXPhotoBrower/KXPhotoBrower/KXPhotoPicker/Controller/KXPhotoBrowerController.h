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

/**
 返回block
 */
@property (nonatomic, copy) ReturnBlock returnBlock;

//数据源
@property (nonatomic, strong) NSMutableArray <KXAlbumModel *> *dataArray;
//选中的图片
@property (nonatomic, strong) NSMutableArray<KXAlbumModel *> *selectedArray;

@property (nonatomic, assign) NSUInteger currentIndex;

@end
