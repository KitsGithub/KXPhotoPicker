//
//  KXAlbumTableViewController.m
//  KXPhotoBrower
//
//  Created by mac on 17/4/20.
//  Copyright © 2017年 kit. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import "KXPhotoPickerViewController.h"
#import "KXAlbumTableViewController.h"
#import "KXAlbumCell.h"

#import "KXImageFlowViewController.h" //图片

#define isIOS8 [[UIDevice currentDevice].systemVersion doubleValue]>=8.0?YES:NO

@interface KXAlbumTableViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSMutableArray<KXAlbumModel *> *dataArray;

@end

static NSString *KXAlbumTableCellID = @"KXAlbumTableCellID";

@implementation KXAlbumTableViewController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"相簿";
    
    [self getAblumJurisdiction];
    
    [self setNav];
    [self setupView];
    [self setAlbumData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//打开相册权限，并监听权限的改变
- (void)getAblumJurisdiction {
    if (isIOS8) {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
            
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                if (*stop) {
                    
                    // TODO:...
                    [self setAlbumData];
                    return;
                }
                *stop = TRUE;//不能省略
                
            } failureBlock:^(NSError *error) {
                
                NSLog(@"failureBlock");
            }];
        }
        
    } else {
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
            
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized) {
                    
                    // TODO:...
                    [self setAlbumData];
                }
            }];
        }
    }
}

//加载相册数据源
- (void)setAlbumData {
    
    PHFetchResult *album = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    
    for (NSInteger index = 0; index < album.count; index++) {
        PHAssetCollection *collection = album[index];
        //相机胶卷 自拍 已隐藏 慢动作 全景照片 屏幕快照 视频 延时摄影 最近添加 连拍快照 最近删除 个人收藏
        //过滤掉视频和最近删除
        if (!([collection.localizedTitle isEqualToString:@"Recently Deleted"] ||
              [collection.localizedTitle isEqualToString:@"Videos"] ||
              [collection.localizedTitle isEqualToString:@"最近删除"] ||
              [collection.localizedTitle isEqualToString:@"已隐藏"] ||
              [collection.localizedTitle isEqualToString:@"视频"] ||
              [collection.localizedTitle isEqualToString:@"慢动作"] ||
              [collection.localizedTitle isEqualToString:@"全景照片"])) {
            
            KXAlbumModel *albumModel = [KXAlbumModel new];
            albumModel.albumCollection = collection;
            albumModel.albumName = collection.localizedTitle;
            
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            //从相册中取出第一张图片
            PHAsset *asset = fetchResult.firstObject;
            if (!asset) {
                continue ;
            }
            
            [self.dataArray addObject:albumModel];
        }
    }
    [_tableView reloadData];
}


- (void)backAction {
    KXPhotoPickerViewController *navController = [self KXImagePickerController];
    if (navController && [navController.photoDelegate respondsToSelector:@selector(KXPhotoPickerViewControllerDidCancel:)]) {
        [navController.photoDelegate KXPhotoPickerViewControllerDidCancel:navController];
    }
}

- (void)setNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Nav_Back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}


- (void)setupView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[KXAlbumCell class] forCellReuseIdentifier:KXAlbumTableCellID];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KXAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:KXAlbumTableCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KXImageFlowViewController *imageFlow = [[KXImageFlowViewController alloc] init];
    imageFlow.kDNImageFlowMaxSeletedNumber = self.kDNImageFlowMaxSeletedNumber;
    imageFlow.albumModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:imageFlow animated:YES];
}

#pragma mark - privitedAction
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
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
