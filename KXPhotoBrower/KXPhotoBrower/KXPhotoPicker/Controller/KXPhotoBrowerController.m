//
//  KXPhotoBrowerController.m
//  KXPhotoBrower
//
//  Created by mac on 2017/8/2.
//  Copyright © 2017年 kit. All rights reserved.
//


#import "KXPhotoBrowerController.h"


#import "KXBrowerToolView.h"
#import "KXPhotoBrowerCell.h"


static NSString *KXBrowerCellReusedID = @"KXBrowerCellReusedID";

@interface KXPhotoBrowerController () <UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation KXPhotoBrowerController {
    UICollectionView *_collectionView;
    KXBrowerToolView *_toolView;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNav];
    [self setupView];
    [self setupToolView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UIAction
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_toolView.isShow) {
        [_toolView hiddenWithAnimated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    } else {
        [_toolView showWithAnimated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
}

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
}


#pragma mark -
- (void)setupNav {
    
}

- (void)setupView {
    self.view.backgroundColor = [UIColor blackColor];
    self.providesPresentationContextTransitionStyle = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 64);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    [_collectionView registerClass:[KXPhotoBrowerCell class] forCellWithReuseIdentifier:KXBrowerCellReusedID];
    
}

- (void)setupToolView {
    _toolView = [KXBrowerToolView toolView];
    _toolView.style = KXBrowerToolViewWhiteStyle;
    _toolView.titleStr = [NSString stringWithFormat:@"%zd/%zd",self.currentIndex,self.dataArray.count];
    
    [_toolView setLeftButtonWithTarget:self action:@selector(leftButtonAction)];
    [_toolView setRightButtonWithTarget:self action:@selector(rightButtonAction:)];
    [self.view addSubview:_toolView];
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
//    cell.backgroundColor = RandomColor;
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
    return YES;
}



@end
