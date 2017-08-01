//
//  KXAlbumModel.h
//  KXPhotoBrower
//
//  Created by mac on 2017/8/1.
//  Copyright © 2017年 kit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


@interface KXAlbumModel : NSObject

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end
