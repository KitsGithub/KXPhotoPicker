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

- (void)KXPhotoPickerViewControllerDidCancel:(KXPhotoPickerViewController *)imagePicker;

- (void)KXPhotoPickerViewController:(KXPhotoPickerViewController *)pickerViewController didSelectedImage:(NSArray<UIImage *> *)imageArray;

@end

@interface KXPhotoPickerViewController : UINavigationController

@property (nonatomic, assign) NSUInteger pickerCount;


@property (nonatomic, assign) KXPickerFilterType filterType;

@property (nonatomic, weak) id <KXPhotoPickerViewController> photosDelegate;

@end
