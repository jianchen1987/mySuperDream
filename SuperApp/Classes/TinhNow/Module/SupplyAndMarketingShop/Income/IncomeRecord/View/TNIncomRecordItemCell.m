//
//  TNIncomRecordItemCell.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIncomRecordItemCell.h"
#import "HDAppTheme+TinhNow.h"
#import "NSString+extend.h"
#import "TNIncomeRecordListHeaderView.h"


@interface TNIncomRecordItemCommonHeaderCell ()
///
@property (strong, nonatomic) TNIncomeRecordListHeaderView *commonView;
@end


@implementation TNIncomRecordItemCommonHeaderCell
- (void)hd_setupViews {
    ;
    [self.contentView addSubview:self.commonView];
}
- (void)setQueryMode:(NSInteger)queryMode {
    _queryMode = queryMode;
    self.commonView.queryMode = queryMode;
}
- (void)updateConstraints {
    [self.commonView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(45);
    }];
    [super updateConstraints];
}
/** @lazy  commonView*/
- (TNIncomeRecordListHeaderView *)commonView {
    if (!_commonView) {
        _commonView = [[TNIncomeRecordListHeaderView alloc] init];
    }
    return _commonView;
}

@end


@interface TNIncomRecordItemCell ()
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


@implementation TNIncomRecordItemCell
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

- (void)setIsPreIncomeList:(BOOL)isPreIncomeList {
    _isPreIncomeList = isPreIncomeList;
    self.statusLabel.hidden = !isPreIncomeList;
}
- (void)setModel:(TNIncomeRecordItemModel *)model {
    _model = model;
    self.dateLabel.text = model.date;
    self.timerLabel.text = model.time;
    self.descLabel.text = model.remark;

    if (model.type == TNIncomeRecordItemTypeIncome) { //收益
        self.moneyLabel.textColor = HDAppTheme.TinhNowColor.c14B96D;
        self.moneyLabel.text = [NSString stringWithFormat:@"+%@", model.amountMoney.thousandSeparatorAmountNoCurrencySymbol];
    } else if (model.type == TNIncomeRecordItemTypeWithDrawReject) { //提现驳回
        self.moneyLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        self.moneyLabel.text = [NSString stringWithFormat:@"+%@", model.amountMoney.thousandSeparatorAmountNoCurrencySymbol];
    } else { //提现 和收益扣回
        self.moneyLabel.textColor = HDAppTheme.TinhNowColor.cFF2323;
        self.moneyLabel.text = model.amountMoney.thousandSeparatorAmountNoCurrencySymbol;
    }
    // 预估收益设置 颜色  字体
    if (model.status == TNPreIncomeRecordStatusGoing) {
        self.statusLabel.text = TNLocalizedString(@"iQW6cNX0", @"订单进行中");
        self.dateLabel.textColor = HDAppTheme.TinhNowColor.G1;
        self.timerLabel.textColor = HDAppTheme.TinhNowColor.G2;
        self.moneyLabel.textColor = HDAppTheme.TinhNowColor.c14B96D;
        self.statusLabel.textColor = HDAppTheme.TinhNowColor.c14B96D;
        self.descLabel.textColor = HDAppTheme.TinhNowColor.G2;
    } else if (model.status == TNPreIncomeRecordStatusCancel) {
        self.statusLabel.text = TNLocalizedString(@"tn_order_canced_desc", @"订单已取消");
        self.dateLabel.textColor = HDAppTheme.TinhNowColor.G3;
        self.timerLabel.textColor = HDAppTheme.TinhNowColor.G3;
        self.moneyLabel.textColor = HDAppTheme.TinhNowColor.G3;
        self.statusLabel.textColor = HDAppTheme.TinhNowColor.G3;
        self.descLabel.textColor = HDAppTheme.TinhNowColor.G3;
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


@implementation TNIncomeNoDataCell
- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    newFrame.origin.x = kRealWidth(15);
    newFrame.size.width = frame.size.width - kRealWidth(30);
    [super setFrame:newFrame];
}
- (void)hd_setupViews {
    [super hd_setupViews];
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:kRealWidth(8)];
    };
}

@end


@implementation TNIncomRecordItemSkeletonCell
- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    newFrame.origin.x = kRealWidth(15);
    newFrame.size.width = frame.size.width - kRealWidth(30);
    [super setFrame:newFrame];
}
- (void)hd_setupViews {
    [super hd_setupViews];
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:kRealWidth(8)];
    };
}
#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    //    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
    //    const CGFloat iconW = 20;
    //    circle.skeletonCornerRadius = 10;
    //    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
    //        make.width.hd_equalTo(iconW);
    //        make.height.hd_equalTo(iconW);
    //        make.top.hd_equalTo(12);
    //        make.left.hd_equalTo(12);
    //    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.top.hd_equalTo(15);
        make.left.hd_equalTo(15);
        make.height.hd_equalTo(20);
        make.width.hd_equalTo(150);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.top.hd_equalTo(15);
        make.right.hd_equalTo(self.hd_width).offset(-15);
        make.height.hd_equalTo(20);
        make.width.hd_equalTo(20);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.bottom.hd_equalTo(self.hd_height).offset(-15);
        make.left.hd_equalTo(15);
        make.height.hd_equalTo(15);
        make.width.hd_equalTo(100);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.bottom.hd_equalTo(self.hd_height).offset(-15);
        make.left.hd_equalTo((kScreenWidth - 30) / 2);
        make.height.hd_equalTo(20);
        make.width.hd_equalTo(50);
    }];

    HDSkeletonLayer *r5 = [[HDSkeletonLayer alloc] init];
    [r5 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.bottom.hd_equalTo(self.hd_height).offset(-15);
        make.right.hd_equalTo(self.hd_width).offset(-15);
        make.height.hd_equalTo(20);
        make.width.hd_equalTo(60);
    }];
    return @[r1, r2, r3, r4, r5];
}

- (UIColor *)skeletoncontentViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return 80;
}

@end
