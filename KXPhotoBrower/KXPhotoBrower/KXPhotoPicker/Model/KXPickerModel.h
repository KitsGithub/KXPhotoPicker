//
//  KXPickerModel.h
//  KXPhotoBrower
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 kit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface KXPickerModel : NSObject

//单个相册集合
@property (nonatomic, weak) PHAssetCollection *assetCollection;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, copy) NSString *collectionName;

@end
