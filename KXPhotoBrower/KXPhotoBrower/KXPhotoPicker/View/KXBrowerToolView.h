//
//  KXBrowerToolView.h
//  KXPhotoBrower
//
//  Created by mac on 2017/8/3.
//  Copyright © 2017年 kit. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSUInteger KXBrowerToolHeight = 64;

typedef enum : NSUInteger {
    KXBrowerToolViewWhiteStyle,     //默认是白色样式
    KXBrowerToolViewBlackStyle,     //黑色样式
} KXBrowerToolViewStyle;


@interface KXBrowerToolView : UIView

/**
 快速初始化方法，默认是 KXBrowerToolViewWhiteStyle
 */
+ (instancetype)toolView;


/**
 展示方式

 @param animated 是否需要动画
 */
- (void)showWithAnimated:(BOOL)animated;
- (void)hiddenWithAnimated:(BOOL)animated;



/**
 设置左右按钮的点击事件
 */
- (void)setLeftButtonWithTarget:(id)target action:(SEL)action;
- (void)setRightButtonWithTarget:(id)target action:(SEL)action;

/**
 设置右按钮的选中事件
 */
- (void)setRightButtonSelected:(BOOL)selected;

/**
 展示类型
 */
@property (nonatomic, assign) KXBrowerToolViewStyle style;


/**
 标记当前状态
 */
@property (nonatomic, assign,readonly,getter=isShow) BOOL show;


/**
 文本内容
 */
@property (nonatomic, weak) NSMutableAttributedString *attStr;
@property (nonatomic, copy) NSString *titleStr;

@end
