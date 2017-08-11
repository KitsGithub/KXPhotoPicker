//
//  ViewController.m
//  KXPhotoBrower
//
//  Created by mac on 17/4/20.
//  Copyright © 2017年 kit. All rights reserved.
//

#import "ViewController.h"
#import "KXPhotoPickerViewController.h"

@interface ViewController () <KXPhotoPickerViewController>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    
    UIButton *sender = [[UIButton alloc] initWithFrame:CGRectMake(30, 100, [UIScreen mainScreen].bounds.size.width - 60, 50)];
    [sender setTitle:@"打开相册" forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor yellowColor];
    [sender addTarget:self action:@selector(openKXPhotoPicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sender];
    
    
    UIButton *sender2 = [[UIButton alloc] initWithFrame:CGRectMake(30, 180, [UIScreen mainScreen].bounds.size.width - 60, 50)];
    [sender2 setTitle:@"打开视频" forState:UIControlStateNormal];
    [sender2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender2.backgroundColor = [UIColor yellowColor];
    [sender2 addTarget:self action:@selector(openVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sender2];
}


- (void)openKXPhotoPicker {
    KXPhotoPickerViewController *photoPicker = [[KXPhotoPickerViewController alloc] init];
    photoPicker.filterType = KXPickerFilterTypePhotos;
    photoPicker.photosDelegate = self;
    [self presentViewController:photoPicker animated:YES completion:nil];
}


- (void)openVideo {
    KXPhotoPickerViewController *photoPicker = [[KXPhotoPickerViewController alloc] init];
    photoPicker.filterType = KXPickerFilterTypeVideos;
    photoPicker.photosDelegate = self;
    [self presentViewController:photoPicker animated:YES completion:nil];
}

- (void)KXPhotoPickerViewController:(KXPhotoPickerViewController *)pickerViewController didSelectedImage:(NSArray<UIImage *> *)imageArray{

    for (NSInteger index = 0; index < imageArray.count; index++) {
        UIImage *image = imageArray[index];
        CGFloat width = 100;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * index, 250, width, width)];
        imageView.image = image;
        [self.view addSubview:imageView];
    }
        
        
        
    [pickerViewController dismissViewControllerAnimated:YES completion:nil];
    
}

//取消代理
- (void)KXPhotoPickerViewControllerDidCancel:(KXPhotoPickerViewController *)photoPickerViewController {
    [photoPickerViewController dismissViewControllerAnimated:YES completion:nil];
}



@end
