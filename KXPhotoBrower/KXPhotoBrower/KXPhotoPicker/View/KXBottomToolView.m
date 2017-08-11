//
//  KXBottomToolView.m
//  KXPhotoBrower
//
//  Created by mac on 2017/8/11.
//  Copyright © 2017年 kit. All rights reserved.
//

#import "KXBottomToolView.h"
#import "DNSendButton.h"
#import "UIColor+My.h"

@implementation KXBottomToolView {
    UIView *_topLineView;
    
    DNSendButton *_sendButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}


- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    _topLineView = [UIView new];
    _topLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_topLineView];
    
    _sendButton = [DNSendButton new];
    [self addSubview:_sendButton];
}


#pragma mark - open Method
- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    
    _sendButton.badgeValue = badgeValue;
}

- (void)setSendButtonWithTarget:(id)target action:(SEL)action {
    [_sendButton addTaget:target action:action];
}

- (void)show {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect myRect = self.frame;
        myRect.origin.y -= myRect.size.height;
        self.frame = myRect;
    }];
}

- (void)hidden {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect myRect = self.frame;
        myRect.origin.y += myRect.size.height;
        self.frame = myRect;
    }];
}


- (void)layoutSubviews {
    _topLineView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5);
    
    _sendButton.frame = CGRectMake(CGRectGetWidth(self.frame) - 58 - 10, (CGRectGetHeight(self.frame) - 26) * 0.5, 58, 26);
}

@end
