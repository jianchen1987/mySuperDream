//
//  TNExpressRiderCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNExpressRiderCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SAOperationButton.h"


@interface TNExpressRiderCell ()
/// 订单状态
@property (strong, nonatomic) HDLabel *orderStatusLabel;
/// 骑手名称
@property (strong, nonatomic) HDUIButton *riderBtn;
/// 拨打电话
@property (strong, nonatomic) SAOperationButton *callBtn;
@end


@implementation TNExpressRiderCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.orderStatusLabel];
    [self.contentView addSubview:self.riderBtn];
    [self.contentView addSubview:self.callBtn];
}
- (void)updateConstraints {
    [self.orderStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
    }];

    [self.riderBtn sizeToFit];
    [self.riderBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.orderStatusLabel.mas_bottom).offset(kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        make.right.lessThanOrEqualTo(self.callBtn.mas_left).offset(-kRealWidth(15));
    }];

    [self.callBtn sizeToFit];
    [self.callBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.riderBtn.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
- (void)setRiderModel:(TNExpressRiderModel *)riderModel {
    _riderModel = riderModel;
    [self.riderBtn setTitle:riderModel.riderName forState:UIControlStateNormal];
    self.orderStatusLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"3wF1oRPi", @"订单商品状态"), riderModel.deliveryStatusMsg];
}
- (void)setTrackingNo:(NSString *)trackingNo {
    _trackingNo = trackingNo;
}
/** @lazy orderStatusLabel */
- (HDLabel *)orderStatusLabel {
    if (!_orderStatusLabel) {
        _orderStatusLabel = [[HDLabel alloc] init];
        _orderStatusLabel.font = [HDAppTheme.TinhNowFont fontSemibold:14];
        _orderStatusLabel.textColor = HDAppTheme.TinhNowColor.G1;
    }
    return _orderStatusLabel;
}
/** @lazy riderBtn */
- (HDUIButton *)riderBtn {
    if (!_riderBtn) {
        _riderBtn = [[HDUIButton alloc] init];
        [_riderBtn setImage:[UIImage imageNamed:@"tn_waimaiqis"] forState:UIControlStateNormal];
        _riderBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        [_riderBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        _riderBtn.spacingBetweenImageAndTitle = 5;
        _riderBtn.userInteractionEnabled = NO;
    }
    return _riderBtn;
}
/** @lazy confirm */
- (SAOperationButton *)callBtn {
    if (!_callBtn) {
        _callBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_callBtn applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        _callBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [_callBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_callBtn setTitle:TNLocalizedString(@"tn_call_rider", @"联系骑手") forState:UIControlStateNormal];
        [_callBtn setTitleEdgeInsets:UIEdgeInsetsMake(4, 16, 4, 16)];
        @HDWeakify(self);
        [_callBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            //            [HDSystemCapabilityUtil makePhoneCall:self.riderModel.riderPhone];
            NSDictionary *dict = @{
                @"operatorType": @(9),
                @"operatorNo": self.riderModel.riderOperatorNo ?: @"",
                @"prepareSendTxt": [TNLocalizedString(@"RQhkSnX7", @"我想咨询运单号：") stringByAppendingString:HDIsStringNotEmpty(self.trackingNo) ? self.trackingNo : @""],
                @"phoneNo": self.riderModel.riderPhone ?: @"",
                @"scene": SAChatSceneTypeYumNowDelivery
            };
            [[HDMediator sharedInstance] navigaveToIMViewController:dict];
        }];
    }
    return _callBtn;
}
@end
