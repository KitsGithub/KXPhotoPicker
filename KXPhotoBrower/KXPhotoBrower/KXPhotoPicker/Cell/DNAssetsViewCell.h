//
//  DNAssetsViewCell.h
//  ImagePicker
//
//  Created by DingXiao on 15/2/11.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class DNAssetsViewCell;

@protocol DNAssetsViewCellDelegate <NSObject>

@optional
- (void)didSelectItemAssetsViewCell:(DNAssetsViewCell *)assetsCell;
- (void)didDeselectItemAssetsViewCell:(DNAssetsViewCell *)assetsCell;
@end

@interface DNAssetsViewCell : UICollectionViewCell

@property (nonatomic, weak) PHAsset *phAsset;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, weak) id<DNAssetsViewCellDelegate> delegate;

- (void)fillWithImage:(PHAsset *)asset isSelected:(BOOL)seleted;
@end
