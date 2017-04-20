//
//  KXBrowserCell.h
//  KXPhotoBrower
//
//  Created by mac on 17/4/20.
//  Copyright © 2017年 kit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class KXPhotoBrowserController;
@interface KXBrowserCell : UICollectionViewCell

@property (nonatomic, weak) KXPhotoBrowserController *photoBrowser;

@property (nonatomic, strong) PHAsset *asset;

@end
