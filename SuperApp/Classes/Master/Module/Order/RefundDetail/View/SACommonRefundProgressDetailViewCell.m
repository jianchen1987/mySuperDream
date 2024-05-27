//
//  SARefundProgressDetailViewCell.m
//  SuperApp
//
//  Created by Tia on 2022/5/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACommonRefundProgressDetailViewCell.h"
#import "SACommonRefundInfoModel.h"
#import "SAInfoView.h"
#import "SAOperationButton.h"

static NSString *zy_redColor = @"#FC2040";

static CGFloat pointWidth = 8;


@interface SARefundProgressDetailView : SAView
/// 进度状态
@property (nonatomic, strong) SALabel *statusLB;
/// 时间
@property (nonatomic, strong) SALabel *timeLB;
/// 详情
@property (nonatomic, strong) SALabel *detailLB;
/// 竖线
@property (nonatomic, strong) UIView *line;
/// 小红点父视图
@property (nonatomic, strong) UIView *pointView;
/// 小红点
@property (nonatomic, strong) UIView *point;

@end


@implementation SARefundProgressDetailView

- (void)hd_setupViews {
    [self addSubview:self.line];
    [self addSubview:self.pointView];
    [self.pointView addSubview:self.point];
    [self addSubview:self.statusLB];
    [self addSubview:self.timeLB];
    [self addSubview:self.detailLB];
}

- (void)updateConstraints {
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(15));
        make.top.height.equalTo(self);
        make.width.mas_equalTo(1);
    }];
    [self.pointView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.line);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(pointWidth * 2, pointWidth * 2));
    }];
    [self.point mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.pointView);
        make.size.mas_equalTo(CGSizeMake(pointWidth, pointWidth));
    }];

    [self.statusLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.point.mas_right).offset(kRealWidth(15));
        make.right.equalTo(self).offset(-kRealWidth(15));
        make.top.equalTo(self.pointView);
    }];
    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLB);
        make.top.equalTo(self.statusLB.mas_bottom).offset(kRealWidth(10));
    }];

    id mas_bottom = self.timeLB.hidden ? self.statusLB.mas_bottom : self.timeLB.mas_bottom;

    [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLB);
        make.top.equalTo(mas_bottom).offset(kRealWidth(10));
        make.right.equalTo(self).offset(-kRealWidth(15));
        make.bottom.lessThanOrEqualTo(self).offset(-kRealWidth(25));
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (SALabel *)statusLB {
    if (!_statusLB) {
        SALabel *l = SALabel.new;
        l.font = [HDAppTheme.font boldForSize:13];
        l.textColor = HDAppTheme.color.G3;
        l.numberOfLines = 0;
        _statusLB = l;
    }
    return _statusLB;
}

- (SALabel *)timeLB {
    if (!_timeLB) {
        SALabel *l = SALabel.new;
        l.font = HDAppTheme.font.standard4;
        l.textColor = HDAppTheme.color.G3;
        _timeLB = l;
    }
    return _timeLB;
}

- (SALabel *)detailLB {
    if (!_detailLB) {
        SALabel *l = SALabel.new;
        l.font = HDAppTheme.font.standard4;
        l.textColor = HDAppTheme.color.G3;
        l.numberOfLines = 0;
        _detailLB = l;
    }
    return _detailLB;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.new;
        _line.backgroundColor = HDAppTheme.color.G6;
    }
    return _line;
}

- (UIView *)pointView {
    if (!_pointView) {
        _pointView = UIView.new;
        _pointView.backgroundColor = UIColor.whiteColor;
    }
    return _pointView;
}

- (UIView *)point {
    if (!_point) {
        _point = UIView.new;
        _point.layer.cornerRadius = pointWidth / 2;
        _point.clipsToBounds = YES;
        _point.backgroundColor = HDAppTheme.color.G6;
    }
    return _point;
}

@end


@interface SACommonRefundProgressDetailViewCell ()

///退款详情视图
@property (nonatomic, strong) UIView *refundDetailView;
/// 红线
@property (nonatomic, strong) UIView *redTopLine;
/// 退款状态
@property (nonatomic, strong) SALabel *statusLB;
/// 全额退款
@property (nonatomic, strong) SALabel *resultLB;
/// 分割线
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) NSArray *infoViewList;
/// 退款金额
@property (nonatomic, strong) SAInfoView *refundCountView;
/// 退回至
@property (nonatomic, strong) SAInfoView *refundBackView;
/// 支付渠道订单
@property (nonatomic, strong) SAInfoView *payOrderNumberView;

/// 查看钱款去向按钮
@property (nonatomic, strong) SAOperationButton *checkMoneyBTN;

/// 退款进度视图
@property (nonatomic, strong) UIView *refundProgressView;
@property (nonatomic, strong) SALabel *prgressLB;
/// 进度视图数组
@property (nonatomic, strong) NSMutableArray *progressDetailViewList;
@property (nonatomic, strong) UIView *line2;
/// 订单编号
@property (nonatomic, strong) SAInfoView *orderNumberView;
/// 退款编号
@property (nonatomic, strong) SAInfoView *refundNumberView;

/// 退款协商历史
@property (nonatomic, strong) SAInfoView *histortView;

@end


@implementation SACommonRefundProgressDetailViewCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor hd_colorWithHexString:@"F7F8F9"];
    [self.contentView addSubview:self.refundDetailView];

    [self.refundDetailView addSubview:self.redTopLine];
    [self.refundDetailView addSubview:self.statusLB];
    [self.refundDetailView addSubview:self.resultLB];
    [self.refundDetailView addSubview:self.line1];

    [self.refundDetailView addSubview:self.refundCountView];
    [self.refundDetailView addSubview:self.refundBackView];
    [self.refundDetailView addSubview:self.payOrderNumberView];
    [self.refundDetailView addSubview:self.checkMoneyBTN];

    [self.contentView addSubview:self.refundProgressView];
    [self.refundProgressView addSubview:self.prgressLB];

    self.progressDetailViewList = @[].mutableCopy;
    NSInteger count = 10;
    for (NSInteger i = 0; i < count; i++) {
        SARefundProgressDetailView *v = SARefundProgressDetailView.new;
        if (i == count - 1) {
            v.line.hidden = YES;
        }
        if (i == 0) {
            v.point.backgroundColor = [UIColor hd_colorWithHexString:zy_redColor];
            v.statusLB.textColor = HDAppTheme.color.G1;
            v.timeLB.textColor = v.detailLB.textColor = HDAppTheme.color.G2;
            v.timeLB.hidden = YES;
        }
        [self.progressDetailViewList addObject:v];
        [self.refundProgressView addSubview:v];
    }
    [self.refundProgressView addSubview:self.line2];
    [self.refundProgressView addSubview:self.orderNumberView];
    [self.refundProgressView addSubview:self.refundNumberView];

    [self.contentView addSubview:self.histortView];

    self.infoViewList = @[self.refundCountView, self.refundBackView, self.payOrderNumberView];
}

#pragma mark - setter
- (void)setModel:(SACommonRefundInfoModel *)model {
    _model = model;

    self.statusLB.text = [SAGeneralUtil getRefundStatusDescWithEnum:model.refundOrderState];

    self.resultLB.text = model.refundCategory != 11 ? SALocalizedString(@"full_refund", @"全额退款") : SALocalizedString(@"partial_refund", @"部分退款");

    if (HDIsStringNotEmpty(model.refundAmount.thousandSeparatorAmount)) {
        self.refundCountView.model.valueText = model.refundAmount.thousandSeparatorAmount;
        [self.refundCountView setNeedsUpdateContent];
    }

    if (self.model.refundWay == 1) { //线上渠道
        if (HDIsStringNotEmpty(model.payChannel)) {
            //            self.refundBackView.model.valueText = SALocalizedString(@"return_back", @"原路退回");
            self.refundBackView.model.valueText = model.payChannel;
            [self.refundBackView setNeedsUpdateContent];
        }
    } else if (self.model.refundWay == 2) { //线下渠道
        self.refundBackView.model.valueText = SALocalizedString(@"payment_method_offline_transfer", @"线下转账");
        [self.refundBackView setNeedsUpdateContent];
    }

    if (HDIsStringNotEmpty(model.payOrderNo)) {
        self.payOrderNumberView.model.valueText = model.payOrderNo;
        [self.payOrderNumberView setNeedsUpdateContent];
    }

    //动态添加退款进度节点
    {
        for (SARefundProgressDetailView *v in self.progressDetailViewList) {
            [v removeFromSuperview];
        }
        [self.progressDetailViewList removeAllObjects];
        NSInteger count = model.refundOrderOperateList.count;
        if (count) {
            for (NSInteger i = 0; i < count; i++) {
                SACommonRefundOperateListModel *m = model.refundOrderOperateList[i];
                SARefundProgressDetailView *v = SARefundProgressDetailView.new;
                if (i == count - 1)
                    v.line.hidden = YES;
                if (i == 0) {
                    v.point.backgroundColor = [UIColor hd_colorWithHexString:zy_redColor];
                    v.statusLB.textColor = HDAppTheme.color.G1;
                    v.timeLB.textColor = v.detailLB.textColor = HDAppTheme.color.G2;
                }
                //如果退款来源是重复支付或者超时支付，且退款节点是在创建退款则显示固定文言
                if ((model.refundSource == SARefundSourceRepeat || model.refundSource == SARefundSourceTimeout) && m.operationType == SARefundOperationTypeCreate) {
                    v.statusLB.text = model.refundSource == SARefundSourceRepeat ? SALocalizedString(@"refund_automatic_refund_tip1", @"自动退款 (重复支付）") :
                                                                                   SALocalizedString(@"refund_automatic_refund_tip2", @"自动退款 (超时支付）");
                } else {
                    v.statusLB.text = [SAGeneralUtil getRefundOperationDescWithEnum:m.operationType];
                }

                v.timeLB.text = [SAGeneralUtil getDateStrWithTimeInterval:m.updateTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"];
                if (m.operationType == SARefundOperationTypeInitiate) { //受理退款
                    v.detailLB.text = SALocalizedString(@"refundOperationType_tip1", @"大象APP 已受理你的退款申请");
                } else if (m.operationType == SARefundOperationTypeFinish) { //退款完成
                    v.detailLB.text = [NSString stringWithFormat:SALocalizedString(@"refundOperationType_tip2", @"款项退回至: %@, 到账时间以渠道处理为准"), model.payChannel];
                } else if ((model.refundSource == SARefundSourceRepeat || model.refundSource == SARefundSourceTimeout) && m.operationType == SARefundOperationTypeCreate) {
                    v.detailLB.text = model.refundSource == SARefundSourceRepeat ? SALocalizedString(@"refund_automatic_refund_tip3", @"订单重复支付，多支付的款项由系统自动退款") :
                                                                                   SALocalizedString(@"refund_automatic_refund_tip4", @"支付成功时间超过订单有效期，系统自动退款");
                } else {
                    v.detailLB.text = m.remark;
                }
                [self.progressDetailViewList addObject:v];
                [self.refundProgressView addSubview:v];
            }
        }
    }

    self.checkMoneyBTN.hidden = model.guideShow != 10;

    if (HDIsStringNotEmpty(model.businessOrderId)) {
        self.orderNumberView.model.valueText = model.businessOrderId;
        [self.orderNumberView setNeedsUpdateContent];
    }

    if (HDIsStringNotEmpty(model.refundOrderNo)) {
        self.refundNumberView.model.valueText = model.refundOrderNo;
        [self.refundNumberView setNeedsUpdateContent];
    }

    self.histortView.hidden = !HDIsStringNotEmpty(model.negotiationHistoryUrl);

    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)checkRefundDestination {
    if (self.model.guideShow == 11)
        return;

    if (self.model.refundWay == 1) { //线上渠道
        if (HDIsStringNotEmpty(self.model.iosUrl)) {
            if ([SAWindowManager canOpenURL:self.model.iosUrl]) {
                [SAWindowManager openUrl:self.model.iosUrl withParameters:nil];
            }
        }
    } else if (self.model.refundWay == 2) { //线下渠道
        if (self.model.offlineRefundOrderDetail) {
            NSMutableDictionary *params = [self.model.offlineRefundOrderDetail yy_modelToJSONObject];
            [HDMediator.sharedInstance navigaveToRefundDestinationViewController:params];
        }
    }
}

#pragma mark - layout
- (void)updateConstraints {
    CGFloat margin = kRealWidth(15);
    //退款状态
    [self.refundDetailView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(margin);
        make.left.width.equalTo(self.contentView);
    }];

    [self.redTopLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.refundDetailView);
        make.height.mas_equalTo(kRealHeight(5));
    }];

    [self.statusLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redTopLine.mas_bottom).offset(10);
        make.left.mas_equalTo(margin);
    }];

    [self.resultLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLB.mas_bottom).offset(10);
        make.left.equalTo(self.statusLB);
    }];

    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLB);
        make.right.mas_equalTo(-margin);
        make.height.mas_equalTo(PixelOne);
        make.top.equalTo(self.resultLB.mas_bottom).offset(10);
    }];

    UIView *lastView = nil;
    for (SAInfoView *view in self.infoViewList) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.top.equalTo(self.line1.mas_bottom);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            make.left.right.equalTo(self.refundDetailView);
            if (view == self.infoViewList.lastObject) {
                make.bottom.equalTo(self.checkMoneyBTN.mas_top);
            }
        }];
        lastView = view;
    }

    if (self.checkMoneyBTN.hidden) {
        [self.payOrderNumberView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.refundBackView.mas_bottom);
            make.left.bottom.right.equalTo(self.refundDetailView);
        }];
    } else {
        [self.checkMoneyBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.refundDetailView.mas_left).offset(margin);
            make.bottom.right.equalTo(self.refundDetailView).offset(-margin);
            make.height.mas_equalTo(kRealHeight(45));
        }];
    }

    //退款进度
    [self.refundProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refundDetailView.mas_bottom).offset(kRealHeight(10));
        make.left.width.equalTo(self.contentView);
    }];

    [self.prgressLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(margin);
    }];

    lastView = nil;
    if (self.progressDetailViewList.count) {
        for (UIView *view in self.progressDetailViewList) {
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (!lastView) {
                    make.top.equalTo(self.prgressLB.mas_bottom).offset(margin);
                } else {
                    make.top.equalTo(lastView.mas_bottom);
                }
                make.left.right.equalTo(self.refundDetailView);
            }];
            lastView = view;
        }
    }
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.height.mas_equalTo(PixelOne);
        if (lastView) {
            make.top.equalTo(lastView.mas_bottom);
        } else {
            make.top.equalTo(self.prgressLB.mas_bottom).offset(margin);
        }
    }];

    [self.orderNumberView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom);
        make.left.right.equalTo(self.refundProgressView);
    }];

    [self.refundNumberView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNumberView.mas_bottom);
        make.left.right.equalTo(self.refundProgressView);
        make.bottom.equalTo(self.refundProgressView);
    }];

    if (self.histortView.hidden) {
        [self.refundProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.refundDetailView.mas_bottom).offset(kRealHeight(10));
            make.left.width.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
    } else {
        //退款协商历史
        [self.histortView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.refundProgressView.mas_bottom).offset(kRealHeight(10));
            make.bottom.left.right.equalTo(self.contentView);
        }];
    }
    [super updateConstraints];
}

#pragma mark - lazy load
- (UIView *)refundDetailView {
    if (!_refundDetailView) {
        UIView *view = UIView.new;
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        _refundDetailView = view;
    }
    return _refundDetailView;
}

- (UIView *)redTopLine {
    if (!_redTopLine) {
        UIView *view = UIView.new;
        view.backgroundColor = [UIColor hd_colorWithHexString:zy_redColor];
        _redTopLine = view;
    }
    return _redTopLine;
}

- (SALabel *)statusLB {
    if (!_statusLB) {
        _statusLB = SALabel.new;
        _statusLB.font = HDAppTheme.font.standard1Bold;
        _statusLB.textColor = [HDAppTheme.color G1];
        //        _statusLB.text = @"退款中";
    }
    return _statusLB;
}

- (SALabel *)resultLB {
    if (!_resultLB) {
        _resultLB = SALabel.new;
        _resultLB.font = HDAppTheme.font.standard3;
        _resultLB.textColor = [UIColor hd_colorWithHexString:zy_redColor];
        //        _resultLB.text = SALocalizedString(@"full_refund", @"全额退款");
        //        _resultLB.text = SALocalizedString(@"partial_refund", @"部分退款");
    }
    return _resultLB;
}

- (UIView *)line1 {
    if (!_line1) {
        UIView *view = UIView.new;
        view.backgroundColor = HDAppTheme.color.G4;
        _line1 = view;
    }
    return _line1;
}

- (SAInfoView *)refundCountView {
    if (!_refundCountView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.keyText = SALocalizedString(@"refund_amount", @"退款金额");
        model.keyColor = HDAppTheme.color.G1;
        model.keyFont = HDAppTheme.font.standard3Bold;
        model.valueColor = HDAppTheme.color.G1;
        model.valueFont = [HDAppTheme.font forSize:14];
        model.lineWidth = 0;
        view.model = model;
        _refundCountView = view;
    }
    return _refundCountView;
}

- (SAInfoView *)refundBackView {
    if (!_refundBackView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.keyText = SALocalizedString(@"refund_to", @"退 回 至");
        model.keyColor = HDAppTheme.color.G1;
        model.keyFont = HDAppTheme.font.standard3Bold;
        model.valueColor = HDAppTheme.color.G1;
        model.valueFont = [HDAppTheme.font forSize:14];
        model.lineWidth = 0;
        view.model = model;
        _refundBackView = view;
    }
    return _refundBackView;
}

- (SAInfoView *)payOrderNumberView {
    if (!_payOrderNumberView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.keyText = SALocalizedString(@"payment_channel_order", @"支付渠道订单");
        model.keyColor = HDAppTheme.color.G1;
        model.keyFont = HDAppTheme.font.standard3Bold;
        model.valueColor = HDAppTheme.color.G1;
        model.valueFont = [HDAppTheme.font forSize:14];
        model.lineWidth = 0;
        model.rightButtonImage = [UIImage imageNamed:@"commonRefund_copy"];
        model.enableTapRecognizer = YES;
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            if (HDIsStringNotEmpty(self.model.payOrderNo)) {
                [UIPasteboard generalPasteboard].string = self.model.payOrderNo;
                [HDTips showWithText:TNLocalizedString(@"tn_copy_success", @"复制成功")];
            }
        };
        view.model = model;

        _payOrderNumberView = view;
    }
    return _payOrderNumberView;
}

- (SAOperationButton *)checkMoneyBTN {
    if (!_checkMoneyBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [button applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:zy_redColor]];
        [button setTitleColor:[UIColor hd_colorWithHexString:zy_redColor] forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.font standard2];
        [button setTitle:SALocalizedStringFromTable(@"where_refund_goes", @"查看钱款去向", @"Buttons") forState:UIControlStateNormal];
        [button applyHollowPropertiesWithTintColor:[UIColor hd_colorWithHexString:zy_redColor]];
        _checkMoneyBTN = button;
        [_checkMoneyBTN addTarget:self action:@selector(checkRefundDestination) forControlEvents:UIControlEventTouchUpInside];
        _checkMoneyBTN.hidden = YES;
    }
    return _checkMoneyBTN;
}

- (UIView *)refundProgressView {
    if (!_refundProgressView) {
        UIView *view = UIView.new;
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        _refundProgressView = view;
    }
    return _refundProgressView;
}

- (SALabel *)prgressLB {
    if (!_prgressLB) {
        _prgressLB = SALabel.new;
        _prgressLB.font = [HDAppTheme.font standard3Bold];
        _prgressLB.textColor = [HDAppTheme.color G1];
        _prgressLB.text = SALocalizedString(@"refund_progress", @"退款进度");
    }
    return _prgressLB;
}

- (UIView *)line2 {
    if (!_line2) {
        UIView *view = UIView.new;
        view.backgroundColor = HDAppTheme.color.G4;
        _line2 = view;
    }
    return _line2;
}

- (SAInfoView *)orderNumberView {
    if (!_orderNumberView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.keyText = SALocalizedString(@"top_up_order_no", @"订单编号");
        model.keyColor = HDAppTheme.color.G2;
        model.keyFont = [HDAppTheme.font boldForSize:13];
        model.valueColor = HDAppTheme.color.G1;
        model.valueFont = [HDAppTheme.font forSize:12];
        model.lineWidth = 0;
        view.model = model;
        _orderNumberView = view;
    }
    return _orderNumberView;
}

- (SAInfoView *)refundNumberView {
    if (!_refundNumberView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.keyText = SALocalizedString(@"refund_no", @"退款编号");
        model.keyColor = HDAppTheme.color.G2;
        model.keyFont = [HDAppTheme.font boldForSize:13];
        model.valueColor = HDAppTheme.color.G1;
        model.valueFont = [HDAppTheme.font forSize:14];
        model.lineWidth = 0;
        model.rightButtonImage = [UIImage imageNamed:@"commonRefund_copy"];
        model.enableTapRecognizer = YES;
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            if (HDIsStringNotEmpty(self.model.refundOrderNo)) {
                [UIPasteboard generalPasteboard].string = self.model.refundOrderNo;
                [HDTips showWithText:TNLocalizedString(@"tn_copy_success", @"复制成功")];
            }
        };
        view.model = model;
        _refundNumberView = view;
    }
    return _refundNumberView;
}

- (SAInfoView *)histortView {
    if (!_histortView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.keyText = SALocalizedString(@"refund_egotiation", @"退款协商历史");
        model.keyFont = HDAppTheme.font.standard3Bold;
        model.keyColor = HDAppTheme.color.G1;
        model.lineWidth = 0;
        model.rightButtonImage = [UIImage imageNamed:@"black_arrow"];
        model.enableTapRecognizer = YES;
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            if (HDIsStringNotEmpty(self.model.negotiationHistoryUrl)) {
                if ([SAWindowManager canOpenURL:self.model.negotiationHistoryUrl]) {
                    [SAWindowManager openUrl:self.model.negotiationHistoryUrl withParameters:nil];
                }
            }
        };
        view.model = model;
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        _histortView = view;
    }
    return _histortView;
}

@end
