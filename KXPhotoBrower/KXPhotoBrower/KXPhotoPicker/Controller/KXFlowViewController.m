//
//  KXFlowViewController.m
//  KXPhotoBrower
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 kit. All rights reserved.
//

#import "KXFlowViewController.h"
#import "KXPhotoBrowerController.h"
#import "KXPhotoPickerViewController.h"
#import "FlowViewCell.h"


static NSString *FlowViewCellReusedId = @"FlowViewCellReusedId";

@interface KXFlowViewController ()  <UICollectionViewDelegate,UICollectionViewDataSource>

//展示数据源
@property (nonatomic, strong) NSMutableArray<KXAlbumModel *> *dataArray;

//已选中图片
@property (nonatomic, strong) NSMutableArray<PHAsset *> *selectedAssetsArray;
//已选中的视频
@property (nonatomic, strong) NSMutableArray<PHAsset *> *selectedVedioAssetsArray;

@end

@implementation KXFlowViewController {
    UICollectionView *_imageFlowCollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNav];
    [self setupView];
    [self loadData];
    
    [self scrollerToBottom:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据加载
- (void)loadData {
    //根据 filterType 筛选当前展示内容
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:self.albumCollection options:nil];
    for (PHAsset *asset in fetchResult) {
        KXAlbumModel *model = [KXAlbumModel new];
        switch (self.filterType) {
            case KXPickerFilterTypePhotos: {
                if (asset.mediaType == PHAssetMediaTypeImage) {
                    
                    model.asset = asset;
                    [self.dataArray addObject:model];
                }
            }
                break;
            case KXPickerFilterTypeVideos: {
                //这里过滤掉 高帧视频,和 比设定时长大的视频
                if (asset.mediaType == PHAssetMediaTypeVideo && asset.mediaSubtypes != PHAssetMediaSubtypeVideoHighFrameRate && asset.duration <= VideoMaxTimeInterval) {
                    
                    model.asset = asset;
                    [self.dataArray addObject:model];
                }
            }
            default:
                break;
        }
    }
    
    [_imageFlowCollectionView reloadData];
}

#pragma mark - provietedMouthd
- (void)scrollerToBottom:(BOOL)animated {
    if (!self.dataArray.count) {
        return;
    }
    NSInteger rows = [_imageFlowCollectionView numberOfItemsInSection:0] - 1;
    rows = rows < 0 ? 0 : rows;
    [_imageFlowCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:rows inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:animated];
}


- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancellAction {
    KXPhotoPickerViewController *navController = [self dnImagePickerController];
    if (navController && [navController.photosDelegate respondsToSelector:@selector(KXPhotoPickerViewControllerDidCancel:)]) {
        [navController.photosDelegate KXPhotoPickerViewControllerDidCancel:navController];
    }
}

- (KXPhotoPickerViewController *)dnImagePickerController
{
    if (nil == self.navigationController ||
        ![self.navigationController isKindOfClass:[KXPhotoPickerViewController class]])
    {
        NSAssert(false, @"check the navigation controller");
    }
    return (KXPhotoPickerViewController *)self.navigationController;
}




#pragma mark - 布局
- (void)setupNav {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    if (self.filterType == KXPickerFilterTypePhotos || self.filterType == KXPickerFilterTypeNone) {
        titleLabel.text = self.albumName;
    } else if (self.filterType == KXPickerFilterTypeVideos) {
        titleLabel.text = @"视频";
    }
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.navigationItem.titleView = titleLabel;
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn setImage:[UIImage imageNamed:@"NewCircle_Nav_Back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 49 - 26, 0, -19);
    [button setTitleEdgeInsets:insets];
    [button setFrame:CGRectMake(0, 0, 64, 30)];
    [button addTarget:self action:@selector(cancellAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button setTitleColor:[UIColor colorFormHexRGB:@"808080"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/4
- (void)setupView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing = 2.0;
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
    
    CGFloat collectionHeight;
    if (self.filterType != KXPickerFilterTypeVideos) {
        collectionHeight = [UIScreen mainScreen].bounds.size.height - 39 - 69;
    } else {
        collectionHeight = [UIScreen mainScreen].bounds.size.height - 64;
    }
    _imageFlowCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, collectionHeight) collectionViewLayout:layout];
    _imageFlowCollectionView.delegate = self;
    _imageFlowCollectionView.dataSource = self;
    _imageFlowCollectionView.showsHorizontalScrollIndicator = YES;
    _imageFlowCollectionView.alwaysBounceVertical = YES;
    if (self.filterType != KXPickerFilterTypeVideos) {
        _imageFlowCollectionView.backgroundColor = [UIColor colorFormHexRGB:@"f7f8f9"];
    } else {
        _imageFlowCollectionView.backgroundColor = [UIColor blackColor];
    }
    
    [_imageFlowCollectionView registerClass:[FlowViewCell class] forCellWithReuseIdentifier:FlowViewCellReusedId];
    [self.view addSubview:_imageFlowCollectionView];
}

#pragma mark - collectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlowViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FlowViewCellReusedId forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KXPhotoBrowerController *photoBrower = [[KXPhotoBrowerController alloc] init];
    photoBrower.dataArray = self.dataArray;
    photoBrower.currentIndex = indexPath.row;
    [self.navigationController pushViewController:photoBrower animated:YES];
}



#pragma mark - lazyload
- (NSMutableArray<PHAsset *> *)selectedAssetsArray {
    if (!_selectedAssetsArray) {
        _selectedAssetsArray = [NSMutableArray array];
    }
    return _selectedAssetsArray;
}

- (NSMutableArray<PHAsset *> *)selectedVedioAssetsArray {
    if (!_selectedVedioAssetsArray) {
        _selectedVedioAssetsArray = [NSMutableArray array];
    }
    return _selectedVedioAssetsArray;
}


- (NSMutableArray<KXAlbumModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
