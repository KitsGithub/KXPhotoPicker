//
//  KXPhotosHeader.h
//  KXPhotoBrower
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 kit. All rights reserved.
//

#ifndef KXPhotosHeader_h
#define KXPhotosHeader_h


typedef NS_ENUM(NSUInteger, KXPickerFilterType) {
    KXPickerFilterTypeNone = 0,
    KXPickerFilterTypePhotos,
    KXPickerFilterTypeVideos,
    KXPickerFilterTypeAudio
};

#define VideoMaxTimeInterval MAXFLOAT        //允许视频最大秒数

#define RandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];


#endif /* KXPhotosHeader_h */
