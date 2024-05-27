//
//  PNStepItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/1/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNStepItemView.h"


@interface PNStepItemView ()
@property (nonatomic, strong) SALabel *numberLabel;
@property (nonatomic, strong) SALabel *tipsLabel;
@end


@implementation PNStepItemView

- (void)hd_setupViews {
    [self addSubview:self.numberLabel];
    [self addSubview:self.tipsLabel];
}

- (void)updateConstraints {
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(22), kRealWidth(22)));
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.numberLabel.mas_bottom).offset(kRealWidth(5));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [super updateConstraints];
}

- (void)setModel:(PNStepItemModel *)model {
    _model = model;
    self.numberLabel.text = model.numStr;
    self.tipsLabel.text = model.tipsStr;
    if (model.isHighlight) {
        self.numberLabel.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        self.numberLabel.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
        self.tipsLabel.textColor = HDAppTheme.PayNowColor.cFD7127;
    } else {
        self.numberLabel.textColor = HDAppTheme.PayNowColor.c9599A2;
        self.numberLabel.backgroundColor = HDAppTheme.PayNowColor.cECECEC;
        self.tipsLabel.textColor = HDAppTheme.PayNowColor.cC6C8CC;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[SALabel alloc] init];
        _numberLabel.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        _numberLabel.font = HDAppTheme.PayNowFont.standard14;
        _numberLabel.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(11)];
        };
    }
    return _numberLabel;
}

- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[SALabel alloc] init];
        _tipsLabel.textColor = HDAppTheme.PayNowColor.cFD7127;
        _tipsLabel.font = HDAppTheme.PayNowFont.standard12;
        _tipsLabel.adjustsFontSizeToFitWidth = YES;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

@end


@implementation PNStepItemModel

@end
