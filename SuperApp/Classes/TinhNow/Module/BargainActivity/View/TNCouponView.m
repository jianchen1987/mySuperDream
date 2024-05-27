//
//  TNCouponView.m
//  SuperApp
//
//  Created by xixi on 2021/3/30.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCouponView.h"
#import "HDAppTheme+TinhNow.h"
#import "NSString+extend.h"
#import "TNBargainDetailModel.h"


@interface TNCouponItemView ()
///
@property (nonatomic, strong) UIImageView *bgView;
///
@property (nonatomic, strong) UILabel *leftTitleLabel;
///
@property (nonatomic, strong) UILabel *rightLabel;

///
@property (nonatomic, strong) TNCouponModel *dataModel;
@end


@implementation TNCouponItemView

- (instancetype)initWithFrame:(CGRect)frame data:(id)dataModel {
    self = [super initWithFrame:frame];
    if (self) {
        _dataModel = dataModel;
        [self setData];
        [self hd_setupViews];
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.bgView];
    [self addSubview:self.leftTitleLabel];
    [self addSubview:self.rightLabel];

    [self layoutContainerViewSubViews];
}

- (void)layoutContainerViewSubViews {
    self.bgView.frame = CGRectMake(0, 0, self.hd_width, self.hd_height);
    CGFloat leftWidth = self.hd_width * 100.f / 248.f;
    self.leftTitleLabel.frame = CGRectMake(0, 0, leftWidth, self.hd_height);
    self.rightLabel.frame = CGRectMake(self.leftTitleLabel.hd_right, 0, self.hd_width - self.leftTitleLabel.hd_width, self.hd_height);
}

- (void)setData {
    NSString *lightStr = _dataModel.couponMoney.thousandSeparatorAmount;
    NSString *longStr = [NSString stringWithFormat:@"%@ %@", lightStr, TNLocalizedString(@"tn_coupon_item_rightTitle", @"优惠券")];
    NSMutableAttributedString *att = [NSString highLightString:lightStr inLongString:longStr font:[HDAppTheme.TinhNowFont fontSemibold:20.f] color:HexColor(0xFFEA93)];
    NSRange range = [longStr rangeOfString:lightStr];
    if (range.location != NSNotFound) {
        [att addAttributes:@{NSBaselineOffsetAttributeName: @(-3)} range:NSMakeRange(range.location, lightStr.length)];
    }

    self.rightLabel.attributedText = att;
}

#pragma mark -
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = [UIImage imageNamed:@"tn_coupon_bg"];
    }
    return _bgView;
}

- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc] init];
        _leftTitleLabel.textColor = [UIColor whiteColor];
        _leftTitleLabel.font = [HDAppTheme.TinhNowFont fontMedium:16.f];
        _leftTitleLabel.minimumScaleFactor = 0.5;
        _leftTitleLabel.numberOfLines = 1;
        _leftTitleLabel.adjustsFontSizeToFitWidth = YES;
        _leftTitleLabel.textAlignment = NSTextAlignmentCenter;
        _leftTitleLabel.text = TNLocalizedString(@"tn_coupon_item_leftTitle", @"送你一张");
    }
    return _leftTitleLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = HexColor(0xFFEA93);
        _rightLabel.font = [HDAppTheme.TinhNowFont fontMedium:12.f];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.text = TNLocalizedString(@"tn_coupon_item_rightTitle", @"优惠券");
    }
    return _rightLabel;
}

@end


@implementation TNCouponView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.maxY = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.maxY = 0;
    [self createView];
}

- (void)setCouponArray:(NSArray *)couponArray {
    _couponArray = couponArray;
}

- (void)createView {
    [self hd_removeAllSubviews];

    for (int i = 0; i < self.couponArray.count; i++) {
        if (i > 1) {
            break;
        }

        TNCouponModel *itemModel = [self.couponArray objectAtIndex:i];
        // 248:49
        CGFloat height = self.hd_width * 49.f / 248.f;
        TNCouponItemView *itemView = [[TNCouponItemView alloc] initWithFrame:CGRectMake(0, self.maxY, self.hd_width, height) data:itemModel];
        [self addSubview:itemView];

        self.maxY = itemView.hd_bottom + kRealWidth(10.f);
    }

    if (self.maxY > 0) {
        self.maxY -= kRealWidth(10.f);
    }

    //超过2张优惠券，则“…”显示
    if (self.couponArray.count > 2) {
        [self createMoreView];
    }
    self.hd_height = self.maxY;
}

- (void)createMoreView {
    UIView *tempView = [[UIView alloc] init];
    [self addSubview:tempView];
    CGFloat beginX = 0;
    for (int i = 0; i < 3; i++) {
        UIView *pointView = [[UIView alloc] init];
        pointView.size = CGSizeMake(kRealWidth(4.f), kRealWidth(4.f));
        pointView.hd_left = beginX;
        pointView.hd_top = 0;
        pointView.layer.cornerRadius = 2.f;
        pointView.backgroundColor = HexColor(0x454545);
        [tempView addSubview:pointView];

        beginX = pointView.hd_right + kRealWidth(5.f);

        tempView.hd_width = pointView.hd_right;
        tempView.hd_height = kRealWidth(4.f);
    }

    tempView.hd_top = self.maxY + kRealWidth(10.f);
    tempView.hd_left = (self.hd_width - tempView.hd_width) / 2.f;

    self.maxY = tempView.bottom;
}

@end
