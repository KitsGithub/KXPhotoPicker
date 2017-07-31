//
//  KXAlbumCell.m
//  KXPhotoBrower
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 kit. All rights reserved.
//

#import "KXAlbumCell.h"
#import "UIColor+My.h"

#import "KXPhotosHeader.h"

@implementation KXAlbumCell {
    UIImageView *_albumImageView;
    UILabel *_titleLable;
    UIView *_lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _albumImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image_placeHolder"]];
    _albumImageView.contentMode = UIViewContentModeScaleAspectFill;
    _albumImageView.clipsToBounds = YES;
    [self addSubview:_albumImageView];
    
    _titleLable = [UILabel new];
    [self addSubview:_titleLable];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorFormHexRGB:@"e5e5e5"];
    [self addSubview:_lineView];
    
}


- (void)setModel:(KXPickerModel *)model {
    _model = model;
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:model.assetCollection options:nil];
    
    //防止在重用的时候，造成卡顿
    if (model.selectedArray == nil || model.selectedArray.count == 0) {
        NSMutableArray *countArray = [NSMutableArray array];
        if (model.assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumVideos) {
            for (PHAsset *videoAsset in fetchResult) {
                if (videoAsset.mediaType == PHAssetMediaTypeVideo && videoAsset.mediaSubtypes != PHAssetMediaSubtypeVideoHighFrameRate && videoAsset.duration <= VideoMaxTimeInterval) {
                    [countArray addObject:videoAsset];
                }
            }
        } else {
            for (PHAsset *photoAsset in fetchResult) {
                if (photoAsset.mediaType == PHAssetMediaTypeImage) {
                    [countArray addObject:photoAsset];
                }
            }
        }
        
        model.selectedArray = countArray;
    }
    
    
    NSString *targetStr = [NSString stringWithFormat:@"%@（%zd）",model.collectionName,model.selectedArray.count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:targetStr];
    [str setAttributes:@{NSForegroundColorAttributeName : [UIColor colorFormHexRGB:@"333333"],NSFontAttributeName : [UIFont systemFontOfSize:15]} range:[targetStr rangeOfString:model.collectionName]];
    
    _titleLable.attributedText = str;

    
    //从筛选后的数组中取出 最新图片
    PHAsset *asset = model.selectedArray.lastObject;
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    option.synchronous = YES;
    
    //使用带缓存功能的manager
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(60, 60) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {   //成功获取图片
            _albumImageView.image = result;
        }
    }];
    
}


- (void)layoutSubviews {
    CGFloat imageWH = CGRectGetHeight(self.frame) - 2;
    _albumImageView.frame = CGRectMake(12, (CGRectGetHeight(self.frame) - imageWH) * 0.5, imageWH, imageWH);
    
    CGFloat titleX = CGRectGetMaxX(_albumImageView.frame) + 12;
    _titleLable.frame = CGRectMake(titleX, 0, CGRectGetWidth(self.frame) - titleX , imageWH);
    
    _lineView.frame = CGRectMake(12, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame) - 12, 0.5);
}

@end
