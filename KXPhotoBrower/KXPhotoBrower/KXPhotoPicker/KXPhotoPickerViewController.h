//
//  KXPhotoPickerViewController.h
//  KXPhotoBrower
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 kit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KXPhotosHeader.h"


@class KXPhotoPickerViewController;
@protocol KXPhotoPickerViewController <NSObject>

@optional

/**
 取消代理，需要手动去dismiss控制器
 */
- (void)KXPhotoPickerViewControllerDidCancel:(KXPhotoPickerViewController *)imagePicker;


/**
 返回选中的图片，需要手动去dismiss控制器

 @param imageArray 解析出来的图片
 */
- (void)KXPhotoPickerViewController:(KXPhotoPickerViewController *)pickerViewController didSelectedImage:(NSArray<UIImage *> *)imageArray;

@end

@interface KXPhotoPickerViewController : UINavigationController


/**
 最大选择数
 仅在 KXPickerFilterTypePhotos 下生效
 */
@property (nonatomic, assign) NSUInteger pickerCount;

/**
 相册类型
 */
@property (nonatomic, assign) KXPickerFilterType filterType;

@property (nonatomic, weak) id <KXPhotoPickerViewController> photosDelegate;

@end
