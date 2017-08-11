//
//  KXPhotoBrowerController.m
//  KXPhotoBrower
//
//  Created by mac on 2017/8/2.
//  Copyright © 2017年 kit. All rights reserved.
//


#import "KXPhotoBrowerController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#import "KXBrowerToolView.h"
#import "KXBottomToolView.h"
#import "KXPhotoBrowerCell.h"


static NSString *KXBrowerCellReusedID = @"KXBrowerCellReusedID";

@interface KXPhotoBrowerController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation KXPhotoBrowerController {
    UICollectionView *_collectionView;
    KXBrowerToolView *_navView;
    KXBottomToolView *_bottomToolView;
    
    BOOL _showStatusBar;
}

- (void)loadView {
    [super loadView];
    //关闭页面自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}


- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (!parent) {
        NSLog(@"准备侧滑返回");
        if (self.returnBlock) {
            self.returnBlock();
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _showStatusBar = YES;
    
    [self setupNav];
    [self setupView];
    [self setupToolView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UI Action
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_navView.isShow) {
        [_navView hiddenWithAnimated:YES];
        [_bottomToolView hidden];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    } else {
        [_navView showWithAnimated:YES];
        [_bottomToolView show];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    }
    _showStatusBar = _navView.isShow;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - toolView UI Action
//左边按钮的点击
- (void)leftButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//右边按钮的点击
- (void)rightButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    //获取当前cell
    NSArray *array = _collectionView.visibleCells;
    if (array.count == 0) {
        return;
    }
    KXPhotoBrowerCell *currentCell = array[0];
    currentCell.model.selected = sender.selected;
    
    [self.selectedArray addObject:currentCell.model];
    _bottomToolView.badgeValue = [NSString stringWithFormat:@"%zd",_selectedArray.count];
}

//发送按钮的点击
- (void)sendButtonAction:(UIButton *)sender {
    NSLog(@"发送");
}


#pragma mark -
- (void)setupNav {
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)setupView {
    self.view.backgroundColor = [UIColor blackColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    [_collectionView registerClass:[KXPhotoBrowerCell class] forCellWithReuseIdentifier:KXBrowerCellReusedID];
    
}

- (void)setupToolView {
    _navView = [KXBrowerToolView toolView];
    _navView.style = KXBrowerToolViewWhiteStyle;
    _navView.titleStr = [NSString stringWithFormat:@"%zd/%zd",self.currentIndex,self.dataArray.count];
    
    [_navView setLeftButtonWithTarget:self action:@selector(leftButtonAction)];
    [_navView setRightButtonWithTarget:self action:@selector(rightButtonAction:)];
    [self.view addSubview:_navView];
    
    
    _bottomToolView = [[KXBottomToolView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 44)];
    [_bottomToolView setSendButtonWithTarget:self action:@selector(sendButtonAction:)];
    [self.view addSubview:_bottomToolView];
}


#pragma mark - collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KXPhotoBrowerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KXBrowerCellReusedID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}




- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(.0f, .0f, .0f, .0f);
}


#pragma mark - Nav Privated Method
- (BOOL)prefersStatusBarHidden {
    if (_showStatusBar) {
        return YES;
    }
    return NO;
}

#pragma mark - lazyLaod
- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}


@end
