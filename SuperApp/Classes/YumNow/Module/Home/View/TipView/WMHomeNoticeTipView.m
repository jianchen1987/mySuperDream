//
//  WMHomeNoticeTipView.m
//  SuperApp
//
//  Created by wmz on 2022/4/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMHomeNoticeTipView.h"


@implementation WMHomeNoticeTipView

- (void)setModel:(WMHomeNoticeModel *)model {
    _model = model;
//    self.titleLB.text
//        = model.daily ? [NSString stringWithFormat:@"%@\n%@", model.content, [SAGeneralUtil getDateStrWithTimeInterval:model.showTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"]] : model.content;

    self.titleLB.text
        = model.daily ? [NSString stringWithFormat:@"%@\n%@", model.content, [SAGeneralUtil getDateStrWithTimeInterval:model.showTime format:@"dd/MM/yyyy HH:mm:ss"]] : model.content;

    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:self.titleLB.text];
    mstr.yy_lineSpacing = kRealWidth(4);
    self.titleLB.attributedText = mstr;

    if ([model.homeNoticeType isEqualToString:WMHomeNoticeTypePromo]) {
        self.iconIV.image = [UIImage imageNamed:@"yn_home_no"];
    } else if ([model.homeNoticeType isEqualToString:WMHomeNoticeTypeDelivery]) {
        self.iconIV.image = [UIImage imageNamed:@"yn_home_no_de"];
    }
}

- (void)show {
    [self layoutIfNeeded];
    CGRect rect = self.frame;
    CGRect originalRect = rect;
    rect.origin.y = -rect.size.height;
    self.frame = rect;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = originalRect;
    } completion:^(BOOL finished){
    }];
    self.show = YES;
}

- (void)dissmiss {
    CGRect rect = self.frame;
    rect.origin.y = -rect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    self.show = NO;
}

- (void)hd_setupViews {
    [self addSubview:self.iconIV];
    [self addSubview:self.titleLB];
    self.iconIV.image = [UIImage imageNamed:@"yn_home_no"];
    self.titleLB.textColor = HDAppTheme.WMColor.B3;
    self.titleLB.font = [HDAppTheme.WMFont wm_ForSize:14];
    self.titleLB.text = @"";
    [self hd_changeUI];
    UISwipeGestureRecognizer *panGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:panGestureUp];
}

- (void)hd_changeUI{
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(42), kRealWidth(42)));
        make.left.top.mas_equalTo(kRealWidth(10));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(10));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(10));
        make.right.mas_equalTo(-kRealWidth(17));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(10));
        make.top.equalTo(self.iconIV.mas_top).offset(kRealWidth(2));
    }];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)guesture {
    ///触发手动
    self.model.handClose = YES;
    if (self.eventHandClose) {
        self.eventHandClose(YES);
    }
    [self dissmiss];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0].CGColor;
    self.layer.cornerRadius = kRealWidth(10);
    self.layer.shadowColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.24].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = kRealWidth(8);
}

@end
