//
//  WMFillGiftView.m
//  SuperApp
//
//  Created by wmz on 2021/7/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMFillGiftView.h"
#import <YYText/YYText.h>


@interface WMFillGiftView ()

/// 活动类型
@property (nonatomic, strong) HDLabel *activityType;
/// 活动name
@property (nonatomic, strong) HDLabel *activityName;
/// 活动内容
@property (nonatomic, strong) HDLabel *activityContent;
/// 失败原因
@property (nonatomic, strong) YYLabel *failReason;
/// 线
@property (nonatomic, strong) UIView *line;

@end


@implementation WMFillGiftView

- (void)hd_setupViews {
    [self addSubview:self.activityType];
    [self addSubview:self.activityName];
    [self addSubview:self.activityContent];
    [self addSubview:self.failReason];
    [self addSubview:self.line];
}

- (void)updateConstraints {
    [self.activityType mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kRealWidth(10));
    }];

    [self.activityName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(14));
        make.right.mas_equalTo(0);
        make.left.equalTo(self.activityType.mas_right).offset(kRealWidth(5));
    }];

    [self.activityContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityName.mas_left);
        make.top.equalTo(self.activityName.mas_bottom).offset(kRealWidth(10));
        make.right.mas_equalTo(0);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(HDAppTheme.value.pixelOne);
        make.top.equalTo(self.activityContent.mas_bottom).offset(kRealWidth(15));
    }];

    [self.failReason mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityType.mas_left);
        make.top.equalTo(self.line.mas_bottom).offset(kRealWidth(15));
        make.right.mas_equalTo(0);
    }];

    [self.activityType setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.activityType setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}

- (void)setModel:(WMOrderSubmitFullGiftRspModel *)model {
    _model = model;
    if ([model isKindOfClass:WMOrderSubmitFullGiftRspModel.class]) {
        self.activityType.text = WMLocalizedString(@"wm_fill_gift_name", @"满赠");
        self.activityName.text = model.activityTitle.desc;
        self.activityContent.text = model.fillName;

        NSString *writeStr = WMLocalizedString(@"wm_gift_write", @"立即填写");
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.checkActivityResultStr];
        text.yy_font = HDAppTheme.font.standard3;
        text.yy_color = [UIColor hd_colorWithHexString:@"#5D667F"];
        @HDWeakify(self);
        [text yy_setTextHighlightRange:[model.checkActivityResultStr rangeOfString:writeStr] color:[UIColor hd_colorWithHexString:@"#4A7AFF"] backgroundColor:[UIColor whiteColor]
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                                 @HDStrongify(self);
                                 if (self.clickedWriteBlock) {
                                     self.clickedWriteBlock();
                                 }
                             }];
        self.failReason.attributedText = text;
    }
}

- (void)layoutyImmediately {
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
    self.frame = CGRectMake(0, 0, kScreenWidth - kRealWidth(30), CGRectGetMaxY(self.failReason.frame) + kRealHeight(30));
}

- (HDLabel *)activityType {
    if (!_activityType) {
        _activityType = HDLabel.new;
        _activityType.textAlignment = NSTextAlignmentCenter;
        _activityType.layer.backgroundColor = [UIColor hd_colorWithHexString:@"#72ADFF"].CGColor;
        _activityType.layer.cornerRadius = kRealWidth(3);
        _activityType.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(3), kRealWidth(4), kRealWidth(3));
        _activityType.textColor = UIColor.whiteColor;
        _activityType.font = HDAppTheme.font.standard3;
    }
    return _activityType;
}

- (HDLabel *)activityName {
    if (!_activityName) {
        _activityName = HDLabel.new;
        _activityName.numberOfLines = 0;
        _activityName.textColor = [UIColor hd_colorWithHexString:@"#5D667F"];
        _activityName.font = HDAppTheme.font.standard2Bold;
    }
    return _activityName;
}

- (HDLabel *)activityContent {
    if (!_activityContent) {
        _activityContent = HDLabel.new;
        _activityContent.numberOfLines = 0;
        _activityContent.textColor = [UIColor hd_colorWithHexString:@"#5D667F"];
        _activityContent.font = HDAppTheme.font.standard3;
    }
    return _activityContent;
}
- (YYLabel *)failReason {
    if (!_failReason) {
        _failReason = YYLabel.new;
        _failReason.numberOfLines = 0;
        _failReason.preferredMaxLayoutWidth = self.hd_width; //设置最大的宽度
    }
    return _failReason;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.new;
        _line.backgroundColor = [UIColor hd_colorWithHexString:@"#F5F6FA"];
    }
    return _line;
}

@end
