//
//  PNApartmentRecordDetailViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentRecordDetailViewController.h"
#import "PNApartmentDTO.h"
#import "PNInfoView.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNApartmentVoucherImageView.h"


@interface PNApartmentRecordDetailViewController ()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) SALabel *statusLabel;
@property (nonatomic, strong) SALabel *payAmountLabel;

@property (nonatomic, strong) PNInfoView *createTimeInfoView;
@property (nonatomic, strong) PNInfoView *numberInfoView;
@property (nonatomic, strong) PNInfoView *statusInfoView;
@property (nonatomic, strong) PNInfoView *merchantNameInfoView;
@property (nonatomic, strong) PNInfoView *itemNameInfoView;
@property (nonatomic, strong) PNInfoView *roomNoInfoView;
@property (nonatomic, strong) PNInfoView *payAmountInfoView;
@property (nonatomic, strong) PNInfoView *remarkInfoView;
@property (nonatomic, strong) PNInfoView *payFinishTimeInfoView;
@property (nonatomic, strong) PNApartmentVoucherImageView *voucherImgView;
@property (nonatomic, strong) PNInfoView *voucherRemarkInfoView;


@property (nonatomic, copy) NSString *paymentId;
@property (nonatomic, copy) NSString *feesNo;
@property (nonatomic, strong) PNApartmentDTO *apartmentDTO;
@property (nonatomic, copy) void (^callBack)(void);
@end


@implementation PNApartmentRecordDetailViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.paymentId = [parameters objectForKey:@"paymentId"];
        self.feesNo = [parameters objectForKey:@"feesNo"];
        self.callBack = [parameters objectForKey:@"callBack"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    !self.callBack ?: self.callBack();
}

- (void)hd_bindViewModel {
    [self getData];
}

- (void)getData {
    [self showloading];

    @HDWeakify(self);
    [self.apartmentDTO getApartmentInfoWithNo:self.paymentId feesNo:self.feesNo success:^(PNApartmentListItemModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        [self setData:rspModel];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_bill_detail", @"缴费详情");
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    self.scrollViewContainer.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.scrollViewContainer addSubview:self.iconImgView];
    [self.scrollViewContainer addSubview:self.statusLabel];
    [self.scrollViewContainer addSubview:self.payAmountLabel];

    [self.scrollViewContainer addSubview:self.createTimeInfoView];
    [self.scrollViewContainer addSubview:self.numberInfoView];
    [self.scrollViewContainer addSubview:self.statusInfoView];
    [self.scrollViewContainer addSubview:self.merchantNameInfoView];
    [self.scrollViewContainer addSubview:self.itemNameInfoView];
    [self.scrollViewContainer addSubview:self.roomNoInfoView];
    [self.scrollViewContainer addSubview:self.payAmountInfoView];
    [self.scrollViewContainer addSubview:self.remarkInfoView];

    [self.scrollViewContainer addSubview:self.payFinishTimeInfoView];
    [self.scrollViewContainer addSubview:self.voucherImgView];
    [self.scrollViewContainer addSubview:self.voucherRemarkInfoView];
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconImgView.image.size);
        make.centerX.mas_equalTo(self.scrollViewContainer.mas_centerX);
        make.top.mas_equalTo(kRealWidth(32));
    }];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(kRealWidth(12));
    }];

    [self.payAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(kRealWidth(4));
    }];


    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.scrollViewContainer.subviews];
    NSMutableArray *visableInfoViews = [NSMutableArray arrayWithCapacity:tempArr.count];
    for (UIView *itemView in tempArr) {
        if ([itemView isKindOfClass:PNInfoView.class] || [itemView isKindOfClass:PNApartmentVoucherImageView.class]) {
            itemView.isHidden ?: [visableInfoViews addObject:itemView];
        }
    }

    UIView *lastInfoView;
    for (UIView *infoView in visableInfoViews) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.top.equalTo(lastInfoView.mas_bottom);
            } else {
                make.top.equalTo(self.payAmountLabel.mas_bottom).offset(kRealWidth(16));
            }
            make.left.right.equalTo(self.scrollViewContainer);
            if (infoView == visableInfoViews.lastObject) {
                make.bottom.equalTo(self.scrollViewContainer);
            }
        }];
        lastInfoView = infoView;
    }

    [super updateViewConstraints];
}

#pragma mark
- (void)setData:(PNApartmentListItemModel *)model {
    NSString *imageName = @"";
    switch (model.paymentStatus) {
        case PNApartmentPaymentStatus_TO_PAID:
            imageName = @"pn_apartment_order_details_to_be_pay";
            break;
        case PNApartmentPaymentStatus_PAID:
            imageName = @"pn_apartment_order_details_success";
            break;
        case PNApartmentPaymentStatus_CLOSED:
            imageName = @"pn_apartment_order_details_close";
            break;
        case PNApartmentPaymentStatus_USER_REJECT:
            imageName = @"pn_apartment_order_details_reject";
            break;
        case PNApartmentPaymentStatus_USER_HAS_UPLOADED_VOUCHER:
            imageName = @"pn_apartment_order_details_uploaded";
            break;
        default:
            break;
    }

    self.iconImgView.image = [UIImage imageNamed:imageName];
    self.statusLabel.text = [PNCommonUtils getApartmentStatusName:model.paymentStatus];
    self.payAmountLabel.text = model.paymentAmount.thousandSeparatorAmount;

    self.createTimeInfoView.model.valueText = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:model.createTime.floatValue / 1000]];
    [self.createTimeInfoView setNeedsUpdateContent];

    self.numberInfoView.model.valueText = model.paymentSlipNo;
    [self.numberInfoView setNeedsUpdateContent];

    self.statusInfoView.model.valueText = [PNCommonUtils getApartmentStatusName:model.paymentStatus];
    [self.statusInfoView setNeedsUpdateContent];

    self.merchantNameInfoView.model.valueText = model.merchantName;
    [self.merchantNameInfoView setNeedsUpdateContent];

    self.itemNameInfoView.model.valueText = model.paymentItems;
    [self.itemNameInfoView setNeedsUpdateContent];

    self.roomNoInfoView.model.valueText = model.roomNo;
    [self.roomNoInfoView setNeedsUpdateContent];

    self.payAmountInfoView.model.valueText = [model.paymentAmount thousandSeparatorAmount];
    [self.payAmountInfoView setNeedsUpdateContent];

    self.remarkInfoView.model.valueText = model.remark;
    [self.remarkInfoView setNeedsUpdateContent];

    if (model.paymentStatus == PNApartmentPaymentStatus_PAID) {
        self.payFinishTimeInfoView.model.valueText = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:model.paymentFinishTime.floatValue / 1000]];
        [self.payFinishTimeInfoView setNeedsUpdateContent];
        self.payFinishTimeInfoView.hidden = NO;
    } else {
        self.payFinishTimeInfoView.hidden = YES;
    }


    if (!WJIsArrayEmpty(model.voucherImgUrl)) {
        self.voucherImgView.imagesURL = model.voucherImgUrl;
        self.voucherImgView.hidden = NO;
    } else {
        self.voucherImgView.hidden = YES;
    }

    if (WJIsStringNotEmpty(model.voucherRemark)) {
        self.voucherRemarkInfoView.model.valueText = model.voucherRemark;

        if (model.paymentStatus == PNApartmentPaymentStatus_USER_REJECT) {
            self.voucherRemarkInfoView.model.keyText = PNLocalizedString(@"pn_reject_remark", @"拒绝备注");
        } else if (model.paymentStatus == PNApartmentPaymentStatus_CLOSED) {
            self.voucherRemarkInfoView.model.keyText = PNLocalizedString(@"pn_close_remark", @"关闭备注");
        } else {
            self.voucherRemarkInfoView.model.keyText = PNLocalizedString(@"pn_voucher_remark", @"凭证备注");
        }
        [self.voucherRemarkInfoView setNeedsUpdateContent];
        self.voucherRemarkInfoView.hidden = NO;
    } else {
        self.voucherRemarkInfoView.hidden = YES;
    }

    [self.view setNeedsUpdateConstraints];
}

#pragma mark
- (PNApartmentDTO *)apartmentDTO {
    if (!_apartmentDTO) {
        _apartmentDTO = [[PNApartmentDTO alloc] init];
    }
    return _apartmentDTO;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _iconImgView = imageView;
    }
    return _iconImgView;
}

- (SALabel *)statusLabel {
    if (!_statusLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14M;
        label.textAlignment = NSTextAlignmentCenter;
        _statusLabel = label;
    }
    return _statusLabel;
}

- (SALabel *)payAmountLabel {
    if (!_payAmountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = [HDAppTheme.PayNowFont fontDINBold:32];
        label.textAlignment = NSTextAlignmentCenter;
        _payAmountLabel = label;
    }
    return _payAmountLabel;
}

- (PNInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    PNInfoViewModel *model = PNInfoViewModel.new;
    model.keyText = key;
    model.keyColor = HDAppTheme.PayNowColor.c999999;
    model.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    model.valueFont = HDAppTheme.PayNowFont.standard14M;
    model.valueColor = HDAppTheme.PayNowColor.c333333;
    model.lineWidth = 0;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(12), kRealWidth(15));
    model.valueNumbersOfLines = 0;
    return model;
}

- (PNInfoView *)createTimeInfoView {
    if (!_createTimeInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间")];
        view.model = model;
        _createTimeInfoView = view;
    }
    return _createTimeInfoView;
}

- (PNInfoView *)numberInfoView {
    if (!_numberInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_bill_no", @"缴费单号")];
        view.model = model;
        _numberInfoView = view;
    }
    return _numberInfoView;
}

- (PNInfoView *)statusInfoView {
    if (!_statusInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_bill_status", @"缴费状态")];
        view.model = model;
        _statusInfoView = view;
    }
    return _statusInfoView;
}

- (PNInfoView *)merchantNameInfoView {
    if (!_merchantNameInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"ms_merchant_name", @"商户名称")];
        view.model = model;
        _merchantNameInfoView = view;
    }
    return _merchantNameInfoView;
}

- (PNInfoView *)itemNameInfoView {
    if (!_itemNameInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_bill_items", @"缴费项目")];
        view.model = model;
        _itemNameInfoView = view;
    }
    return _itemNameInfoView;
}

- (PNInfoView *)roomNoInfoView {
    if (!_roomNoInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_room_no", @"房号")];
        view.model = model;
        _roomNoInfoView = view;
    }
    return _roomNoInfoView;
}

- (PNInfoView *)payAmountInfoView {
    if (!_payAmountInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_bill_amount", @"缴费金额")];
        view.model = model;
        _payAmountInfoView = view;
    }
    return _payAmountInfoView;
}

- (PNInfoView *)remarkInfoView {
    if (!_remarkInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_bill_remark", @"账单备注")];
        view.model = model;
        _remarkInfoView = view;
    }
    return _remarkInfoView;
}

- (PNInfoView *)payFinishTimeInfoView {
    if (!_payFinishTimeInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_Payment_complete_time", @"缴费完成时间")];
        view.model = model;
        _payFinishTimeInfoView = view;
        _payFinishTimeInfoView.hidden = YES;
    }
    return _payFinishTimeInfoView;
}

- (PNInfoView *)voucherRemarkInfoView {
    if (!_voucherRemarkInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_voucher_remark", @"凭证备注")];
        view.model = model;
        _voucherRemarkInfoView = view;
        _voucherRemarkInfoView.hidden = YES;
    }
    return _voucherRemarkInfoView;
}

- (PNApartmentVoucherImageView *)voucherImgView {
    if (!_voucherImgView) {
        _voucherImgView = [[PNApartmentVoucherImageView alloc] init];
        _voucherImgView.hidden = YES;
    }
    return _voucherImgView;
}
@end
