//
//  TNExpressTrackingStatusCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNExpressTrackingStatusCell.h"
#import "HDAppTheme+TinhNow.h"


@implementation TNExpressTrackingStatusCellModel

@end


@interface TNExpressTrackingStatusCell ()
/// 圆角背景
@property (strong, nonatomic) UIView *bgView;
/// 车子图标
@property (strong, nonatomic) UIImageView *carIV;
/// 文本
@property (strong, nonatomic) HDLabel *contentLB;
/// 右箭头
@property (strong, nonatomic) UIImageView *arrowIV;
@end


@implementation TNExpressTrackingStatusCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.carIV];
    [self.bgView addSubview:self.contentLB];
    [self.bgView addSubview:self.arrowIV];
}
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
    }];
    [self.carIV sizeToFit];
    [self.carIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(10));
    }];
    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.carIV.mas_right).offset(kRealWidth(5));
        make.top.equalTo(self.bgView.mas_top).offset(kRealWidth(5));
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-kRealWidth(5));
        make.right.lessThanOrEqualTo(self.arrowIV.mas_left).offset(-kRealWidth(10));
    }];
    [self.arrowIV sizeToFit];
    [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(10));
    }];
    [super updateConstraints];
}
- (void)setModel:(TNExpressTrackingStatusCellModel *)model {
    _model = model;
    self.contentLB.text = model.contentText;
    self.arrowIV.hidden = model.isNeedHiddenArrowIV;
}
/** @lazy bgView */
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HexColor(0xFFF3E8);
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _bgView;
}
/** @lazy carIV */
- (UIImageView *)carIV {
    if (!_carIV) {
        _carIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_express_car"]];
    }
    return _carIV;
}
/** @lazy contentLB */
- (HDLabel *)contentLB {
    if (!_contentLB) {
        _contentLB = [[HDLabel alloc] init];
        _contentLB.font = HDAppTheme.TinhNowFont.standard12;
        _contentLB.textColor = HexColor(0x775005);
        _contentLB.numberOfLines = 0;
    }
    return _contentLB;
}
/** @lazy arrowIV */
- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        _arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_arrow_brown"]];
    }
    return _arrowIV;
}
@end
