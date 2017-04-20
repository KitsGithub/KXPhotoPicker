//
//  KXImageFlowViewController.m
//  KXPhotoBrower
//
//  Created by mac on 17/4/20.
//  Copyright © 2017年 kit. All rights reserved.
//
#import <Photos/Photos.h>
#import "KXImageFlowViewController.h"
#import "KXPhotoPickerViewController.h"
#import "DNAssetsViewCell.h"

#import "UIColor+My.h"
#import "DNSendButton.h"

@interface KXImageFlowViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
DNAssetsViewCellDelegate
>

//已选中图片
@property (nonatomic, strong) NSMutableArray<PHAsset *> *selectedAssetsArray;

//相片数据源
@property (nonatomic, strong) NSMutableArray<PHAsset *> *albumAssetArray;
@property (nonatomic, strong) DNSendButton *sendButton;
@end

@implementation KXImageFlowViewController {
    UICollectionView *_collectionView;
    UIToolbar *_toolBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNav];
    [self setupView];
    [self setupData];
    [self scrollerToBottom:NO];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNav {
    self.title = self.albumModel.albumName;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)backAction {
    KXPhotoPickerViewController *navController = [self KXImagePickerController];
    if (navController && [navController.photoDelegate respondsToSelector:@selector(KXPhotoPickerViewControllerDidCancel:)]) {
        [navController.photoDelegate KXPhotoPickerViewControllerDidCancel:navController];
    }
}

#pragma mark - 获取相册图片数据
- (void)setupData {
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:self.albumModel.albumCollection options:nil];
    //从相册中取出第一张图片
    
    //筛选当前相册图片内容 排除掉图片以外的
    for (PHAsset *asset in fetchResult) {
        if (asset.mediaType == PHAssetMediaTypeImage) {
            [self.albumAssetArray addObject:asset];
        }
    }
    
    [_collectionView reloadData];
}


#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/4
static NSString *KXImageFlowCellID = @"KXImageFlowCellID";
#pragma mark - 布局
- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing = 2.0;
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.view.frame) - 49 - 64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = YES;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor colorFormHexRGB:@"f7f8f9"];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[DNAssetsViewCell class] forCellWithReuseIdentifier:KXImageFlowCellID];
    
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 49 - 64, [UIScreen mainScreen].bounds.size.width, 49)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(previewAction)];
    [item1 setTintColor:[UIColor blackColor]];
    item1.enabled = NO;
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:self.sendButton];
    
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item4.width = -10;
    
    _toolBar.items = @[item1,item2,item3,item4];
    [self.view addSubview:_toolBar];
    
//    [self setToolbarItems:@[item1,item2,item3,item4] animated:NO];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumAssetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DNAssetsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KXImageFlowCellID forIndexPath:indexPath];
    cell.delegate = self;
    [cell fillWithImage:self.albumAssetArray[indexPath.row] isSelected:NO];
    return cell;
}

#pragma mark - previewAction 预览功能
- (void)previewAction {
    
}

#pragma mark - sendButtonAction 发送功能
- (void)sendButtonAction:(UIButton *)sender {
    if (self.selectedAssetsArray.count > 0) {
        [self sendImages];
    }
}

- (void)sendImages {
    KXPhotoPickerViewController *imagePicker = [self KXImagePickerController];
    if (imagePicker && [imagePicker.photoDelegate respondsToSelector:@selector(KXPhotoPickerViewController:didSelectedImage:)]) {
        [imagePicker.photoDelegate KXPhotoPickerViewController:imagePicker didSelectedImage:self.selectedAssetsArray];
    }
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - cellDelegate cell的代理
- (void)didSelectItemAssetsViewCell:(DNAssetsViewCell *)assetsCell {
    assetsCell.isSelected = [self seletedAssets:assetsCell.phAsset];
}
- (void)didDeselectItemAssetsViewCell:(DNAssetsViewCell *)assetsCell {
    assetsCell.isSelected = NO;
    [self deseletedAssets:assetsCell.phAsset];
}


#pragma mark - privitedAction 增删选中图片
- (BOOL)assetIsSelected:(PHAsset *)targetAsset
{
    for (PHAsset *asset in self.selectedAssetsArray) {
        if (asset == targetAsset) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)seletedAssets:(PHAsset *)asset
{
    if ([self assetIsSelected:asset]) {
        return NO;
    }
    UIBarButtonItem *firstItem = _toolBar.items.firstObject;
    firstItem.enabled = YES;
    if (self.selectedAssetsArray.count >= self.kDNImageFlowMaxSeletedNumber) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"只能选这么多了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    } else {
        [self addAssetsObject:asset];
        self.sendButton.badgeValue = [NSString stringWithFormat:@"%@",@(self.selectedAssetsArray.count)];
        return YES;
    }
}

- (void)deseletedAssets:(PHAsset *)asset
{
    [self removeAssetsObject:asset];
    self.sendButton.badgeValue = [NSString stringWithFormat:@"%@",@(self.selectedAssetsArray.count)];
    if (self.selectedAssetsArray.count < 1) {
        UIBarButtonItem *firstItem = _toolBar.items.firstObject;
        firstItem.enabled = NO;
    }
}

- (void)removeAssetsObject:(PHAsset *)asset
{
    if ([self assetIsSelected:asset]) {
        [self.selectedAssetsArray removeObject:asset];
    }
}

- (void)addAssetsObject:(PHAsset *)asset
{
    [self.selectedAssetsArray addObject:asset];
}

#pragma mark - helpfully Methods
- (void)scrollerToBottom:(BOOL)animated
{
    NSInteger rows = [_collectionView numberOfItemsInSection:0] - 1;
    rows = rows < 0 ? 0 : rows;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:rows inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:animated];
}

- (KXPhotoPickerViewController *)KXImagePickerController
{
    
    if (nil == self.navigationController
        ||
        NO == [self.navigationController isKindOfClass:[KXPhotoPickerViewController class]])
    {
        NSAssert(false, @"check the navigation controller");
    }
    return (KXPhotoPickerViewController *)self.navigationController;
}

#pragma mark - lazyLoad
- (NSMutableArray<PHAsset *> *)albumAssetArray {
    if (!_albumAssetArray) {
        _albumAssetArray = [NSMutableArray array];
    }
    return _albumAssetArray;
}

- (NSMutableArray<PHAsset *> *)selectedAssetsArray {
    if (!_selectedAssetsArray) {
        _selectedAssetsArray = [NSMutableArray array];
    }
    return _selectedAssetsArray;
}

- (DNSendButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [[DNSendButton alloc] initWithFrame:CGRectZero];
        [_sendButton addTaget:self action:@selector(sendButtonAction:)];
    }
    return  _sendButton;
}


@end
