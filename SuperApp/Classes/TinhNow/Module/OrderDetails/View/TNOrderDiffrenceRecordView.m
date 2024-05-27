//
//  TNOrderDiffrenceRecordView.m
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderDiffrenceRecordView.h"
#import "NSDate+SAExtension.h"


@interface TNOrderDiffrenceRecordView ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *differenceKeyLabel;
@property (strong, nonatomic) UILabel *differenceValueLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *reasonKeyLabel;
@property (strong, nonatomic) UILabel *reasonValueLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) HDUIButton *closeBtn;
@end


@implementation TNOrderDiffrenceRecordView

- (void)hd_setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeBtn];
    [self addSubview:self.differenceKeyLabel];
    [self addSubview:self.differenceValueLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.reasonKeyLabel];
    [self addSubview:self.reasonValueLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.closeBtn];

    _titleLabel.text = TNLocalizedString(@"tn_difference_amount_record", @"补/退差价记录");
    _differenceKeyLabel.text = TNLocalizedString(@"tn_difference_amount", @"补/退差价");
    _reasonKeyLabel.text = TNLocalizedString(@"tn_reason", @"原因");
}
- (void)setModel:(TNOrderDetailsBizPartModel *)model {
    _model = model;
    _differenceValueLabel.text = model.differencePrice.thousandSeparatorAmount;
    if (model.differencePrice.cent.doubleValue > 0) {
        _differenceKeyLabel.text = TNLocalizedString(@"tn_add_difference", @"补差价");
    } else {
        _differenceKeyLabel.text = TNLocalizedString(@"tn_refund_difference", @"退差价");
    }
    _timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.differencePriceModifyTime / 1000] stringWithFormatStr:@"dd/MM/yyyy HH:mm"];
    _reasonValueLabel.text = model.differencePriceRemark;
}
- (void)layoutyImmediately {
    [self setNeedsLayout];
    [self layoutIfNeeded];

    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.frame = (CGRect){0, 0, CGRectGetWidth(self.frame), size.height};
}
- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(kRealWidth(15));
        //        make.left.greaterThanOrEqualTo(self).offset(kRealWidth(15)).priorityLow();
    }];
    [self.closeBtn sizeToFit];
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kRealWidth(15));
        make.right.equalTo(self.mas_right);
    }];
    [self.differenceKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(23));
    }];
    //抗拉伸设置
    [self.differenceKeyLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.differenceKeyLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.differenceValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.differenceKeyLabel);
        make.left.equalTo(self.differenceKeyLabel.mas_right).offset(kRealWidth(20));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.right.equalTo(self);
        make.top.equalTo(self.differenceValueLabel.mas_bottom).offset(kRealWidth(5));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(kRealWidth(10));
        make.height.mas_equalTo(kRealWidth(0.5));
    }];
    [self.reasonKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(10));
    }];
    [self.reasonValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.reasonKeyLabel.mas_right).offset(kRealWidth(20));
        make.bottom.equalTo(self).offset(-kRealWidth(50));
    }];
    [self.reasonKeyLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.reasonKeyLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}
- (void)clickedCloseBtnHandler {
    if (self.closeClickedCallBack) {
        self.closeClickedCallBack();
    }
}
- (UILabel *)createLabelWithFont:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.numberOfLines = 0;
    return label;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [self createLabelWithFont:HDAppTheme.TinhNowFont.standard17B color:HDAppTheme.TinhNowColor.G1];
    }
    return _titleLabel;
}
- (HDUIButton *)closeBtn {
    if (!_closeBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [button addTarget:self action:@selector(clickedCloseBtnHandler) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = button;
    }
    return _closeBtn;
}
- (UILabel *)differenceKeyLabel {
    if (!_differenceKeyLabel) {
        _differenceKeyLabel = [self createLabelWithFont:HDAppTheme.TinhNowFont.standard15 color:HDAppTheme.TinhNowColor.G1];
    }
    return _differenceKeyLabel;
}
- (UILabel *)differenceValueLabel {
    if (!_differenceValueLabel) {
        _differenceValueLabel = [self createLabelWithFont:HDAppTheme.TinhNowFont.standard15B color:HDAppTheme.TinhNowColor.C3];
        _differenceValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _differenceValueLabel;
}
- (UILabel *)reasonKeyLabel {
    if (!_reasonKeyLabel) {
        _reasonKeyLabel = [self createLabelWithFont:HDAppTheme.TinhNowFont.standard15 color:HDAppTheme.TinhNowColor.G1];
    }
    return _reasonKeyLabel;
}

- (UILabel *)reasonValueLabel {
    if (!_reasonValueLabel) {
        _reasonValueLabel = [self createLabelWithFont:HDAppTheme.TinhNowFont.standard15 color:HDAppTheme.TinhNowColor.G1];
        _reasonValueLabel.textAlignment = NSTextAlignmentRight;
        _reasonKeyLabel.numberOfLines = 0;
    }
    return _reasonValueLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [self createLabelWithFont:HDAppTheme.TinhNowFont.standard12 color:HDAppTheme.TinhNowColor.G3];
    }
    return _timeLabel;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.lineColor;
    }
    return _lineView;
}
@end
