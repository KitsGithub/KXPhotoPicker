//
//  KXPhotoBrowserController.m
//  KXPhotoBrower
//
//  Created by mac on 17/4/20.
//  Copyright © 2017年 kit. All rights reserved.
//

#import "KXPhotoBrowserController.h"
#import "KXBrowserCell.h"
#import "DNSendButton.h"

@interface KXPhotoBrowserController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *photosArray;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) DNSendButton *sendButton;

@end

@implementation KXPhotoBrowserController {
    UICollectionView *_collectionView;
    
    BOOL _statusBarShouldBeHidden;
    BOOL _didSavePreviousStateOfNavBar;
    BOOL _viewIsActive;
    BOOL _viewHasAppearedInitially;
    // Appearance
    BOOL _previousNavBarHidden;
    BOOL _previousNavBarTranslucent;
    UIBarStyle _previousNavBarStyle;
    UIStatusBarStyle _previousStatusBarStyle;
    UIColor *_previousNavBarTintColor;
    UIColor *_previousNavBarBarTintColor;
    UIBarButtonItem *_previousViewControllerBackButton;
    UIImage *_previousNavigationBarBackgroundImageDefault;
    UIImage *_previousNavigationBarBackgroundImageLandscapePhone;
}

- (instancetype)initWithPHPhotosArray:(NSMutableArray<PHAsset *> *)photosArray
                         currentIndex:(NSInteger)index {
    if (self = [super init]) {
        self.currentIndex = index;
        self.photosArray = photosArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


static NSString *KXPhotoBrowserCellID = @"KXPhotoBrowserCellID";
- (void)setupView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.clipsToBounds = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width+20, self.view.bounds.size.height);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, CGRectGetWidth(self.view.frame) + 20, CGRectGetHeight(self.view.frame) + 1) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[KXBrowserCell class] forCellWithReuseIdentifier:KXPhotoBrowserCellID];
    
    
    CGFloat height = 44;
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - height, self.view.bounds.size.width, height)];
    if ([[UIToolbar class] respondsToSelector:@selector(appearance)]) {
        [_toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [_toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsCompact];
    }
    _toolbar.barStyle = UIBarStyleBlackTranslucent;
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_toolbar];
    
    
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KXBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KXPhotoBrowserCellID forIndexPath:indexPath];
    cell.asset = self.photosArray[indexPath.row];
    return cell;
}


#pragma mark - Control Hiding / Showing
// Fades all controls slide and fade
- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated{
    
    // Force visible
    if (nil == self.photosArray || self.photosArray.count == 0)
        hidden = NO;
    // Animations & positions
    CGFloat animatonOffset = 20;
    CGFloat animationDuration = (animated ? 0.35 : 0);
    
    // Status bar
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // Hide status bar
        _statusBarShouldBeHidden = hidden;
        [UIView animateWithDuration:animationDuration animations:^(void) {
            [self setNeedsStatusBarAppearanceUpdate];
        } completion:^(BOOL finished) {}];
    }
    
    CGRect frame = CGRectIntegral(CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44));
    
    // Pre-appear animation positions for iOS 7 sliding
    if ([self areControlsHidden] && !hidden && animated) {
        // Toolbar
        self.toolbar.frame = CGRectOffset(frame, 0, animatonOffset);
    }
    
    [UIView animateWithDuration:animationDuration animations:^(void) {
        CGFloat alpha = hidden ? 0 : 1;
        // Nav bar slides up on it's own on iOS 7
        [self.navigationController.navigationBar setAlpha:alpha];
        // Toolbar
        _toolbar.frame = frame;
        if (hidden) _toolbar.frame = CGRectOffset(_toolbar.frame, 0, animatonOffset);
        _toolbar.alpha = alpha;
        
    } completion:^(BOOL finished) {}];
}

- (BOOL)prefersStatusBarHidden {
    return _statusBarShouldBeHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}



- (BOOL)areControlsHidden { return (_toolbar.alpha == 0); }
- (void)hideControls { [self setControlsHidden:YES animated:YES]; }
- (void)toggleControls { [self setControlsHidden:![self areControlsHidden] animated:YES]; }


#pragma mark - lazyLoad
- (NSMutableArray<PHAsset *> *)photosArray {
    if (!_photosArray) {
        _photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

@end
