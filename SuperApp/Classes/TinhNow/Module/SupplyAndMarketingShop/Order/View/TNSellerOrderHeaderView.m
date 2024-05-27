//
//  TNSellerOrderHeaderView.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerOrderHeaderView.h"
#import "HDAppTheme+TinhNow.h"
#import "TNMultiLanguageManager.h"
#import "TNSellerOrderModel.h"
#import <HDUIKit/HDUIKit.h>
#import <Masonry.h>


@interface TNSellerOrderHeaderView ()
@property (strong, nonatomic) HDUIButton *orderNoBtn;  ///<订单号
@property (strong, nonatomic) UILabel *orderTimeLabel; ///<下单时间
@property (strong, nonatomic) UILabel *statusLabel;    ///< 状态
@end


@implementation TNSellerOrderHeaderView
- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.orderNoBtn];
    [self.contentView addSubview:self.orderTimeLabel];
    [self.contentView addSubview:self.statusLabel];
}
- (void)setModel:(TNSellerOrderModel *)model {
    _model = model;
    NSString *orderNoTitle = [NSString stringWithFormat:@"%@:%@", TNLocalizedString(@"siCRSOZm", @"订单号"), model.unifiedOrderNo];
    [self.orderNoBtn setTitle:orderNoTitle forState:UIControlStateNormal];
    self.orderTimeLabel.text = [NSString stringWithFormat:@"%@:%@", TNLocalizedString(@"mketnX7J", @"下单"), model.createdDate];
    if (model.status == TNSellerOrderStatusPaid) {
        self.statusLabel.text = TNLocalizedString(@"E1I6ZUG5", @"已付款");
        self.statusLabel.textColor = HDAppTheme.TinhNowColor.C1;
    } else if (model.status == TNSellerOrderStatusFinish) {
        self.statusLabel.text = TNLocalizedString(@"pkjnFFIN", @"已结算");
        self.statusLabel.textColor = HexColor(0x14B96D);
    } else if (model.status == TNSellerOrderStatusExpired) {
        self.statusLabel.text = TNLocalizedString(@"hTFG1UDO", @"已失效");
        self.statusLabel.textColor = HexColor(0xADB6C8);
    } else if (model.status == TNSellerOrderStatusPendingPayment) {
        self.statusLabel.text = TNLocalizedString(@"tn_pending_payment", @"待付款");
        self.statusLabel.textColor = HDAppTheme.TinhNowColor.C1;
    }
}
- (void)updateConstraints {
    [self.orderNoBtn sizeToFit];
    [self.orderNoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.right.lessThanOrEqualTo(self.statusLabel.mas_right).offset(-kRealWidth(10));
    }];
    [self.orderTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.orderNoBtn.mas_bottom).offset(kRealWidth(5));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(5));
    }];
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.centerY.equalTo(self.orderNoBtn.mas_centerY);
    }];
    [super updateConstraints];
}
/** @lazy orderNoBtn */
- (HDUIButton *)orderNoBtn {
    if (!_orderNoBtn) {
        _orderNoBtn = [[HDUIButton alloc] init];
        _orderNoBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [_orderNoBtn setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
        _orderNoBtn.imagePosition = HDUIButtonImagePositionRight;
        _orderNoBtn.spacingBetweenImageAndTitle = 5;
        [_orderNoBtn setImage:[UIImage imageNamed:@"tn_orderNo_copy"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_orderNoBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (HDIsStringNotEmpty(self.model.unifiedOrderNo)) {
                [UIPasteboard generalPasteboard].string = self.model.unifiedOrderNo;
                [HDTips showWithText:TNLocalizedString(@"tn_copy_success", @"复制成功")];
            }
        }];
    }
    return _orderNoBtn;
}
/** @lazy orderTimeLabel */
- (UILabel *)orderTimeLabel {
    if (!_orderTimeLabel) {
        _orderTimeLabel = [[UILabel alloc] init];
        _orderTimeLabel.font = HDAppTheme.TinhNowFont.standard12;
        _orderTimeLabel.textColor = HDAppTheme.TinhNowColor.G2;
    }
    return _orderTimeLabel;
}
/** @lazy statusLabel */
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = HDAppTheme.TinhNowFont.standard12;
        _statusLabel.textColor = HDAppTheme.TinhNowColor.C1;
    }
    return _statusLabel;
}
@end
