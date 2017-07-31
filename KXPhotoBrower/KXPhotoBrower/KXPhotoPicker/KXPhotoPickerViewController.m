//
//  KXPhotoPickerViewController.m
//  KXPhotoBrower
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 kit. All rights reserved.
//

#import "KXPhotoPickerViewController.h"
#import "KXAlbumViewController.h"

@interface KXPhotoPickerViewController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<UINavigationControllerDelegate> navDelegate;
@property (nonatomic, assign) BOOL isDuringPushAnimation;

@end

@implementation KXPhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!self.delegate) {
        self.delegate = self;
    }
    
    self.interactivePopGestureRecognizer.delegate = self;
    
    [self showAlbumList];
    
}

#pragma mark - priviate methods
- (void)showAlbumList {
    KXAlbumViewController *albumTableViewController = [[KXAlbumViewController alloc] init];
    albumTableViewController.filterType = self.filterType;
    [self setViewControllers:@[albumTableViewController]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UINavigationController
- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    [super setDelegate:delegate ? self : nil];
    self.navDelegate = delegate != self ? delegate : nil;
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated __attribute__((objc_requires_super)) {
    self.isDuringPushAnimation = YES;
    [super pushViewController:viewController animated:animated];
}



#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    self.isDuringPushAnimation = NO;
    if ([self.navDelegate respondsToSelector:_cmd]) {
        [self.navDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return [self.viewControllers count] > 1 && !self.isDuringPushAnimation;
    } else {
        return YES;
    }
}

#pragma mark - Delegate Forwarder

- (BOOL)respondsToSelector:(SEL)s
{
    return [super respondsToSelector:s] || [self.navDelegate respondsToSelector:s];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)s
{
    return [super methodSignatureForSelector:s] ?: [(id)self.navDelegate methodSignatureForSelector:s];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    id delegate = self.navDelegate;
    if ([delegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:delegate];
    }
}

@end
