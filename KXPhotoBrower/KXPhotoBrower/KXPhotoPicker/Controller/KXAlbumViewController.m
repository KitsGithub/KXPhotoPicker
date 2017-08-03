//
//  KXAlbumViewController.m
//  KXPhotoBrower
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 kit. All rights reserved.
//

#import "KXAlbumViewController.h"
#import "KXAlbumCell.h"
#import "UIColor+My.h"

#import "KXPhotoPickerViewController.h"
#import "KXFlowViewController.h"


static NSString *AlbumCellReusedID = @"AlbumCellReusedID";

@interface KXAlbumViewController () <UITableViewDelegate,UITableViewDataSource>

//相册集合
@property (nonatomic, strong) PHFetchResult<PHAssetCollection *> *result;

@property (nonatomic, strong) NSMutableArray<KXPickerModel *> *dataArray;

@end

@implementation KXAlbumViewController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //处理权限问题
    [self getAblumJurisdiction];
    
    [self setupNav];
    [self setupView];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 监听相册权限
//监听相册权限的改变
- (void)getAblumJurisdiction {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                // TODO:...
                [self loadData];
            }
        }];
    }
}



#pragma mark - 加载相册内容
- (void)loadData {
    self.result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    
    for (NSInteger index = 0; index < self.result.count; index++) {
        PHAssetCollection *collection = self.result[index];
        //过滤掉视频和最近删除
        if (!(
              collection.assetCollectionSubtype == 1000000201  || //最近删除
              collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden ||//已隐藏
              collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumSlomoVideos ||//慢动作
              collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumPanoramas //全景照片
              )) {
            
                KXPickerModel *albumModel = [KXPickerModel new];
                albumModel.assetCollection = collection;
                albumModel.collectionName = collection.localizedTitle;
                
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                
                //过滤没有元素的相册
                if (fetchResult.count == 0) {
                    continue ;
                }
            
            [self.dataArray addObject:albumModel];
        }
    }
    
    [_tableView reloadData];
    
}

#pragma mark action
#pragma mark - 跳转到相册详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KXPickerModel *model = self.dataArray[indexPath.row];
    KXFlowViewController *picker = [[KXFlowViewController alloc] init];
    picker.albumCollection = model.assetCollection;
    picker.filterType = self.filterType;
    picker.albumName = model.collectionName;
    [self.navigationController pushViewController:picker animated:YES];
}


- (void)cancellAction {
    KXPhotoPickerViewController *navController = [self dnImagePickerController];
    if (navController && [navController.photosDelegate respondsToSelector:@selector(KXPhotoPickerViewControllerDidCancel:)]) {
        [navController.photosDelegate KXPhotoPickerViewControllerDidCancel:navController];
    }
}

- (KXPhotoPickerViewController *)dnImagePickerController
{
    if (nil == self.navigationController
        ||
        ![self.navigationController isKindOfClass:[KXPhotoPickerViewController class]])
    {
        NSAssert(false, @"check the navigation controller");
    }
    return (KXPhotoPickerViewController *)self.navigationController;
}




- (void)setupNav {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    if (self.filterType == KXPickerFilterTypePhotos || self.filterType == KXPickerFilterTypeNone) {
        titleLabel.text = @"照片";
    } else if (self.filterType == KXPickerFilterTypePhotos) {
        titleLabel.text = @"视频";
    }
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.navigationItem.titleView = titleLabel;
    
    
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

//界面
- (void)setupView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[KXAlbumCell class] forCellReuseIdentifier:AlbumCellReusedID];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KXAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumCellReusedID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}



#pragma mark - lazyLoad
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
