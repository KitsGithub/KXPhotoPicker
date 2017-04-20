//
//  KXPhotoPickerViewController.m
//  KXPhotoBrower
//
//  Created by mac on 17/4/20.
//  Copyright © 2017年 kit. All rights reserved.
//

#import "KXPhotoPickerViewController.h"

#import "KXAlbumTableViewController.h" //相簿
#import "UIColor+My.h"

@interface KXPhotoPickerViewController ()

<
UIGestureRecognizerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, weak) id<UINavigationControllerDelegate> navDelegate;
@property (nonatomic, assign) BOOL isDuringPushAnimation;

@end

@implementation KXPhotoPickerViewController {
    UIView *_lineView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!self.delegate) {
        self.delegate = self;
    }
    
    self.interactivePopGestureRecognizer.delegate = self;
    
    [self findBottomLineView];
    
    [self showAlbumList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlbumList
{
    KXAlbumTableViewController *albumTableViewController = [[KXAlbumTableViewController alloc] init];
    albumTableViewController.kDNImageFlowMaxSeletedNumber = self.kDNImageFlowMaxSeletedNumber;
    [self setViewControllers:@[albumTableViewController]];
}


//设置导航栏底部的分割线
- (void)findBottomLineView {
    //设置导航栏底线
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationBar];
    navBarHairlineImageView.hidden = YES;
    
    UIView *lineView = [[UIView alloc] initWithFrame:navBarHairlineImageView.frame];
    _lineView = lineView;
    lineView.backgroundColor = [UIColor colorFormHexRGB:@"e6e7ea"];
    [self.navigationBar addSubview:lineView];
}


- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews) {
        
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


#pragma mark - UINavigationController


@end
