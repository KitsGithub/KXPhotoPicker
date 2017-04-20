//
//  KXAlbumCell.m
//  KXPhotoBrower
//
//  Created by mac on 17/4/20.
//  Copyright © 2017年 kit. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "KXAlbumCell.h"
#import "UIColor+My.h"

#define NameFont [UIFont systemFontOfSize:15]

@implementation KXAlbumCell {
    UIImageView *_albumImageView;
    UILabel *_albumNameLabel;
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
    _albumImageView = [[UIImageView alloc] init];
    [self addSubview:_albumImageView];
    
    _albumNameLabel = [[UILabel alloc] init];
    _albumNameLabel.font = NameFont;
    _albumNameLabel.textColor = [UIColor colorFormHexRGB:@"bcbcbc"];
    [self addSubview:_albumNameLabel];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorFormHexRGB:@"e5e5e5"];
    [self addSubview:_lineView];
}

- (void)setModel:(KXAlbumModel *)model {
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:model.albumCollection options:nil];
    NSString *targetStr = [NSString stringWithFormat:@"%@（%zd）",model.albumName,fetchResult.count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:targetStr];
    [str setAttributes:@{NSForegroundColorAttributeName : [UIColor colorFormHexRGB:@"333333"],NSFontAttributeName : NameFont} range:[targetStr rangeOfString:model.albumName]];
    
    _albumNameLabel.attributedText = str;
    
    //从相册中取出第一张图片
    PHAsset *asset = fetchResult.firstObject;
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    option.synchronous = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(60, 60) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {   //成功获取图片，添加到数组里
            _albumImageView.image = result;
        } else {        //若失败，则加载一张站位图
            _albumImageView.image = [UIImage imageNamed:@"KXAlbum_PlaceHolder"];
        }
    }];
    
    [self setNeedsLayout];
}



- (void)layoutSubviews {
    CGFloat padding = 5;
    CGFloat albumWH = CGRectGetHeight(self.frame) - 2;
    _albumImageView.frame = CGRectMake(12, 1, albumWH, albumWH);
    
    CGFloat albumNameX = CGRectGetMaxX(_albumImageView.frame) + padding * 2;
    _albumNameLabel.frame = CGRectMake(albumNameX, 0, CGRectGetWidth(self.frame) - albumNameX, CGRectGetHeight(self.frame));
    
    _lineView.frame = CGRectMake(albumNameX, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame) - albumNameX, 0.5);
}


@end
