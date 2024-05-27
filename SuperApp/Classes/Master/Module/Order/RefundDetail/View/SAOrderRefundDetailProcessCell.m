//
//  SAOrderRefundDetailProcessCell.m
//  SuperApp
//
//  Created by Chaos on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAOrderRefundDetailProcessCell.h"
#import "SAGeneralUtil.h"
#import "SAOrderDetailRefundEventModel.h"


@interface SAOrderRefundDetailProcessCell ()
/// 点
@property (nonatomic, strong) UIImageView *dotIV;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 时间
@property (nonatomic, strong) SALabel *timeLB;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
/// 线
@property (nonatomic, strong) UIView *bottomLine;

@end


@implementation SAOrderRefundDetailProcessCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.descLB];
    [self.contentView addSubview:self.timeLB];
    [self.contentView addSubview:self.dotIV];
    [self.contentView addSubview:self.bottomLine];

    [self.titleLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.timeLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - setter
- (void)setModel:(SAOrderDetailRefundEventModel *)model {
    _model = model;

    UIImage *dotImage = [UIImage hd_imageWithColor:HDAppTheme.color.G4 size:CGSizeMake(8, 8) cornerRadius:4];
    if (model.isFirstCell) {
        dotImage = [dotImage hd_imageWithTintColor:HDAppTheme.color.C1];
    }
    self.dotIV.image = dotImage;

    NSString *title = @"", *desc;
    switch (model.eventType) {
        case SAOrderEventTypeRefundApplying: {
            title = SALocalizedString(@"request_refund", @"申请退款");
            desc = [NSString stringWithFormat:@"%@:%@", SALocalizedString(@"request_reason", @"原因"), model.eventDesc ?: @""];
        } break;

        case SAOrderEventTypeMerchantAcceptRefund: {
            title = SALocalizedString(@"agree_refund", @"同意退款");
        } break;

            //        case SAOrderEventTypeMerchantRejectRefund: {
            //            title = SALocalizedString(@"reject_refund", @"拒绝退款");
            //            desc = [NSString stringWithFormat:@"%@:%@", SALocalizedString(@"request_reason", @"原因"), model.eventDesc];
            //        } break;

            //        case SAOrderEventTypeRefundSponsor: {
            //            title = SALocalizedString(@"initiate_refund", @"发起退款");
            //            desc = SALocalizedString(@"order_canceled_tips", @"订单已取消，系统自动发起退款");
            //        } break;

        case SAOrderEventTypeRefundSuccess: {
            title = SALocalizedString(@"refunded_success", @"退款成功");
            desc = SALocalizedString(@"refund_tips", @"具体到账时间以渠道处理情况为准，请注意查收");
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

    self.bottomLine.hidden = !self.model.isLastCell;

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
        make.right.equalTo(self.timeLB.mas_left).offset(-kRealWidth(8));
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
            make.bottom.equalTo(self.contentView).offset(-kRealWidth(20));
        }
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
        make.height.mas_equalTo(PixelOne);
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

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}

@end
