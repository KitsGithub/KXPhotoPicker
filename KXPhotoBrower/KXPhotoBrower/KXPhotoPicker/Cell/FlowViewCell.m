//
//  FlowViewCell.m
//  KXPhotoBrower
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 kit. All rights reserved.
//

#import "FlowViewCell.h"

@implementation FlowViewCell {
    UIImageView *_imageView;
    UIButton *_checkButton;
    UILabel *_videoDurationLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
    
    _checkButton = [UIButton new];
    _checkButton.backgroundColor = [UIColor redColor];
//    [self addSubview:_checkButton];
    
    _videoDurationLabel = [UILabel new];
    _videoDurationLabel.textColor = [UIColor whiteColor];
    _videoDurationLabel.font = [UIFont systemFontOfSize:13];
    _videoDurationLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_videoDurationLabel];
    
    
}

#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/4
- (void)setModel:(KXAlbumModel *)model {
    _model = model;
    
    PHImageRequestOptions *opt = [[PHImageRequestOptions alloc]init];
    opt.resizeMode = PHImageRequestOptionsResizeModeFast;
    opt.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    opt.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView) contentMode:PHImageContentModeAspectFill options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            _imageView.image = result;
        }
    }];
    
    
    if (model.asset.mediaType == PHAssetMediaTypeVideo) {
        _checkButton.hidden = YES; //_checkImageView.hidden = YES;
        NSString *duration = [NSString string];
        double time = ceilf(model.asset.duration); //往上取整
        NSInteger min = time / 60;
        NSInteger second = (int)time % 60;
        NSString *minStr = [NSString string];
        if (min < 10) {
            minStr = [NSString stringWithFormat:@"0%zd",min];
        } else {
            minStr = [NSString stringWithFormat:@"%zd",min];
        }
        if (second < 10) {
            duration = [NSString stringWithFormat:@"%@:0%zd",minStr,second];
        } else {
            duration = [NSString stringWithFormat:@"%@:%zd",minStr,second];
        }
        _videoDurationLabel.text = duration;
    } else {
        _checkButton.hidden = NO; //_checkImageView.hidden = NO;
    }
    [self setNeedsLayout];
}



- (void)layoutSubviews {
    
    _imageView.frame = self.bounds;
    _checkButton.frame = CGRectMake(CGRectGetWidth(self.frame) - 40, 0, 40, 40);
    
    CGSize durationSize = [_videoDurationLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size;
    
    _videoDurationLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - durationSize.width , CGRectGetHeight(self.frame) - durationSize.height, durationSize.width, durationSize.height);
    
    
    
}



@end
