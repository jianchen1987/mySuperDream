//
//  TNNewIncomeIndexItemCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNNewIncomeIndexItemCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNTool.h"


@interface TNNewIncomeIndexItemCell ()
@property (nonatomic, strong) HDLabel *dateLabel;
@property (nonatomic, strong) HDLabel *timerLabel;
@property (nonatomic, strong) HDLabel *moneyLabel;
@property (nonatomic, strong) HDLabel *descLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) HDLabel *statusLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) UIBezierPath *maskPath;
@end


@implementation TNNewIncomeIndexItemCell
- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    newFrame.origin.x = kRealWidth(15);
    newFrame.size.width = frame.size.width - kRealWidth(30);
    [super setFrame:newFrame];
}
- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.timerLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.arrowImgView];

    @HDWeakify(self);
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        [self setRadius];
    };
}

- (void)updateConstraints {
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(15));
    }];

    NSArray *viewArray = @[self.timerLabel, self.moneyLabel, self.descLabel];
    [viewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:kRealWidth(5) leadSpacing:kRealWidth(15) tailSpacing:kRealWidth(15)];
    [viewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLabel.mas_bottom).offset(kRealWidth(15));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(kRealWidth(-15));
    }];

    [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowImgView.image.size);
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(15));
    }];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLabel.mas_top);
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(kRealWidth(-5));
        make.left.mas_equalTo(self.dateLabel.mas_right).offset(kRealWidth(5));
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(kRealWidth(-1));
        make.height.equalTo(@(0.5));
    }];

    [super updateConstraints];
}

- (void)setQueryMode:(NSInteger)queryMode {
    _queryMode = queryMode;
    if (queryMode == 1) {
        self.statusLabel.hidden = YES;
    } else if (queryMode == 2) {
        self.statusLabel.hidden = NO;
    }
}
- (void)setModel:(TNNewIncomeItemModel *)model {
    _model = model;
    self.dateLabel.text = model.date;
    self.timerLabel.text = model.time;
    self.descLabel.text = model.settleStatusStr;
    self.statusLabel.text = model.orderStatusStr;
    if (model.settleStatus == TNIncomeSettleStatusInvalid) {
        self.moneyLabel.text = model.amount.thousandSeparatorAmountNoCurrencySymbol;
        self.moneyLabel.textColor = HDAppTheme.TinhNowColor.cFF2323;
    } else if (model.settleStatus == TNIncomeSettleStatusSettled) {
        self.moneyLabel.text = [NSString stringWithFormat:@"+%@", model.amount.thousandSeparatorAmountNoCurrencySymbol];
        self.moneyLabel.textColor = HDAppTheme.TinhNowColor.c14B96D;
    } else if (model.settleStatus == TNIncomeSettleStatusPending) {
        self.moneyLabel.text = [NSString stringWithFormat:@"+%@", model.amount.thousandSeparatorAmountNoCurrencySymbol];
        self.moneyLabel.textColor = HDAppTheme.TinhNowColor.c14B96D;
    }
    [self setNeedsUpdateConstraints];
}

- (void)setIsLast:(BOOL)isLast {
    _isLast = isLast;
    if (isLast) {
        self.line.hidden = YES;
    } else {
        self.line.hidden = NO;
    }
}

- (void)setRadius {
    if (self.isLast) {
        CGRect rect = self.bounds;
        self.maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(kRealWidth(8), kRealWidth(8))];
        self.maskLayer.frame = rect;
        self.maskLayer.path = self.maskPath.CGPath;
        self.layer.mask = self.maskLayer;
    } else {
        [self.maskLayer removeFromSuperlayer];
    }
}

#pragma mark
- (HDLabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[HDLabel alloc] init];
        _dateLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _dateLabel.font = HDAppTheme.TinhNowFont.standard14M;
    }
    return _dateLabel;
}

- (HDLabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [[HDLabel alloc] init];
        _timerLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _timerLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _timerLabel;
}

- (HDLabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[HDLabel alloc] init];
        _moneyLabel.font = HDAppTheme.TinhNowFont.standard12;
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

- (HDLabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[HDLabel alloc] init];
        _descLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _descLabel.font = HDAppTheme.TinhNowFont.standard12;
        _descLabel.textAlignment = NSTextAlignmentRight;
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (HDLabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[HDLabel alloc] init];
        _statusLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _statusLabel.font = HDAppTheme.TinhNowFont.standard12;
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.hidden = YES;
    }
    return _statusLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.TinhNowColor.lineColor;
    }
    return _line;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"tn_arrow_backcolor"];
    }
    return _arrowImgView;
}

- (UIBezierPath *)maskPath {
    if (!_maskPath) {
        _maskPath = [[UIBezierPath alloc] init];
    }
    return _maskPath;
}

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
    }
    return _maskLayer;
}
@end
