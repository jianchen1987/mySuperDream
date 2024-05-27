//
//  PNUploadImageCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUploadImageCell.h"
#import "PNUploadInfoView.h"


@interface PNUploadImageCell ()
@property (nonatomic, strong) PNUploadInfoView *infoView;
@property (nonatomic, strong) SALabel *tipsLabel;
@property (nonatomic, strong) UIView *lineView;
@end


@implementation PNUploadImageCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.infoView];
    [self.contentView addSubview:self.tipsLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)updateConstraints {
    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];

    if (!self.tipsLabel.hidden) {
        [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(self.model.subTitleEdgeInsets.left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(self.model.subTitleEdgeInsets.right);
            make.top.mas_equalTo(self.infoView.mas_bottom).offset(self.model.subTitleEdgeInsets.top);
        }];
    }

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(self.model.lineEdgeInsets.left);
        make.right.mas_equalTo(self.contentView.mas_right).offset(self.model.lineEdgeInsets.right);
        if (!self.tipsLabel.hidden) {
            make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(self.model.lineEdgeInsets.top);
        } else {
            make.top.mas_equalTo(self.infoView.mas_bottom).offset(self.model.lineEdgeInsets.top);
        }
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(self.model.lineEdgeInsets.bottom + self.model.uploadImageViewLineWidth);
        make.height.equalTo(@(self.model.uploadImageViewLineWidth));
    }];

    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - getters and setters
- (void)setModel:(PNUploadImageViewModel *)model {
    _model = model;

    self.infoView.model = model;

    if (WJIsStringNotEmpty(model.subTitleText)) {
        self.tipsLabel.text = model.subTitleText;
        self.tipsLabel.hidden = NO;
    } else {
        self.tipsLabel.text = @"";
        self.tipsLabel.hidden = YES;
    }

    /// 不用显示里面的线条
    self.infoView.model.lineWidth = 0;
    self.lineView.backgroundColor = model.lineColor;

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (PNUploadInfoView *)infoView {
    return _infoView ?: ({ _infoView = PNUploadInfoView.new; });
}

- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15;
        label.numberOfLines = 0;
        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *view = [[UIView alloc] init];
        _lineView = view;
    }
    return _lineView;
}

@end
