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
}


- (void)openKXPhotoPicker {
    KXPhotoPickerViewController *photoPicker = [[KXPhotoPickerViewController alloc] init];
    photoPicker.photosDelegate = self;
    [self presentViewController:photoPicker animated:YES completion:nil];
}

//- (void)KXPhotoPickerViewController:(KXPhotoPickerViewController *)pickerViewController didSelectedImage:(NSArray *)imageArray {
//    
//    //异步获取选择的元数据 （也可以把 opt.synchronous 设置为NO，改为同步获取 ,但是要特别注意性能问题）
//    PHImageRequestOptions *opt = [[PHImageRequestOptions alloc]init];
//    opt.resizeMode = PHImageRequestOptionsResizeModeNone;
//    opt.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
//    opt.synchronous = YES;
//    
//    for (NSInteger index = 0; index < imageArray.count; index++) {
//        PHAsset *asset = imageArray[index];
//        [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            if (result) {
//                
//                //todo..
//                NSLog(@"%@",result);
//            }
//        }];
//    }
//}

//取消代理
- (void)KXPhotoPickerViewControllerDidCancel:(KXPhotoPickerViewController *)photoPickerViewController {
    [photoPickerViewController dismissViewControllerAnimated:YES completion:nil];
}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}


@end
