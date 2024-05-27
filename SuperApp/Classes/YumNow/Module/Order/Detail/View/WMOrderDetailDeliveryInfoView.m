//
//  WMOrderDetailDeliveryInfoView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailDeliveryInfoView.h"
#import "SAGeneralUtil.h"
#import "SAInfoView.h"
#import "SAShadowBackgroundView.h"
#import "WMOrderDetailModel.h"


@interface WMOrderDetailDeliveryInfoView ()
/// 头部
@property (nonatomic, strong) SAInfoView *deliveryHeadView;
/// 配送地址，收货人及手机号
@property (nonatomic, strong) SAInfoView *deliveryAddress;
/// 配送时间
@property (nonatomic, strong) SAInfoView *deliveryTime;
/// 订单备注
@property (nonatomic, strong) SAInfoView *orderNoteView;
/// 骑手
@property (nonatomic, strong) SAInfoView *deliveryRiderView;
/// 所有的属性
@property (nonatomic, strong) NSMutableArray<SAInfoView *> *infoViewList;

@end


@implementation WMOrderDetailDeliveryInfoView
- (void)hd_setupViews {
    self.layer.backgroundColor = HDAppTheme.WMColor.bg3.CGColor;
    self.layer.cornerRadius = kRealWidth(8);
    [self addSubview:self.deliveryHeadView];
    [self addSubview:self.deliveryAddress];
    [self addSubview:self.deliveryTime];
    [self addSubview:self.orderNoteView];
    [self addSubview:self.deliveryRiderView];

    [self.infoViewList addObject:self.deliveryAddress];
    [self.infoViewList addObject:self.deliveryTime];
    [self.infoViewList addObject:self.orderNoteView];
    [self.infoViewList addObject:self.deliveryRiderView];
}

- (void)updateConstraints {
    [self.deliveryHeadView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
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
            make.left.right.mas_equalTo(0);
            if (infoView == visableInfoViews.lastObject) {
                make.bottom.mas_equalTo(0);
            }
        }];
        lastInfoView = infoView;
    }
    [super updateConstraints];
}

#pragma mark - public methods
- (void)configureWithOrderDetailModel:(WMOrderDetailModel *)model {
    self.deliveryAddress.hidden = HDIsObjectNil(model.receiver);
    if (!self.deliveryAddress.isHidden) {
        NSMutableString *str = [NSMutableString string];
        if (HDIsStringNotEmpty(model.receiver.receiverAddress)) {
            [str appendString:model.receiver.receiverAddress];
        }
        if (HDIsStringNotEmpty(model.receiver.receiverName) || HDIsStringNotEmpty(model.receiver.receiverPhone)) {
            [str appendString:@"\n"];
        }
        if (HDIsStringNotEmpty(model.receiver.receiverName)) {
            [str appendString:model.receiver.receiverName];
            [str appendString:@","];
        }
        if (HDIsStringNotEmpty(model.receiver.receiverPhone)) {
            [str appendString:model.receiver.receiverPhone];
        }

        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = kRealWidth(4);
        paragraphStyle.alignment = NSTextAlignmentRight;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        [attributes setObject:HDAppTheme.WMColor.B3 forKey:NSForegroundColorAttributeName];
        [attributes setObject:[HDAppTheme.WMFont wm_ForSize:14] forKey:NSFontAttributeName];
        self.deliveryAddress.model.attrValue = [[NSAttributedString alloc] initWithString:str attributes:attributes];
        [self.deliveryAddress setNeedsUpdateContent];
    }

    self.deliveryTime.hidden = model.deliveryInfo.eta <= 0 && model.deliveryInfo.ata <= 0;
    if (!self.deliveryTime.isHidden) {
        NSTimeInterval timeStamp = 0;
        // 优先显示实际到达时间
        if (model.deliveryInfo.ata > 0) {
            timeStamp = model.deliveryInfo.ata;
            self.deliveryTime.model.keyText = WMLocalizedString(@"arrive_time", @"送达时间");
        } else {
            timeStamp = model.deliveryInfo.eta;
            self.deliveryTime.model.keyText = WMLocalizedString(@"prospect_arrive_time", @"预计到达时间");
        }

        // 时间戳转时间
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp / 1000.0];
        NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy HH:mm"];

        self.deliveryTime.model.valueText = dateStr;
        [self.deliveryTime setNeedsUpdateContent];
    }
    self.orderNoteView.hidden = HDIsStringEmpty(model.remark);
    if (!self.orderNoteView.isHidden) {
        self.orderNoteView.model.valueText = model.remark;
        [self.orderNoteView setNeedsUpdateContent];
    }

    // 骑手接单后才显示
    BOOL isEventListContainsDeliverReceiveEvent = false;
    for (WMOrderEventModel *eventModel in model.orderEventList) {
        if (eventModel.eventType == WMOrderEventTypeDeliverReceive) {
            isEventListContainsDeliverReceiveEvent = true;
            break;
        }
    }
    self.deliveryRiderView.hidden = !isEventListContainsDeliverReceiveEvent || HDIsStringEmpty(model.deliveryInfo.rider.riderName);
    if (!self.deliveryRiderView.isHidden) {
        self.deliveryRiderView.model.valueText = model.deliveryInfo.rider.riderName;
        [self.deliveryRiderView setNeedsUpdateContent];
    }
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

- (SAInfoView *)deliveryHeadView {
    if (!_deliveryHeadView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:TNLocalizedString(@"yQCmXdeH", @"配送信息")];
        view.model.keyColor = HDAppTheme.WMColor.B3;
        view.model.keyImagePosition = HDUIButtonImagePositionLeft;
        view.model.lineWidth = HDAppTheme.WMValue.line;
        view.model.lineColor = HDAppTheme.WMColor.lineColorE9;
        view.model.keyImage = [UIImage imageNamed:@"yn_order_detail_deliver"];
        view.model.keyImageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kRealWidth(5));
        view.model.keyFont = [HDAppTheme.WMFont wm_boldForSize:16];
        view.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));
        [view setNeedsUpdateContent];
        _deliveryHeadView = view;
    }
    return _deliveryHeadView;
}

- (SAInfoView *)deliveryAddress {
    if (!_deliveryAddress) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"delivery_address", @"配送地址")];
        [view setNeedsUpdateContent];
        _deliveryAddress = view;
    }
    return _deliveryAddress;
}

- (SAInfoView *)deliveryTime {
    if (!_deliveryTime) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"prospect_arrive_time", @"预计到达时间")];
        view.hidden = true;
        [view setNeedsUpdateContent];
        _deliveryTime = view;
    }
    return _deliveryTime;
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

- (SAInfoView *)deliveryRiderView {
    if (!_deliveryRiderView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"order_rider", @"骑手")];
        view.hidden = true;
        [view setNeedsUpdateContent];
        _deliveryRiderView = view;
    }
    return _deliveryRiderView;
}
@end
