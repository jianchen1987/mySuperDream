//
//  GNReserveView.m
//  SuperApp
//
//  Created by wmz on 2022/9/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNReserveView.h"
#import "GNReserveCalanderView.h"
#import "GNReserveDTO.h"
#import "GNReserveEditView.h"
#import "GNReserveViewModel.h"
#import "HDMediator+GroupOn.h"
#import "SAPhoneFormatValidator.h"


@interface GNReserveView ()
/// editView
@property (nonatomic, strong) GNReserveEditView *editView;
/// calanderView
@property (nonatomic, strong) GNReserveCalanderView *calanderView;
/// remindLB
@property (nonatomic, strong) HDLabel *remindLB;
/// remindLB
@property (nonatomic, strong) HDUIButton *confirmBTN;
/// viewModel
@property (nonatomic, strong) GNReserveViewModel *viewModel;
/// DTO
@property (nonatomic, strong) GNReserveDTO *DTO;
///营业时间
@property (nonatomic, strong) GNReserveBuinessModel *buinessRspModel;

@end


@implementation GNReserveView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    ;
    self.scrollViewContainer.backgroundColor = HDAppTheme.color.gn_whiteColor;
    ;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.editView];
    [self.scrollViewContainer addSubview:self.calanderView];
    [self.scrollViewContainer addSubview:self.remindLB];
    [self.scrollViewContainer addSubview:self.confirmBTN];
    [self.scrollViewContainer setFollowKeyBoardConfigEnable:true margin:0 refView:nil];
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)gn_getNewData {
    @HDWeakify(self)[self showloading];
    [self.DTO getStoreNoBuinessTime:self.viewModel.storeNo success:^(GNReserveBuinessModel *_Nonnull rspModel) {
        @HDStrongify(self)[self dismissLoading];
        self.buinessRspModel = rspModel;
        self.editView.selectModel = self.calanderView.selectModel;
        self.editView.businessHours = [NSArray arrayWithArray:self.buinessRspModel.businessHours];
        self.calanderView.businessDay = rspModel.businessDay;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self)[self dismissLoading];
    }];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.calanderView keyPath:@"selectModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.editView.selectModel = self.calanderView.selectModel;
        self.editView.businessHours = [NSArray arrayWithArray:self.buinessRspModel.businessHours];
        self.editView.selectTime = nil;
    }];

    [self.KVOController hd_observe:self.editView keyPath:@"checkEnable" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.confirmBTN.enabled = self.editView.checkEnable;
        self.confirmBTN.layer.backgroundColor = (self.editView.checkEnable ? HDAppTheme.color.gn_mainColor.CGColor : [HDAppTheme.color.gn_mainColor colorWithAlphaComponent:0.3].CGColor);
    }];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.calanderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];

    [self.editView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.calanderView.mas_bottom).offset(kRealWidth(8));
    }];

    [self.remindLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(16));
        make.right.mas_equalTo(-kRealWidth(16));
        make.top.equalTo(self.editView.mas_bottom).offset(kRealWidth(8));
    }];

    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.remindLB.mas_bottom).offset(kRealWidth(20));
        make.bottom.mas_equalTo(-kRealWidth(8) - kiPhoneXSeriesSafeBottomHeight);
        make.height.mas_equalTo(kRealWidth(44));
    }];

    [super updateConstraints];
}

///提交
- (void)confirmAction {
    @HDWeakify(self) NSString *phoneNo = [NSString stringWithFormat:@"%@", self.editView.phoneTF.text];
    if (![SAPhoneFormatValidator isCambodia:phoneNo]) {
        [self.editView.phoneTF becomeFirstResponder];
        [NAT showToastWithTitle:nil content:SALocalizedString(@"adress_tips_phone_format_error", @"请输入正确的号码") type:HDTopToastTypeError];
        return;
    }
    if (!self.viewModel.reserveModel) {
        self.viewModel.reserveModel = GNReserveRspModel.new;
    }
    NSString *timeStr =
        [NSString stringWithFormat:@"%zd-%zd-%zd %@:00", self.calanderView.selectModel.wYear, self.calanderView.selectModel.wMonth, self.calanderView.selectModel.wDay, self.editView.selectTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *myDate = [dateFormatter dateFromString:timeStr];
    self.viewModel.reserveModel.reservationTime = [NSString stringWithFormat:@"%.0f", myDate.timeIntervalSince1970 * 1000];
    self.viewModel.reserveModel.reservationNum = @(self.editView.count).stringValue;
    self.viewModel.reserveModel.reservationUser = self.editView.bookTF.text;
    self.viewModel.reserveModel.reservationPhone = phoneNo;
    ///从订单详情过来的 提交预约
    if (self.viewModel.orderNo) {
        [self showloading];
        [self.DTO orderReservationWithStoreNo:self.viewModel.storeNo orderNo:self.viewModel.orderNo reservationTime:self.viewModel.reserveModel.reservationTime
            reservationNum:self.viewModel.reserveModel.reservationNum.integerValue
            reservationUser:self.viewModel.reserveModel.reservationUser
            reservationPhone:self.viewModel.reserveModel.reservationPhone success:^(SARspModel *_Nonnull rspModel) {
                @HDStrongify(self)[self dismissLoading];
                if (self.callback)
                    self.callback(self.viewModel.reserveModel);
                [HDMediator.sharedInstance navigaveToGNReserveDetailViewController:@{@"orderNo": self.viewModel.orderNo, @"fromReserve": @"fromReserve"}];
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                @HDStrongify(self)[self dismissLoading];
            }];
    } else {
        if (self.callback)
            self.callback(self.viewModel.reserveModel);
        [self.viewController.navigationController popViewControllerAnimated:YES];
    }
}

- (HDLabel *)remindLB {
    if (!_remindLB) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.font gn_ForSize:12];
        label.numberOfLines = 0;
        label.textColor = HDAppTheme.color.gn_999Color;
        label.text = GNLocalizedString(@"gn_reminder_the_appointment", @"Reminder: The appointment information only represents the estimated arrival time and will not be automatically written off");
        [GNStringUntils changeLineSpaceForLabel:label WithSpace:kRealWidth(4)];
        _remindLB = label;
    }
    return _remindLB;
}

- (HDUIButton *)confirmBTN {
    if (!_confirmBTN) {
        _confirmBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _confirmBTN.titleLabel.font = [HDAppTheme.font gn_boldForSize:16];
        _confirmBTN.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
        [_confirmBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmBTN.layer.cornerRadius = kRealWidth(22);
        [_confirmBTN setTitle:GNLocalizedString(@"gn_confirm_booking", @"Confirm appointment") forState:UIControlStateNormal];
        @HDWeakify(self)[_confirmBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self confirmAction];
        }];
    }
    return _confirmBTN;
}

- (GNReserveEditView *)editView {
    if (!_editView) {
        _editView = [[GNReserveEditView alloc] initWithViewModel:self.viewModel];
    }
    return _editView;
}

- (GNReserveCalanderView *)calanderView {
    if (!_calanderView) {
        _calanderView = [[GNReserveCalanderView alloc] initWithViewModel:self.viewModel];
    }
    return _calanderView;
}

- (GNReserveViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = GNReserveViewModel.new;
    }
    return _viewModel;
}

- (GNReserveDTO *)DTO {
    if (!_DTO) {
        _DTO = GNReserveDTO.new;
    }
    return _DTO;
}

- (BOOL)gn_firstGetNewData {
    return YES;
}

@end
