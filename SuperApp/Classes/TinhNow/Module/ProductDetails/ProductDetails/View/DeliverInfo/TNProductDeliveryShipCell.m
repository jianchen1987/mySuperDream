//
//  TNProductDeliveryShipCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductDeliveryShipCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNProductDeliveryShipAlertView.h"
#import "TNView.h"


@interface TNDeliveryShipItemView : TNView
/// 左边文案
@property (strong, nonatomic) HDLabel *leftLB;
/// 右边文案
@property (strong, nonatomic) HDLabel *rightLB;
/// 查看运费  根据是否返回更多数据展示
@property (strong, nonatomic) HDUIButton *shipDetailBtn;
/// 数据源
@property (strong, nonatomic) TNDeliverAreaModel *model;
@end


@implementation TNDeliveryShipItemView
- (void)hd_setupViews {
    [self addSubview:self.leftLB];
    [self addSubview:self.rightLB];
    [self addSubview:self.shipDetailBtn];
}
- (void)setModel:(TNDeliverAreaModel *)model {
    _model = model;
    self.leftLB.text = model.areaDeclare;
    if (!HDIsArrayEmpty(model.freightTemplate)) {
        self.shipDetailBtn.hidden = NO;
        self.rightLB.hidden = YES;
    } else {
        self.shipDetailBtn.hidden = YES;
        self.rightLB.hidden = NO;
        self.rightLB.text = model.freightPriceMoney.thousandSeparatorAmount;
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.leftLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.mas_top).offset(kRealWidth(5));
        make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(5));
        if (!self.rightLB.isHidden) {
            make.right.lessThanOrEqualTo(self.rightLB.mas_left).offset(-kRealWidth(10));
        }
        if (!self.shipDetailBtn.isHidden) {
            make.right.lessThanOrEqualTo(self.shipDetailBtn.mas_left).offset(-kRealWidth(10));
        }
    }];
    if (!self.rightLB.isHidden) {
        [self.rightLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.leftLB.mas_centerY);
            make.right.equalTo(self);
        }];
    }
    if (!self.shipDetailBtn.isHidden) {
        [self.shipDetailBtn sizeToFit];
        [self.shipDetailBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.leftLB.mas_centerY);
            make.right.equalTo(self);
        }];
    }
    [super updateConstraints];
}
/** @lazy leftLB */
- (HDLabel *)leftLB {
    if (!_leftLB) {
        _leftLB = [[HDLabel alloc] init];
        _leftLB.font = HDAppTheme.TinhNowFont.standard12;
        _leftLB.textColor = HDAppTheme.TinhNowColor.G2;
        _leftLB.numberOfLines = 0;
    }
    return _leftLB;
}
/** @lazy rightLB */
- (HDLabel *)rightLB {
    if (!_rightLB) {
        _rightLB = [[HDLabel alloc] init];
        _rightLB.font = HDAppTheme.TinhNowFont.standard12;
        _rightLB.textColor = HDAppTheme.TinhNowColor.G2;
    }
    return _rightLB;
}
/** @lazy shipDetailBtn */
- (HDUIButton *)shipDetailBtn {
    if (!_shipDetailBtn) {
        _shipDetailBtn = [[HDUIButton alloc] init];
        _shipDetailBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [_shipDetailBtn setTitle:TNLocalizedString(@"i2yuYspd", @"查看运费") forState:UIControlStateNormal];
        [_shipDetailBtn setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateNormal];
        @HDWeakify(self);
        [_shipDetailBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            TNProductDeliveryShipAlertView *alertView = [[TNProductDeliveryShipAlertView alloc] initWithAnimationStyle:HDActionAlertViewTransitionStyleBounce];
            alertView.dataArr = self.model.freightTemplate;
            [alertView show];
        }];
    }
    return _shipDetailBtn;
}
@end


@interface TNProductDeliveryShipCell ()
/// 标题
@property (strong, nonatomic) HDLabel *titleLB;
/// 内容视图
@property (strong, nonatomic) UIView *bgView;
@end


@implementation TNProductDeliveryShipCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.bgView];
}
- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
    }];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(5));
    }];
    [super updateConstraints];
}
- (void)setInfoModel:(TNDeliverInfoModel *)infoModel {
    _infoModel = infoModel;
    if (!HDIsArrayEmpty(infoModel.areaFreightDeclar)) {
        [self.bgView hd_removeAllSubviews];
        UIView *lastView = nil;
        NSInteger index = 0;
        for (TNDeliverAreaModel *model in infoModel.areaFreightDeclar) {
            TNDeliveryShipItemView *itemView = [[TNDeliveryShipItemView alloc] init];
            itemView.model = model;
            [self.bgView addSubview:itemView];
            [itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(lastView ? lastView.mas_bottom : self.bgView.mas_top);
                if (index == infoModel.areaFreightDeclar.count - 1) {
                    make.bottom.equalTo(self.bgView);
                }
            }];
            lastView = itemView;
            index += 1;
        }
        [self setNeedsUpdateConstraints];
    }
}
/** @lazy titleLB */
- (HDLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[HDLabel alloc] init];
        _titleLB.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _titleLB.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLB.text = TNLocalizedString(@"tn_delivery_fee", @"运费");
    }
    return _titleLB;
}
/** @lazy bgView */
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}
@end
