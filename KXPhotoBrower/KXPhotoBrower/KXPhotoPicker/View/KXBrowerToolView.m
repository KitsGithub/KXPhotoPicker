//
//  KXBrowerToolView.m
//  KXPhotoBrower
//
//  Created by mac on 2017/8/3.
//  Copyright © 2017年 kit. All rights reserved.
//

#import "KXBrowerToolView.h"

@implementation KXBrowerToolView {
    UIView *_bgView;
    UILabel *_titleLabel;
    UIView *_lineView;
    
    //左右按钮
    UIButton *_leftButton;
    UIButton *_rightButton;
}

+ (instancetype)toolView {
    return [[self alloc] initWithFrame:CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, 64)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}


- (void)setupView {
    _show = NO;
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, KXBrowerToolHeight)];
    [self addSubview:_bgView];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, KXBrowerToolHeight - 20)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 20, 44, 44)];
    _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_leftButton setImage:[UIImage imageNamed:@"NewCircle_Nav_Back"] forState:UIControlStateNormal];
    
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 12 - 44, 20, 44, 44)];
    [_rightButton setImage:[UIImage imageNamed:@"photo_check_default"] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"photo_check_selected"] forState:UIControlStateSelected];
    [self setControlWithStyle:self.style];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, KXBrowerToolHeight - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_lineView];
}


- (void)setControlWithStyle:(KXBrowerToolViewStyle)style {
    switch (self.style) {
        case KXBrowerToolViewWhiteStyle:
            _bgView.backgroundColor = [UIColor whiteColor];
            _titleLabel.textColor = [UIColor blackColor];
            
            break;
        case KXBrowerToolViewBlackStyle:
            _bgView.backgroundColor = [UIColor blackColor];
            _titleLabel.textColor = [UIColor whiteColor];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 展示动画
- (void)showWithAnimated:(BOOL)animated {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.frame;
        rect.origin.y += 64;
        self.frame = rect;
    } completion:^(BOOL finished) {
        _show = YES;
    }];
}

- (void)hiddenWithAnimated:(BOOL)animated {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.frame;
        rect.origin.y -= 64;
        self.frame = rect;
    } completion:^(BOOL finished) {
        _show = NO;
    }];
}

#pragma mark - open Method
//设置文本内容
- (void)setTitleStr:(NSString *)titleStr {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    [self setAttStr:att];
}

- (void)setAttStr:(NSMutableAttributedString *)attStr {
    _titleLabel.attributedText = attStr;
}


/**
 设置左右按钮的点击事件
 */
- (void)setLeftButtonWithTarget:(id)target action:(SEL)action {
    [self addSubview:_leftButton];
    [_leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


- (void)setRightButtonWithTarget:(id)target action:(SEL)action {
    [self addSubview:_rightButton];
    [_rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


@end
