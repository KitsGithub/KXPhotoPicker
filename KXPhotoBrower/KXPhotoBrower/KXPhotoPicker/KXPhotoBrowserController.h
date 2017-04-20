//
//  KXPhotoBrowserController.h
//  KXPhotoBrower
//
//  Created by mac on 17/4/20.
//  Copyright © 2017年 kit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;
@interface KXPhotoBrowserController : UIViewController

- (instancetype)initWithPHPhotosArray:(NSMutableArray<PHAsset *> *)photosArray
                         currentIndex:(NSInteger)index;


- (void)hideControls;
- (void)toggleControls;
@end
