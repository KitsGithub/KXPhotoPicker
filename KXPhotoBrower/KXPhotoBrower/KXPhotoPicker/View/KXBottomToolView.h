//
//  KXBottomToolView.h
//  KXPhotoBrower
//
//  Created by mac on 2017/8/11.
//  Copyright © 2017年 kit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KXBottomToolView : UIView

- (void)show;
- (void)hidden;


/**
 数量
 */
@property (nonatomic, copy) NSString *badgeValue;

/**
 设置发送按钮的点击事件
 */
- (void)setSendButtonWithTarget:(id)target action:(SEL)action;

@end
