//
//  WMOrderDetailOrderInfoView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailOrderInfoView.h"
#import "SAGeneralUtil.h"
#import "SAInfoView.h"
#import "SAShadowBackgroundView.h"
#import "WMOrderDetailOrderInfoModel.h"


@interface WMOrderDetailOrderInfoHeaderView : SAView

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) SALabel *tagLabel;

@property (nonatomic, strong) UIView *line;

@end


@implementation WMOrderDetailOrderInfoHeaderView

- (void)hd_setupViews {
    [self addSubview:self.iconView];
    [self addSubview:self.label];
    [self addSubview:self.tagLabel];
    [self addSubview:self.line];
}

- (void)updateConstraints {
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(0);
    }];

    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(4);
        make.centerY.mas_equalTo(0);
    }];

    [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label.mas_right).offset(4);
        make.centerY.mas_equalTo(0);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(0.5);
    }];

    [super updateConstraints];
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yn_order_detail_order"]];
    }
    return _iconView;
}

- (UILabel *)label {
    if (!_label) {
        _label = UILabel.new;
        _label.textColor = UIColor.sa_C333;
        _label.text = PNLocalizedString(@"order_info", @"order_info");
        _label.font = HDAppTheme.font.sa_standard16B;
    }
    return _label;
}

- (SALabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = SALabel.new;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.text = WMLocalizedString(@"wm_pickup_Pickup", @"到店自取");
        _tagLabel.textColor = UIColor.whiteColor;
        _tagLabel.backgroundColor = UIColor.sa_C1;
        _tagLabel.font = HDAppTheme.font.sa_standard12;
        _tagLabel.hd_edgeInsets = UIEdgeInsetsMake(2, 8, 2, 8);
        _tagLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
        _tagLabel.hidden = YES;
    }
    return _tagLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.new;
        _line.backgroundColor = UIColor.sa_separatorLineColor;
    }
    return _line;
}

@end


@interface WMOrderDetailOrderInfoView ()
/// 订单号
@property (nonatomic, strong) SAInfoView *orderNoView;
/// 付款方式
@property (nonatomic, strong) SAInfoView *payMethodView;
/// 订单时间
@property (nonatomic, strong) SAInfoView *orderTimeView;
/// 所有的属性
@property (nonatomic, strong) NSMutableArray<SAInfoView *> *infoViewList;
/// 头部
@property (nonatomic, strong) WMOrderDetailOrderInfoHeaderView *deliveryHeadView;
/// 订单备注
@property (nonatomic, strong) SAInfoView *orderNoteView;

@end


@implementation WMOrderDetailOrderInfoView
- (void)hd_setupViews {
    self.layer.backgroundColor = HDAppTheme.WMColor.bg3.CGColor;
    self.layer.cornerRadius = kRealWidth(8);
    [self addSubview:self.deliveryHeadView];
    [self addSubview:self.orderNoView];
    [self addSubview:self.payMethodView];
    [self addSubview:self.orderTimeView];
    [self addSubview:self.orderNoteView];

    [self.infoViewList addObject:self.orderNoView];
    [self.infoViewList addObject:self.payMethodView];
    [self.infoViewList addObject:self.orderTimeView];
    [self.infoViewList addObject:self.orderNoteView];
}

- (void)updateConstraints {
    [self.deliveryHeadView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];

    NSArray<SAInfoView *> *visableInfoViews = [self.infoViewList hd_filterWithBlock:^BOOL(SAInfoView *_Nonnull item) {
        return !item.isHidden;
    }];

    SAInfoView *lastInfoView;
    for (SAInfoView *infoView in visableInfoViews) {
        infoView.model.lineWidth = 0;
        if (infoView == visableInfoViews.lastObject) {
            infoView.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), kRealWidth(16), kRealWidth(12));
        } else if (infoView == visableInfoViews.firstObject) {
            infoView.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), 0, kRealWidth(12));
        } else {
            infoView.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), 0, kRealWidth(12));
        }
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.top.equalTo(lastInfoView.mas_bottom);
            } else {
                make.top.equalTo(self.deliveryHeadView.mas_bottom);
            }
            make.left.equalTo(self);
            make.right.equalTo(self);
            if (infoView == visableInfoViews.lastObject) {
                make.bottom.equalTo(self).offset(-12);
            }
        }];
        lastInfoView = infoView;
    }
    [super updateConstraints];
}

#pragma mark - public methods
- (void)configureWithOrderDetailRspModel:(WMOrderDetailRspModel *)detailModel {
    WMOrderDetailOrderInfoModel *model = detailModel.orderInfo;
    self.orderNoView.hidden = HDIsStringEmpty(model.orderNo);
    if (!self.orderNoView.isHidden) {
        self.orderNoView.model.valueText = WMFillEmpty(model.orderNo);
        self.orderNoView.model.valueImagePosition = HDUIButtonImagePositionLeft;
        self.orderNoView.model.valueImage = [UIImage imageNamed:@"yn_order_detail_copy"];
        self.orderNoView.model.valueTitleEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(4), 0, 0);
        [self.orderNoView setNeedsUpdateContent];
    }
    self.payMethodView.hidden = model.paymentMethod == SAOrderPaymentTypeUnknown;
    if (!self.payMethodView.isHidden) {
        if (model.paymentMethod == SAOrderPaymentTypeOnline) {
            self.payMethodView.model.valueText = WMLocalizedString(@"order_payment_method_online", @"线上付款");
        } else if (model.paymentMethod == SAOrderPaymentTypeCashOnDelivery) {
            self.payMethodView.model.valueText = WMLocalizedString(@"order_payment_method_offline", @"货到付款");
        }
        [self.payMethodView setNeedsUpdateContent];
    }
    self.orderTimeView.hidden = HDIsStringEmpty(model.orderTimeStamp);
    if (!self.orderTimeView.isHidden) {
        // 时间戳转时间
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.orderTimeStamp.integerValue / 1000.0];
        NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy HH:mm"];
        self.orderTimeView.model.valueText = dateStr;
        [self.orderTimeView setNeedsUpdateContent];
    }


    self.orderNoteView.hidden = HDIsStringEmpty(detailModel.orderDetailForUser.remark) || detailModel.orderDetailForUser.serviceType != 20;
    if (!self.orderNoteView.isHidden) {
        self.orderNoteView.model.valueText = detailModel.orderDetailForUser.remark;
        [self.orderNoteView setNeedsUpdateContent];
    }

    self.deliveryHeadView.tagLabel.hidden = detailModel.orderDetailForUser.serviceType != 20;

    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyColor = HDAppTheme.WMColor.B9;
    model.keyFont = [HDAppTheme.WMFont wm_ForSize:14];
    model.valueColor = HDAppTheme.WMColor.B3;
    model.valueFont = [HDAppTheme.WMFont wm_ForSize:14];
    model.keyText = key;
    return model;
}

#pragma mark - lazy load

- (NSMutableArray<SAInfoView *> *)infoViewList {
    if (!_infoViewList) {
        _infoViewList = [NSMutableArray arrayWithCapacity:3];
    }
    return _infoViewList;
}

//- (SAInfoView *)deliveryHeadView {
//    if (!_deliveryHeadView) {
//        SAInfoView *view = SAInfoView.new;
//        view.model = [self infoViewModelWithKey:PNLocalizedString(@"order_info", @"order_info")];
//        view.model.keyColor = HDAppTheme.WMColor.B3;
//        view.model.keyImagePosition = HDUIButtonImagePositionLeft;
//        view.model.lineWidth = HDAppTheme.WMValue.line;
//        view.model.lineColor = HDAppTheme.WMColor.lineColorE9;
//        view.model.keyImage = [UIImage imageNamed:@"yn_order_detail_order"];
//        view.model.keyImageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kRealWidth(5));
//        view.model.keyFont = [HDAppTheme.WMFont wm_boldForSize:16];
//        view.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));
//        [view setNeedsUpdateContent];
//        _deliveryHeadView = view;
//    }
//    return _deliveryHeadView;
//}

- (WMOrderDetailOrderInfoHeaderView *)deliveryHeadView {
    if (!_deliveryHeadView) {
        _deliveryHeadView = WMOrderDetailOrderInfoHeaderView.new;
    }
    return _deliveryHeadView;
}

- (SAInfoView *)orderNoView {
    if (!_orderNoView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"order_number", @"订单号")];
        view.model.keyToValueWidthRate = 0.5;
        _orderNoView = view;
        _orderNoView.model.enableTapRecognizer = YES;
        _orderNoView.model.eventHandler = ^{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            NSString *copyStr = [view.model.valueText stringByReplacingOccurrencesOfString:@" " withString:@""];
            pasteboard.string = copyStr;
            [NAT showToastWithTitle:nil content:SALocalizedString(@"wm_order_copy_success", @"复制成功") type:HDTopToastTypeSuccess];
        };
    }
    return _orderNoView;
}

- (SAInfoView *)payMethodView {
    if (!_payMethodView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"order_payment_method", @"付款方式")];
        _payMethodView = view;
    }
    return _payMethodView;
}

- (SAInfoView *)orderTimeView {
    if (!_orderTimeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"order_create_time", @"订单创建时间")];
        _orderTimeView = view;
    }
    return _orderTimeView;
}

- (SAInfoView *)orderNoteView {
    if (!_orderNoteView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"order_remark", @"备注")];
        [view setNeedsUpdateContent];
        _orderNoteView = view;
    }
    return _orderNoteView;
}

@end
