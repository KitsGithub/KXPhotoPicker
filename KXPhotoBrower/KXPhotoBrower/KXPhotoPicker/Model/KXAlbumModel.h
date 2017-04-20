//
//  KXAlbumModel.h
//  KXPhotoBrower
//
//  Created by mac on 17/4/20.
//  Copyright © 2017年 kit. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PHAssetCollection;

@interface KXAlbumModel : NSObject

@property (nonatomic, strong) PHAssetCollection *albumCollection;

@property (nonatomic, copy) NSString *albumName;

@end
