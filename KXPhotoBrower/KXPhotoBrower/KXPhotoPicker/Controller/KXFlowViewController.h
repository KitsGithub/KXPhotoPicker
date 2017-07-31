//
//  KXFlowViewController.h
//  KXPhotoBrower
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 kit. All rights reserved.
//

#import "BaseViewController.h"
#import "KXPhotosHeader.h"

@interface KXFlowViewController : BaseViewController

@property (nonatomic, assign) KXPickerFilterType filterType;

@property (nonatomic, weak) PHCollection *albumCollection;
@property (nonatomic, copy) NSString *albumName;
@end
