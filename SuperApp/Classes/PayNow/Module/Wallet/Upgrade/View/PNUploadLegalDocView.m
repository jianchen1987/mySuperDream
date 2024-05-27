//
//  PNUploadLegalDocView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/1/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUploadLegalDocView.h"
#import "HDUserInfoRspModel.h"
#import "NSDate+Extension.h"
#import "PNAccountViewModel.h"
#import "PNCommonUtils.h"
#import "PNInputItemView.h"
#import "PNPhotoInHandView.h"
#import "PNStepTipsView.h"
#import "PNUploadIDImageView.h"
#import "PNWalletController.h"
#import "SADatePickerViewController.h"
#import "SAInfoView.h"


@interface PNUploadLegalDocView () <SADatePickerViewDelegate, PNInputItemViewDelegate>
@property (nonatomic, strong) PNAccountViewModel *viewModel;

@property (nonatomic, strong) SAInfoView *legalTypeInfoView;           //证件类型
@property (nonatomic, strong) PNInputItemView *legalNumberInfoView;    //证件号码
@property (nonatomic, strong) SAInfoView *legalExpirationDateInfoView; //证件有效期
@property (nonatomic, strong) SAInfoView *visaExpirationDateInfoView;  //签证到期日期

@property (nonatomic, strong) PNPhotoInHandView *inHandView;
@property (nonatomic, strong) PNStepTipsView *stepView;
@property (nonatomic, strong) SAOperationButton *confirmButton;

/// 记录当前哪个在使用 日期选择控件 【1 证件有效期】【2 签证到期日】
@property (nonatomic, assign) NSInteger currentSelectDateType;
@end


@implementation PNUploadLegalDocView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    [self ruleLimit];
}

#pragma mark
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addNotification];

    self.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.stepView];
    self.scrollViewContainer.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;

    [self.scrollViewContainer addSubview:self.legalTypeInfoView];
    [self.scrollViewContainer addSubview:self.legalNumberInfoView];
    [self.scrollViewContainer addSubview:self.legalExpirationDateInfoView];
    [self.scrollViewContainer addSubview:self.visaExpirationDateInfoView];
    [self.scrollViewContainer addSubview:self.uploadIDImageView];
    [self.scrollViewContainer addSubview:self.inHandView];
    [self addSubview:self.confirmButton];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.mas_equalTo(self.confirmButton.mas_top).offset(kRealWidth(-15));
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.stepView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.scrollViewContainer.mas_top);
    }];

    [self.legalTypeInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.stepView.mas_bottom);
    }];

    [self.legalNumberInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.legalTypeInfoView.mas_bottom);
        make.height.equalTo(@(kRealWidth(50)));
    }];

    [self.legalExpirationDateInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.legalNumberInfoView.mas_bottom);
    }];

    if (!self.visaExpirationDateInfoView.hidden) {
        [self.visaExpirationDateInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.scrollViewContainer);
            make.top.mas_equalTo(self.legalExpirationDateInfoView.mas_bottom);
        }];
    }

    [self.uploadIDImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scrollViewContainer);
        if (self.visaExpirationDateInfoView.hidden) {
            make.top.mas_equalTo(self.legalExpirationDateInfoView.mas_bottom);
        } else {
            make.top.mas_equalTo(self.visaExpirationDateInfoView.mas_bottom);
        }
    }];

    [self.inHandView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.uploadIDImageView.mas_bottom);
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(30)));
    }];
    [super updateConstraints];
}

#pragma mark
- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.refreshFlag = !self.refreshFlag;
    }];
}

- (void)setRefreshFlag:(BOOL)refreshFlag {
    _refreshFlag = refreshFlag;
    HDLog(@"refresh legal");

    if (self.cardType > 0) {
        self.legalTypeInfoView.model.valueText = [PNCommonUtils getPapersNameByPapersCode:self.cardType];
        self.legalTypeInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        [self.legalTypeInfoView setNeedsUpdateContent];
    }

    if (WJIsStringNotEmpty(self.cardNum)) {
        self.legalNumberInfoView.model.value = self.cardNum;
        [self.legalNumberInfoView update];
    }

    if (self.expirationTime > 0) {
        NSString *tempStr = [PNCommonUtils dateSecondToDate:self.expirationTime / 1000 dateFormat:@"dd/MM/yyyy"];
        if ([tempStr isEqualToString:PNSPECIALTIMEFOREVER]) {
            self.legalExpirationDateInfoView.model.valueText = PNLocalizedString(@"Permanently_valid", @"永久有效期");
        } else {
            self.legalExpirationDateInfoView.model.valueText = tempStr;
        }
        self.legalExpirationDateInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        [self.legalExpirationDateInfoView setNeedsUpdateContent];
    }

    [self restPassport];

    if (self.visaExpirationTime > 0) {
        self.visaExpirationDateInfoView.model.valueText = [PNCommonUtils dateSecondToDate:self.visaExpirationTime / 1000 dateFormat:@"dd/MM/yyyy"];
        self.visaExpirationDateInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        [self.visaExpirationDateInfoView setNeedsUpdateContent];
    }

    if (WJIsStringNotEmpty(self.idCardFrontUrl)) {
        self.uploadIDImageView.leftURL = self.idCardFrontUrl;
    }

    if (WJIsStringNotEmpty(self.idCardBackUrl)) {
        self.uploadIDImageView.rightURL = self.idCardBackUrl;
    }

    if (WJIsStringNotEmpty(self.cardHandUrl)) {
        self.inHandView.urlStr = self.cardHandUrl;
    }
    self.inHandView.cardType = self.cardType;
}

#pragma mark
- (void)restPassport {
    if (![self.country isEqualToString:@"KH"]) {
        if (self.cardType == PNPapersTypePassport) {
            self.uploadIDImageView.leftTitleStr = PNLocalizedString(@"pn_upload_passport_front_page", @"点击上传护照首页照片");
            self.uploadIDImageView.rightTitleStr = PNLocalizedString(@"pn_upload_valid_Visa_page_", @"请上传有效签证页");
        }

        if (self.cardType == PNPapersTypeDrivingLince) {
            self.uploadIDImageView.leftTitleStr = @"";
            self.uploadIDImageView.rightTitleStr = PNLocalizedString(@"pn_upload_valid_Visa_page_", @"请上传有效签证页");
        }

        self.uploadIDImageView.isHiddeRightView = NO;
    } else {
        if (self.cardType == PNPapersTypePassport) {
            self.uploadIDImageView.leftTitleStr = PNLocalizedString(@"pn_upload_passport_front_page", @"点击上传护照首页照片");
            self.uploadIDImageView.isHiddeRightView = YES;
        } else {
            self.uploadIDImageView.leftTitleStr = @"";
            self.uploadIDImageView.rightTitleStr = @"";
            self.uploadIDImageView.isHiddeRightView = NO;
        }
    }

    /// 非“柬埔寨”，且证件类型选择了“护照” “柬埔寨驾照”，则增加必填项【签证到期日】 否则不展示该字段；
    if (![self.country isEqualToString:@"KH"] && (self.cardType == PNPapersTypePassport || self.cardType == PNPapersTypeDrivingLince)) {
        self.visaExpirationDateInfoView.hidden = NO;
    } else {
        self.visaExpirationDateInfoView.hidden = YES;
        self.visaExpirationTime = 0;
    }

    [self reSetSelectActionItem];
}

/// 如果用户选择的国家为【柬埔寨】，且证件类型为【身份证】，则点击【证件照反面】下拉选项新增一个【使用默认照片】选项
- (void)reSetSelectActionItem {
    if ([self.country isEqualToString:@"KH"] && self.cardType == PNPapersTypeIDCard) {
        self.uploadIDImageView.isCanSelectDefaultPhoto = YES;
    } else {
        self.uploadIDImageView.isCanSelectDefaultPhoto = NO;
    }
}

/// 证件类型
- (void)handleSelectLegalType {
    @HDWeakify(self);
    void (^continueUpdateView)(PNPapersType) = ^(PNPapersType type) {
        @HDStrongify(self);
        self.cardType = type;
        self.inHandView.cardType = self.cardType;
        self.legalTypeInfoView.model.valueText = [PNCommonUtils getPapersNameByPapersCode:type];
        self.legalTypeInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        self.legalTypeInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15M;
        [self.legalTypeInfoView setNeedsUpdateContent];

        [self ruleLimit];

        [self restPassport];
        [self setNeedsUpdateConstraints];
    };

    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];

    HDActionSheetViewButton *IDCARDBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"PAPER_TYPE_IDCARD", @"身份证") type:HDActionSheetViewButtonTypeCustom
                                                                          handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                              [sheetView dismiss];
                                                                              continueUpdateView(PNPapersTypeIDCard);
                                                                          }];
    HDActionSheetViewButton *PASSPORTBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"PAPER_TYPE_PASSPORT", @"护照") type:HDActionSheetViewButtonTypeCustom
                                                                            handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                                [sheetView dismiss];
                                                                                continueUpdateView(PNPapersTypePassport);
                                                                            }];
    HDActionSheetViewButton *licenseBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"PAPER_TYPE_Driving_license", @"柬埔寨驾照") type:HDActionSheetViewButtonTypeCustom
                                                                           handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                               [sheetView dismiss];
                                                                               continueUpdateView(PNPapersTypeDrivingLince);
                                                                           }];
    HDActionSheetViewButton *PoliceBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"PAPER_TYPE_Police", @"警察证/公务员证") type:HDActionSheetViewButtonTypeCustom
                                                                          handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                              [sheetView dismiss];
                                                                              continueUpdateView(PNPapersTypepolice);
                                                                          }];
    if (![self.country isEqualToString:@"KH"]) {
        [sheetView addButtons:@[PASSPORTBTN, licenseBTN]];
    } else {
        [sheetView addButtons:@[IDCARDBTN, PASSPORTBTN, licenseBTN, PoliceBTN]];
    }

    [sheetView show];
}

- (void)handleSelecLegalExpDate {
    void (^continueUpdateView)(NSString *) = ^(NSString *data) {
        if ([data isEqualToString:PNLocalizedString(@"Permanently_valid", @"永久有效期")]) {
            ///  永久有效传这个 9999/12/31 23:59:59
            self.expirationTime = [NSDate dateStringddMMyyyyHHmmss:[PNSPECIALTIMEFOREVER stringByAppendingString:@" 23:59:59"]] * 1000;

            self.legalExpirationDateInfoView.model.valueText = data;
            self.legalExpirationDateInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
            self.legalExpirationDateInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15M;
            [self.legalExpirationDateInfoView setNeedsUpdateContent];
            [self ruleLimit];
        } else {
            [self selectExpDate:1];
        }
    };

    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];
    HDActionSheetViewButton *dateTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"Select_date", @"选择日期") type:HDActionSheetViewButtonTypeCustom
                                                                       handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                           [sheetView dismiss];
                                                                           continueUpdateView(PNLocalizedString(@"Select_date", @"选择日期"));
                                                                       }];
    HDActionSheetViewButton *foreverBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"Permanently_valid", @"永久有效期") type:HDActionSheetViewButtonTypeCustom
                                                                           handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                               [sheetView dismiss];
                                                                               continueUpdateView(PNLocalizedString(@"Permanently_valid", @"永久有效期"));
                                                                           }];

    [sheetView addButtons:@[dateTN, foreverBTN]];
    [sheetView show];
}

/// 日期选择
- (void)selectExpDate:(NSInteger)type {
    self.currentSelectDateType = type;

    SADatePickerViewController *vc = [[SADatePickerViewController alloc] init];
    vc.datePickStyle = SADatePickerStyleDMY;

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMdd"];
    [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];

    NSDate *minDate = [NSDate date];
    NSDate *maxDate = [minDate dateByAddingTimeInterval:500 * 365 * 24 * 60 * 60.0];

    vc.maxDate = maxDate;
    vc.minDate = minDate;
    vc.delegate = self;

    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [self.viewController.navigationController presentViewController:vc animated:YES completion:nil];

    NSString *currDateStr = [NSDate ddMMYYYYString:[NSDate date]];
    if (self.currentSelectDateType == 1) {
        if (self.expirationTime > 0) {
            currDateStr = [PNCommonUtils dateSecondToDate:self.expirationTime / 1000 dateFormat:@"dd/MM/yyyy"];
        }
    } else {
        if (self.visaExpirationTime > 0) {
            currDateStr = [PNCommonUtils dateSecondToDate:self.visaExpirationTime / 1000 dateFormat:@"dd/MM/yyyy"];
        }
    }
    [fmt setDateFormat:@"dd/MM/yyyy"];
    NSDate *currDate = [fmt dateFromString:currDateStr];
    if (currDate) {
        [vc setCurrentDate:currDate];
    }
}

#pragma mark SADatePickerViewDelegate
/// 点击确定选中日期
- (void)datePickerView:(SADatePickerView *)pickView didSelectDate:(NSString *)date {
    NSString *dateStr = [date stringByAppendingFormat:@" 00:00:00"];
    if (self.currentSelectDateType == 1) {
        self.expirationTime = [NSDate dateStringddMMyyyyHHmmss:dateStr] * 1000;
        self.legalExpirationDateInfoView.model.valueText = date;
        self.legalExpirationDateInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        self.legalExpirationDateInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15M;
        [self.legalExpirationDateInfoView setNeedsUpdateContent];
    } else {
        self.visaExpirationTime = [NSDate dateStringddMMyyyyHHmmss:dateStr] * 1000;
        self.visaExpirationDateInfoView.model.valueText = date;
        self.visaExpirationDateInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        self.visaExpirationDateInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15M;
        [self.visaExpirationDateInfoView setNeedsUpdateContent];
    }
    [self ruleLimit];
}

#pragma mark - 按钮点亮限制
- (void)ruleLimit {
    /// 能来到这个界面，说明上一个界面的数据校验过了，那么这个界面只针对这个界面的数据进行校验即可
    self.cardNum = [self.legalNumberInfoView.inputText hd_trim];

    /// “柬埔寨”，且证件类型选择了“护照”，则该项为非必填项[idCardBackUrl]
    if ([self.country isEqualToString:@"KH"] && self.cardType == PNPapersTypePassport) {
        if (self.cardType > 0 && WJIsStringNotEmpty(self.cardNum) && self.expirationTime > 0 && WJIsStringNotEmpty(self.idCardFrontUrl)) {
            self.confirmButton.enabled = YES;
        } else {
            self.confirmButton.enabled = NO;
        }
    } else {
        /// 非“柬埔寨”，且证件类型选择了“护照”，则增加必填项【签证到期日】
        if (![self.country isEqualToString:@"KH"] && self.cardType == PNPapersTypePassport) {
            if (self.cardType > 0 && WJIsStringNotEmpty(self.cardNum) && self.expirationTime > 0 && WJIsStringNotEmpty(self.idCardFrontUrl) && WJIsStringNotEmpty(self.idCardBackUrl)
                && self.visaExpirationTime > 0) {
                self.confirmButton.enabled = YES;
            } else {
                self.confirmButton.enabled = NO;
            }
        } else {
            if (self.cardType > 0 && WJIsStringNotEmpty(self.cardNum) && self.expirationTime > 0 && WJIsStringNotEmpty(self.idCardFrontUrl) && WJIsStringNotEmpty(self.idCardBackUrl)) {
                self.confirmButton.enabled = YES;
            } else {
                self.confirmButton.enabled = NO;
            }
        }
    }
}

- (void)postAction {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.headUrl forKey:@"headUrl"];

    if (WJIsStringNotEmpty(self.firstName) && ![self.firstName containsString:@"***"]) {
        [dict setValue:self.firstName forKey:@"name"]; // name    名字
    }

    if (WJIsStringNotEmpty(self.lastName) && ![self.lastName containsString:@"***"]) {
        [dict setValue:self.lastName forKey:@"surname"]; // surname  姓氏
    }

    [dict setValue:@(self.sex) forKey:@"sex"];
    [dict setValue:@(self.birthday) forKey:@"birthday"];
    [dict setValue:self.country forKey:@"country"];
    [dict setValue:@(self.cardType) forKey:@"cardType"];

    if (WJIsStringNotEmpty(self.cardNum) && ![self.cardNum containsString:@"***"]) {
        [dict setValue:self.cardNum forKey:@"cardNum"];
    }

    [dict setValue:@(self.expirationTime) forKey:@"expirationTime"];
    [dict setValue:self.idCardFrontUrl forKey:@"idCardFrontUrl"];
    [dict setValue:self.idCardBackUrl forKey:@"idCardBackUrl"];

    if (WJIsStringNotEmpty(self.cardHandUrl)) {
        [dict setValue:self.cardHandUrl forKey:@"cardHandUrl"];
    }

    if (self.visaExpirationTime > 0) {
        [dict setValue:@(self.visaExpirationTime) forKey:@"visaExpirationTime"];
    }

    /// 两步走的 KYC升级 才需要特意传这个key
    [dict setValue:@"APPLY" forKey:@"dataOrigin"];

    !self.clickButtonBlock ?: self.clickButtonBlock(dict);
}

#pragma mark
- (PNStepTipsView *)stepView {
    if (!_stepView) {
        _stepView = [[PNStepTipsView alloc] init];
        _stepView.step = 2;
    }
    return _stepView;
}

- (SAOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:PNLocalizedString(@"BUTTON_TITLE_SUBMIT", @"提交") forState:0];
        _confirmButton.enabled = NO;
        @HDWeakify(self);
        [_confirmButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            HDLog(@"click");
            [self postAction];
        }];

        _confirmButton.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(20)];
        };
    }
    return _confirmButton;
}

- (PNInputItemView *)legalNumberInfoView {
    if (!_legalNumberInfoView) {
        _legalNumberInfoView = [[PNInputItemView alloc] init];
        _legalNumberInfoView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.title = PNLocalizedString(@"Legal_number", @"证件号");
        model.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        model.isWhenEidtClearValue = YES;
        _legalNumberInfoView.model = model;
    }
    return _legalNumberInfoView;
}

- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyColor = HDAppTheme.color.G1;
    model.valueColor = HDAppTheme.color.G3;
    model.keyText = key;
    model.enableTapRecognizer = true;
    return model;
}

- (SAInfoViewModel *)infoViewModelWithArrowImageAndKey:(NSString *)key {
    SAInfoViewModel *model = [self infoViewModelWithKey:key];
    model.rightButtonImage = [UIImage imageNamed:@"pn_arrow_gray_small"];
    return model;
}

- (SAInfoView *)legalTypeInfoView {
    if (!_legalTypeInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"Legal_type", @"证件类型")];
        model.valueText = PNLocalizedString(@"please_select", @"请选择");
        model.valueFont = HDAppTheme.PayNowFont.standard15M;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(18), kRealWidth(15), kRealWidth(18), kRealWidth(15));
        model.lineColor = HDAppTheme.PayNowColor.cECECEC;
        model.backgroundColor = [UIColor whiteColor];
        model.eventHandler = ^{
            [self handleSelectLegalType];
        };
        view.model = model;
        _legalTypeInfoView = view;
    }
    return _legalTypeInfoView;
}

- (SAInfoView *)legalExpirationDateInfoView {
    if (!_legalExpirationDateInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"Legal_expiration_date", @"证件有效期")];
        model.valueText = PNLocalizedString(@"please_select", @"请选择");
        model.valueFont = HDAppTheme.PayNowFont.standard15M;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(18), kRealWidth(15), kRealWidth(18), kRealWidth(15));
        model.lineColor = HDAppTheme.PayNowColor.cECECEC;
        model.backgroundColor = [UIColor whiteColor];
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self handleSelecLegalExpDate];
        };
        view.model = model;
        _legalExpirationDateInfoView = view;
    }
    return _legalExpirationDateInfoView;
}

- (SAInfoView *)visaExpirationDateInfoView {
    if (!_visaExpirationDateInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"visa_expiration_date", @"签证到期日")];
        model.valueText = PNLocalizedString(@"please_select", @"请选择");
        model.valueFont = HDAppTheme.PayNowFont.standard15M;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(18), kRealWidth(15), kRealWidth(18), kRealWidth(15));
        model.lineColor = HDAppTheme.PayNowColor.cECECEC;
        model.backgroundColor = [UIColor whiteColor];
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self selectExpDate:2];
        };
        view.model = model;
        _visaExpirationDateInfoView = view;
        _visaExpirationDateInfoView.hidden = YES;
    }
    return _visaExpirationDateInfoView;
}

- (PNUploadIDImageView *)uploadIDImageView {
    if (!_uploadIDImageView) {
        _uploadIDImageView = [[PNUploadIDImageView alloc] init];
        @HDWeakify(self);
        _uploadIDImageView.refreshLeftResultBlock = ^(NSString *_Nonnull leftURL) {
            @HDStrongify(self);
            self.idCardFrontUrl = leftURL;
            [self ruleLimit];
        };
        _uploadIDImageView.refreshRightResultBlock = ^(NSString *_Nonnull rightURL) {
            @HDStrongify(self);
            self.idCardBackUrl = rightURL;
            [self ruleLimit];
        };
    }
    return _uploadIDImageView;
}

- (PNPhotoInHandView *)inHandView {
    if (!_inHandView) {
        _inHandView = [[PNPhotoInHandView alloc] init];
        @HDWeakify(self);
        _inHandView.refreshResultBlock = ^(NSString *_Nonnull url) {
            @HDStrongify(self);
            self.cardHandUrl = url;
            [self ruleLimit];
        };
    }
    return _inHandView;
}
@end
