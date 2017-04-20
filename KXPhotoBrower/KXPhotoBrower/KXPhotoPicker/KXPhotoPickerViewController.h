//
//  KXPhotoPickerViewController.h
//  KXPhotoBrower
//
//  Created by mac on 17/4/20.
//  Copyright © 2017年 kit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class KXPhotoPickerViewController;
@protocol KXPhotoPickerViewController <NSObject>

//图片选择代理方法
- (void)KXPhotoPickerViewController:(KXPhotoPickerViewController *)pickerViewController didSelectedImage:(NSArray<PHAsset *> *)imageArray;

//取消代理方法
- (void)KXPhotoPickerViewControllerDidCancel:(KXPhotoPickerViewController *)photoPickerViewController;

@end

@interface KXPhotoPickerViewController : UINavigationController

@property (nonatomic, weak) id <KXPhotoPickerViewController> photoDelegate;

@property (nonatomic, assign) int kDNImageFlowMaxSeletedNumber;

@end
