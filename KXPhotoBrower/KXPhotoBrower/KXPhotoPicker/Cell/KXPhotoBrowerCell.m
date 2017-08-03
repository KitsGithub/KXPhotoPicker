//
//  KXPhotoBrowerCell.m
//  KXPhotoBrower
//
//  Created by mac on 2017/8/3.
//  Copyright © 2017年 kit. All rights reserved.
//

#import "KXPhotoBrowerCell.h"

@implementation KXPhotoBrowerCell {
    UIImageView *_imageView;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
}

- (void)setModel:(KXAlbumModel *)model {
    _model = model;
    
    PHImageRequestOptions *opt = [[PHImageRequestOptions alloc]init];
    opt.resizeMode = PHImageRequestOptionsResizeModeNone;
    opt.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    opt.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) contentMode:PHImageContentModeAspectFill options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            _imageView.image = result;
        }
    }];
}


- (void)layoutSubviews {
    _imageView.frame = self.bounds;
}

@end
