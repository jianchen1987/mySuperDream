//
//  WMOrderRefundDetailProcessCell.m
//  SuperApp
//
//  Created by VanJay on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderRefundDetailProcessCell.h"
#import "SAGeneralUtil.h"


@interface WMOrderRefundDetailProcessCell ()
/// 点
@property (nonatomic, strong) UIImageView *dotIV;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 时间
@property (nonatomic, strong) SALabel *timeLB;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
@end


@implementation WMOrderRefundDetailProcessCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.descLB];
    [self.contentView addSubview:self.timeLB];
    [self.contentView addSubview:self.dotIV];

    [self.titleLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.timeLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - setter
- (void)setModel:(WMOrderDetailRefundEventModel *)model {
    _model = model;

    UIImage *dotImage = [UIImage hd_imageWithColor:HDAppTheme.color.G4 size:CGSizeMake(8, 8) cornerRadius:4];
    if (model.isFirstCell) {
        dotImage = [dotImage hd_imageWithTintColor:HDAppTheme.color.C1];
    }
    self.dotIV.image = dotImage;

    NSString *title = @"", *desc;
    switch (model.eventType) {
        case WMOrderEventTypeRefundApplying: {
            title = WMLocalizedString(@"request_refund", @"申请退款");
            if (HDIsStringNotEmpty(model.eventDesc)) {
                desc = [NSString stringWithFormat:@"%@:%@", WMLocalizedString(@"request_reason", @"原因"), model.eventDesc];
            }
        } break;

        case WMOrderEventTypeMerchantAcceptRefund: {
            title = WMLocalizedString(@"agree_refund", @"同意退款");
        } break;

        case WMOrderEventTypeMerchantRejectRefund: {
            title = WMLocalizedString(@"reject_refund", @"拒绝退款");
            if (HDIsStringNotEmpty(model.eventDesc)) {
                desc = [NSString stringWithFormat:@"%@:%@", WMLocalizedString(@"request_reason", @"原因"), model.eventDesc];
            }
        } break;

        case WMOrderEventTypeRefundSponsor: {
            title = WMLocalizedString(@"initiate_refund", @"发起退款");
            desc = WMLocalizedString(@"order_canceled_tips", @"订单已取消，系统自动发起退款");
        } break;

        case WMOrderEventTypeRefundSuccess: {
            title = WMLocalizedString(@"refunded_success", @"退款成功");
            desc = WMLocalizedString(@"refund_tips", @"具体到账时间以渠道处理情况为准，请注意查收");
        } break;

        case WMOrderEventTypeUploadingRefundTicket: {
            // 货到付款情况，订单已送达后，用户申请退款，申请退款被同意，财务上传完凭证
            title = WMLocalizedString(@"refunded_success", @"退款成功");
        } break;

        default:
            break;
    }

    self.titleLB.text = [NSString stringWithFormat:@"%@", title];
    self.timeLB.text = [SAGeneralUtil getDateStrWithTimeInterval:model.eventTime / 1000 format:@"dd/MM/yyyy HH:mm"];

    self.descLB.hidden = HDIsStringEmpty(desc);
    if (!self.descLB.isHidden) {
        self.descLB.text = desc;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods

#pragma mark - layout
- (void)updateConstraints {
    [self.dotIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(7), kRealWidth(7)));
        make.left.mas_equalTo(self.contentView).offset(kRealWidth(17));
        make.centerY.equalTo(self.titleLB);
    }];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dotIV.mas_right).offset(kRealWidth(8));
        make.right.lessThanOrEqualTo(self.timeLB.mas_left).offset(-kRealWidth(8));
        make.top.equalTo(self.contentView).offset(kRealWidth(10));
        if (self.descLB.isHidden) {
            make.bottom.equalTo(self.contentView).offset(-kRealWidth(10));
        }
    }];
    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        make.centerY.equalTo(self.titleLB);
    }];
    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.descLB.isHidden) {
            make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(3));
            make.left.equalTo(self.dotIV.mas_right).offset(kRealWidth(8));
            make.right.mas_equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
            make.bottom.equalTo(self.contentView).offset(-kRealWidth(10));
        }
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)timeLB {
    if (!_timeLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 1;
        _timeLB = label;
    }
    return _timeLB;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 0;
        _descLB = label;
    }
    return _descLB;
}

- (UIImageView *)dotIV {
    if (!_dotIV) {
        UIImageView *imageView = UIImageView.new;
        _dotIV = imageView;
    }
    return _dotIV;
}

@end
