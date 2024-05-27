//
//  GNReserveDetailViewController.m
//  SuperApp
//
//  Created by wmz on 2022/9/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNReserveDetailViewController.h"
#import "GNReserveDTO.h"
#import "GNStringUntils.h"
#import "SAInfoView.h"


@interface GNReserveDetailViewController ()
/// bg
@property (nonatomic, strong) UIImageView *bgIV;
/// titleLB
@property (nonatomic, strong) HDLabel *titleLB;
/// titleIV
@property (nonatomic, strong) UIImageView *titleIV;
///预约时间
@property (nonatomic, strong) SAInfoView *timeView;
///人数
@property (nonatomic, strong) SAInfoView *numView;
/// people
@property (nonatomic, strong) SAInfoView *peopleView;
/// phone
@property (nonatomic, strong) SAInfoView *phoneView;
/// remind
@property (nonatomic, strong) HDLabel *remindLB;
/// topLine
@property (nonatomic, strong) UIView *topLine;
/// bottomLine
@property (nonatomic, strong) UIView *bottomLine;
/// DTO
@property (nonatomic, strong) GNReserveDTO *DTO;
/// orderNo
@property (nonatomic, copy) NSString *orderNo;
@end


@implementation GNReserveDetailViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self.parameters = parameters;
    self.orderNo = parameters[@"orderNo"];
    return [super initWithRouteParameters:parameters];
}

- (void)hd_setupViews {
    if (self.parameters[@"fromReserve"]) {
        [self removeViewController:NO withoutVCNameArr:@[@"GNOrderDetailViewController"]];
    }
    self.boldTitle = GNLocalizedString(@"gn_booking_information", @"Reservation Details");
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.bgIV];
    [self.scrollViewContainer addSubview:self.titleLB];
    [self.scrollViewContainer addSubview:self.titleIV];
    [self.scrollViewContainer addSubview:self.topLine];
    [self.scrollViewContainer addSubview:self.timeView];
    [self.scrollViewContainer addSubview:self.numView];
    [self.scrollViewContainer addSubview:self.peopleView];
    [self.scrollViewContainer addSubview:self.phoneView];
    [self.scrollViewContainer addSubview:self.bottomLine];
    [self.scrollViewContainer addSubview:self.remindLB];
}

- (void)gn_getNewData {
    @HDWeakify(self)[self showloading];
    [self.DTO getOrderReservationInfoWithOrderNo:self.orderNo success:^(GNReserveRspModel *_Nonnull rspModel) {
        @HDStrongify(self) self.timeView.model.valueText = [SAGeneralUtil getDateStrWithTimeInterval:rspModel.reservationTime.doubleValue / 1000 format:@"dd/MM/yyyy HH:mm"];
        [self.timeView setNeedsUpdateContent];

        self.numView.model.valueText = GNFillEmpty(rspModel.reservationNum);
        [self.numView setNeedsUpdateContent];

        self.peopleView.model.valueText = GNFillEmpty(rspModel.reservationUser);
        [self.peopleView setNeedsUpdateContent];

        self.phoneView.model.valueText = GNFillEmpty(rspModel.reservationPhone);
        [self.phoneView setNeedsUpdateContent];

        [self dismissLoading];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self)[self dismissLoading];
    }];
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarH);
        make.left.mas_offset(kRealWidth(12));
        make.right.mas_offset(-kRealWidth(12));
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth - kRealWidth(24));
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.scrollView);
        make.top.mas_offset(kRealWidth(24));
        make.width.equalTo(self.scrollView);
    }];

    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(58));
        make.left.mas_equalTo(kRealWidth(22));
    }];

    [self.titleIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-kRealWidth(22));
        make.centerY.equalTo(self.titleLB);
    }];

    [self.topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(22));
        make.right.mas_offset(kRealWidth(-22));
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(33));
        make.height.mas_equalTo(HDAppTheme.value.gn_line);
    }];

    [self.timeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topLine);
        make.top.equalTo(self.topLine.mas_bottom).offset(kRealWidth(23));
    }];

    [self.numView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topLine);
        make.top.equalTo(self.timeView.mas_bottom).offset(kRealWidth(16));
    }];

    [self.peopleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topLine);
        make.top.equalTo(self.numView.mas_bottom).offset(kRealWidth(16));
    }];

    [self.phoneView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topLine);
        make.top.equalTo(self.peopleView.mas_bottom).offset(kRealWidth(16));
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topLine);
        make.top.equalTo(self.phoneView.mas_bottom).offset(kRealWidth(25));
        make.height.mas_equalTo(HDAppTheme.value.gn_line);
    }];

    [self.remindLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topLine);
        make.top.equalTo(self.bottomLine.mas_bottom).offset(kRealWidth(23));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(58));
    }];

    [super updateViewConstraints];
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.font gn_ForSize:16 weight:UIFontWeightHeavy];
        label.textColor = HDAppTheme.color.gn_333Color;
        label.text = GNLocalizedString(@"gn_sucessful_booking", @"Appointment successful");
        _titleLB = label;
    }
    return _titleLB;
}

- (HDLabel *)remindLB {
    if (!_remindLB) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.font gn_boldForSize:11];
        label.textColor = HDAppTheme.color.gn_999Color;
        label.numberOfLines = 0;
        label.text = GNLocalizedString(@"gn_reminder_the_appointment", @"Reminder: The appointment information only represents the estimated arrival time and will not be automatically written off");
        [GNStringUntils changeLineSpaceForLabel:label WithSpace:kRealWidth(4)];
        _remindLB = label;
    }
    return _remindLB;
}

- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = UIImageView.new;
        UIImage *image = [UIImage imageNamed:@"gn_reserve_bg"];
        _bgIV.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.3, image.size.width * 0.5, image.size.height * 0.3, image.size.width * 0.5)
                                            resizingMode:UIImageResizingModeStretch];
    }
    return _bgIV;
}

- (UIImageView *)titleIV {
    if (!_titleIV) {
        _titleIV = UIImageView.new;
        _titleIV.image = [UIImage imageNamed:@"gn_reserve_finish"];
    }
    return _titleIV;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = UIView.new;
        _topLine.backgroundColor = HDAppTheme.color.gn_lineColor;
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.gn_lineColor;
    }
    return _bottomLine;
}

- (SAInfoView *)timeView {
    if (!_timeView) {
        SAInfoView *infoView = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.contentEdgeInsets = UIEdgeInsetsZero;
        model.lineWidth = 0;
        model.keyFont = [HDAppTheme.font gn_ForSize:12];
        model.keyColor = HDAppTheme.color.gn_999Color;
        model.keyTitletEdgeInsets = UIEdgeInsetsZero;
        model.keyText = GNLocalizedString(@"gn_arrival_time", @"Arrival time");
        model.valueFont = [HDAppTheme.font gn_ForSize:12 weight:UIFontWeightMedium];
        model.valueColor = HDAppTheme.color.gn_333Color;
        model.valueTitleEdgeInsets = UIEdgeInsetsZero;
        infoView.model = model;
        _timeView = infoView;
    }
    return _timeView;
}

- (SAInfoView *)numView {
    if (!_numView) {
        SAInfoView *infoView = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.contentEdgeInsets = UIEdgeInsetsZero;
        model.lineWidth = 0;
        model.keyFont = [HDAppTheme.font gn_ForSize:12];
        model.keyColor = HDAppTheme.color.gn_999Color;
        model.keyTitletEdgeInsets = UIEdgeInsetsZero;
        model.keyText = GNLocalizedString(@"gn_numbe_booking", @"Number of reservatio");
        model.valueFont = [HDAppTheme.font gn_ForSize:12 weight:UIFontWeightMedium];
        model.valueColor = HDAppTheme.color.gn_333Color;
        model.valueTitleEdgeInsets = UIEdgeInsetsZero;
        infoView.model = model;
        _numView = infoView;
    }
    return _numView;
}

- (SAInfoView *)peopleView {
    if (!_peopleView) {
        SAInfoView *infoView = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.contentEdgeInsets = UIEdgeInsetsZero;
        model.lineWidth = 0;
        model.keyFont = [HDAppTheme.font gn_ForSize:12];
        model.keyColor = HDAppTheme.color.gn_999Color;
        model.keyTitletEdgeInsets = UIEdgeInsetsZero;
        model.keyText = GNLocalizedString(@"gn_booker", @"Booking people");
        model.valueFont = [HDAppTheme.font gn_ForSize:12 weight:UIFontWeightMedium];
        model.valueColor = HDAppTheme.color.gn_333Color;
        model.valueTitleEdgeInsets = UIEdgeInsetsZero;
        infoView.model = model;
        _peopleView = infoView;
    }
    return _peopleView;
}

- (SAInfoView *)phoneView {
    if (!_phoneView) {
        SAInfoView *infoView = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.contentEdgeInsets = UIEdgeInsetsZero;
        model.lineWidth = 0;
        model.keyFont = [HDAppTheme.font gn_ForSize:12];
        model.keyColor = HDAppTheme.color.gn_999Color;
        model.keyTitletEdgeInsets = UIEdgeInsetsZero;
        model.keyText = TNLocalizedString(@"EflnCwt2", @"手机号");
        model.valueFont = [HDAppTheme.font gn_ForSize:12 weight:UIFontWeightMedium];
        model.valueColor = HDAppTheme.color.gn_333Color;
        model.valueTitleEdgeInsets = UIEdgeInsetsZero;
        infoView.model = model;
        _phoneView = infoView;
    }
    return _phoneView;
}

- (GNReserveDTO *)DTO {
    if (!_DTO) {
        _DTO = GNReserveDTO.new;
    }
    return _DTO;
}

@end
