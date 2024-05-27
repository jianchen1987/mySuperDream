//
//  TNOrderDetailExpressCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/8/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNOrderDetailExpressCell.h"
#import "HDAppTheme+TinhNow.h"
#import "HDSystemCapabilityUtil.h"
#import "SAInfoView.h"

@interface TNOrderDetailExpressCell ()
///运单号背景
@property (strong, nonatomic) UIControl *expressBgControl;
///
@property (strong, nonatomic) UIImageView *logoImageView;
///
@property (strong, nonatomic) UILabel *contentLabel;
///
@property (strong, nonatomic) UILabel *timeLabel;
///
@property (strong, nonatomic) UIImageView *arrowImageView;
///
@property (nonatomic, strong) HDUIButton *callBtn;
///
@property (strong, nonatomic) SAInfoView *waybillView;
@end


@implementation TNOrderDetailExpressCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.expressBgControl];
    [self.expressBgControl addSubview:self.logoImageView];
    [self.expressBgControl addSubview:self.contentLabel];
    [self.expressBgControl addSubview:self.timeLabel];
    [self.expressBgControl addSubview:self.arrowImageView];
    [self.contentView addSubview:self.waybillView];
    [self.contentView addSubview:self.callBtn];
}
- (void)setModel:(TNOrderDetailExpressCellModel *)model {
    _model = model;
    self.contentLabel.text = model.content;
    if (!model.isOverseas) {
        //非海外购
        self.timeLabel.hidden = NO;
        self.timeLabel.text = model.time;
    } else {
        self.timeLabel.hidden = YES;
    }
    if (HDIsStringNotEmpty(model.trackingNo)) {
        self.waybillView.hidden = NO;
        self.waybillView.model.keyText = [TNLocalizedString(@"dK5ckXzw", @"运单号：") stringByAppendingString:model.trackingNo];
        [self.waybillView setNeedsUpdateContent];
    } else {
        self.waybillView.hidden = YES;
    }
    if (HDIsStringNotEmpty(model.riderOperatorNo)) {
        self.callBtn.hidden = NO;
    } else {
        self.callBtn.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.expressBgControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.contentView);
        if (self.waybillView.isHidden && self.callBtn.isHidden) {
            make.bottom.equalTo(self.contentView.mas_bottom);
        }
    }];

    [self.logoImageView sizeToFit];
    [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentLabel.mas_centerY);
        make.left.equalTo(self.expressBgControl.mas_left).offset(kRealWidth(15));
        make.size.mas_equalTo(self.logoImageView.image.size);
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(kRealWidth(5));
        make.right.lessThanOrEqualTo(self.arrowImageView.mas_left).offset(kRealWidth(5));
        make.top.equalTo(self.expressBgControl.mas_top).offset(kRealWidth(10));
        if (self.timeLabel.isHidden) {
            make.bottom.equalTo(self.expressBgControl.mas_bottom).offset(-kRealWidth(10));
        }
    }];


    if (!self.arrowImageView.isHidden) {
        [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.expressBgControl.mas_centerY);
            make.right.equalTo(self.expressBgControl.mas_right).offset(-kRealWidth(15));
            make.size.mas_equalTo(self.arrowImageView.image.size);
        }];
    }
    if (!self.timeLabel.isHidden) {
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentLabel.mas_leading);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(kRealWidth(5));
            make.bottom.equalTo(self.expressBgControl.mas_bottom).offset(-kRealWidth(10));
        }];
    }
    UIView *lastView = self.expressBgControl;
    if (!self.waybillView.isHidden) {
        [self.waybillView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(lastView.mas_bottom);
            if (self.callBtn.isHidden) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
            }
        }];
        lastView = self.waybillView;
    }

    if (!self.callBtn.isHidden) {
        //        [self.callBtn sizeToFit];
        [self.callBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kRealWidth(170)));
            make.height.equalTo(@(kRealWidth(25)));
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(lastView.mas_bottom).offset(kRealWidth(12));

            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        }];
    }

    [super updateConstraints];
}
//点击进入配送详情
- (void)onClickExpressDetail {
    if (self.model.isOverseas) {
        [[HDMediator sharedInstance] navigaveToTinhNowExpressTrackingViewController:@{@"orderNo": self.model.orderNo}];
    } else {
        [[HDMediator sharedInstance] navigaveToExpressDetails:@{@"bizOrderId": self.model.orderNo}];
    }
}

/** @lazy expressBgControl */
- (UIControl *)expressBgControl {
    if (!_expressBgControl) {
        _expressBgControl = [[UIControl alloc] init];
        [_expressBgControl addTarget:self action:@selector(onClickExpressDetail) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expressBgControl;
}
/** @lazy logoImageView */
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_order_express_car"]];
    }
    return _logoImageView;
}
/** @lazy contentLabel */
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _contentLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
/** @lazy timeLabel */
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
        _timeLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _timeLabel;
}
/** @lazy arrowImageView */
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray_small"]];
    }
    return _arrowImageView;
}
- (HDUIButton *)callBtn {
    if (!_callBtn) {
        _callBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _callBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard11;
        [_callBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_callBtn setTitle:TNLocalizedString(@"tn_call_rider", @"联系骑手") forState:UIControlStateNormal];
        [_callBtn setTitleColor:HexColor(0x5D667F) forState:UIControlStateNormal];
        _callBtn.layer.cornerRadius = kRealWidth(13);
        _callBtn.layer.borderColor = HexColor(0x5D667F).CGColor;
        _callBtn.layer.borderWidth = 1;
        [_callBtn setImage:[UIImage imageNamed:@"tn_rider_chat"] forState:UIControlStateNormal];
        _callBtn.spacingBetweenImageAndTitle = 2;
        @HDWeakify(self);
        [_callBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            //            [HDSystemCapabilityUtil makePhoneCall:self.model.riderPhone];
            NSDictionary *dict = @{
                @"operatorType": @(9),
                @"operatorNo": self.model.riderOperatorNo ?: @"",
                @"prepareSendTxt": [TNLocalizedString(@"RQhkSnX7", @"我想咨询运单号：") stringByAppendingString:HDIsStringNotEmpty(self.model.trackingNo) ? self.model.trackingNo : @""],
                @"phoneNo": self.model.riderPhone ?: @"",
                @"scene": SAChatSceneTypeYumNowDelivery
            };
            [[HDMediator sharedInstance] navigaveToIMViewController:dict];
        }];
    }
    return _callBtn;
}
/** @lazy waybillView */
- (SAInfoView *)waybillView {
    if (!_waybillView) {
        SAInfoViewModel *infoModel = [[SAInfoViewModel alloc] init];
        infoModel.leftImage = [UIImage imageNamed:@"tn_rider_trackingNo"];
        infoModel.valueImage = [UIImage imageNamed:@"tn_orderNo_copy"];
        infoModel.keyFont = HDAppTheme.TinhNowFont.standard14;
        infoModel.keyColor = HDAppTheme.TinhNowColor.G1;
        infoModel.lineWidth = 0;
        infoModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(5), kRealWidth(15), kRealWidth(5), kRealWidth(15));
        @HDWeakify(self);
        infoModel.clickedValueButtonHandler = ^{
            @HDStrongify(self);
            if (HDIsStringNotEmpty(self.model.trackingNo)) {
                [UIPasteboard generalPasteboard].string = self.model.trackingNo;
                [HDTips showWithText:TNLocalizedString(@"tn_copy_success", @"复制成功")];
            }
        };
        _waybillView = [SAInfoView infoViewWithModel:infoModel];
        _waybillView.hidden = YES;
    }
    return _waybillView;
}
@end


@implementation TNOrderDetailExpressCellModel

@end
