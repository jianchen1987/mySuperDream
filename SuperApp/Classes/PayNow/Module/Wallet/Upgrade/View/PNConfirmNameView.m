//
//  PNConfirmNameView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/1/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNConfirmNameView.h"
#import "HDCountrySectionModel.h"
#import "HDUserInfoRspModel.h"
#import "NSDate+Extension.h"
#import "NationalityOptionController.h"
#import "PNAccountViewModel.h"
#import "PNCommonUtils.h"
#import "PNInputItemView.h"
#import "PNStepTipsView.h"
#import "SADatePickerViewController.h"
#import "SAInfoView.h"
#import "SAWindowManager.h"


@interface PNConfirmNameView () <PNInputItemViewDelegate, SADatePickerViewDelegate>
@property (nonatomic, strong) PNAccountViewModel *viewModel;
@property (nonatomic, strong) NSArray<HDCountrySectionModel *> *countryModels;

@property (nonatomic, strong) PNStepTipsView *stepView;
/// 用户头像
@property (nonatomic, strong) SAInfoView *picInfoView;
@property (nonatomic, strong) UIView *bgView;
/// 名字
@property (nonatomic, strong) PNInputItemView *firstNameInputView;
/// 姓
@property (nonatomic, strong) PNInputItemView *lastNameInputView;
/// 性别
@property (nonatomic, strong) SAInfoView *sexInfoView;
/// 出生日期
@property (nonatomic, strong) SAInfoView *birthdayInfoView;
/// 国籍
@property (nonatomic, strong) SAInfoView *countryInfoView;
@property (nonatomic, strong) UIImageView *tipsIconImgView;
@property (nonatomic, strong) SALabel *tipsLabel;
/// 下一步
@property (nonatomic, strong) SAOperationButton *nextButton;

@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, assign) PNSexType sex;
@property (nonatomic, assign) NSInteger birthday;
@property (nonatomic, copy) NSString *country; // code

@end


@implementation PNConfirmNameView

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

    [self.scrollViewContainer addSubview:self.bgView];
    [self.scrollViewContainer addSubview:self.picInfoView];

    [self.bgView addSubview:self.firstNameInputView];
    [self.bgView addSubview:self.lastNameInputView];

    [self.bgView addSubview:self.sexInfoView];
    [self.bgView addSubview:self.birthdayInfoView];
    [self.bgView addSubview:self.countryInfoView];
    [self.scrollViewContainer addSubview:self.tipsIconImgView];
    [self.scrollViewContainer addSubview:self.tipsLabel];
    [self addSubview:self.nextButton];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.mas_equalTo(self.nextButton.mas_top).offset(kRealWidth(-15));
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.stepView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.scrollViewContainer.mas_top);
    }];

    [self.picInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stepView.mas_bottom);
        make.left.equalTo(self.bgView.mas_left);
        make.right.equalTo(self.bgView.mas_right);
    }];

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picInfoView.mas_bottom).offset(kRealWidth(5));
        make.left.right.equalTo(self.scrollViewContainer);
        make.bottom.equalTo(self.countryInfoView.mas_bottom);
    }];

    [self.lastNameInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.bgView.mas_top);
        make.height.equalTo(@(kRealWidth(50)));
    }];

    [self.firstNameInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.lastNameInputView.mas_bottom);
        make.height.equalTo(@(kRealWidth(50)));
    }];

    [self.sexInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left);
        make.right.equalTo(self.bgView.mas_right);
        make.height.mas_equalTo(kRealWidth(50));
        make.top.mas_equalTo(self.firstNameInputView.mas_bottom);
    }];

    [self.birthdayInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left);
        make.right.equalTo(self.bgView.mas_right);
        make.height.mas_equalTo(kRealWidth(50));
        make.top.mas_equalTo(self.sexInfoView.mas_bottom);
    }];

    [self.countryInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left);
        make.right.equalTo(self.bgView.mas_right);
        make.height.mas_equalTo(kRealWidth(50));
        make.top.mas_equalTo(self.birthdayInfoView.mas_bottom);
    }];

    [self.tipsIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.tipsIconImgView.image.size);
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.countryInfoView.mas_bottom).offset(kRealWidth(13));
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipsIconImgView.mas_right).offset(kRealWidth(5));
        make.top.mas_equalTo(self.countryInfoView.mas_bottom).offset(kRealWidth(11));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [self.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
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

    [self.viewModel getCurrentDate];
}

- (void)setRefreshFlag:(BOOL)refreshFlag {
    _refreshFlag = refreshFlag;

    HDLog(@"refresh confirm");
    HDUserInfoRspModel *user = self.viewModel.userInfoModel;
    self.picInfoView.model.valueImageURL = user.headUrl;
    self.headUrl = user.headUrl;
    [self.picInfoView setNeedsUpdateContent];

    self.lastNameInputView.model.value = user.lastName;
    self.lastName = user.lastName;
    [self.lastNameInputView update];

    self.firstNameInputView.model.value = user.firstName;
    self.firstName = user.firstName;
    [self.firstNameInputView update];

    if (user.sex > 0) {
        self.sexInfoView.model.valueText = [PNCommonUtils getSexBySexCode:user.sex];
        self.sexInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        self.sexInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15M;
        [self.sexInfoView setNeedsUpdateContent];
    }
    self.sex = user.sex;

    NSString *tempBirthday = [NSString stringWithFormat:@"%zd", user.birthday];
    if (WJIsStringNotEmpty(tempBirthday) && user.birthday) {
        self.birthdayInfoView.model.valueText = [PNCommonUtils dateSecondToDate:user.birthday / 1000 dateFormat:@"dd/MM/yyyy"];
        self.birthdayInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        self.birthdayInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15M;
        [self.birthdayInfoView setNeedsUpdateContent];
    }
    self.birthday = user.birthday;

    if (WJIsStringNotEmpty(user.country)) {
        self.countryInfoView.model.valueText = [self getCountryName:user.country];
        self.countryInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        self.countryInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15M;
        [self.countryInfoView setNeedsUpdateContent];
    }
    self.country = user.country;

    [self.birthdayInfoView setNeedsUpdateContent];

    [self ruleLimit];
}

- (void)nextAction {
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"dd/MM/yyyy"];
    [fm setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    NSString *dateString = self.birthdayInfoView.model.valueText;
    NSDate *birthDay = [fm dateFromString:dateString];
    NSInteger age = 0;

    if (WJIsStringNotEmpty(self.viewModel.currentDateStr)) {
        age = [PNCommonUtils getDiffenrenceYearByDate_age:dateString date2:self.viewModel.currentDateStr];
    } else {
        age = [PNCommonUtils getDiffenrenceYearByDate:birthDay];
    }

    if (age < 18) {
        [NAT showToastWithTitle:nil content:PNLocalizedString(@"ALERT_MSG_AUTHEN_AGE_18_LIMIT", @"根据NBC要求，未满18周岁不支持账户升级") type:HDTopToastTypeWarning];
        [SATalkingData trackEvent:@"用户年龄校验失败" label:@"年龄" parameters:@{
            @"用户选择日期年龄[升级]":
                [NSString stringWithFormat:@"%@-%@ -%@", dateString, [NSDate dateSecondToDate:[[NSDate date] timeIntervalSince1970] DateFormat:@"yyyy-MM-dd"], self.viewModel.currentDateStr]
        }];
        return;
    }

    if (18 == age) {
        NSString *currentMD = @"";
        if (WJIsStringNotEmpty(self.viewModel.currentDateStr)) {
            NSDate *md = [fm dateFromString:self.viewModel.currentDateStr];
            currentMD = [PNCommonUtils getDateStrByFormat:@"MMdd" withDate:md];
        } else {
            currentMD = [PNCommonUtils getCurrentDateStrByFormat:@"MMdd"];
        }
        NSString *bithMD = [PNCommonUtils getDateStrByFormat:@"MMdd" withDate:birthDay];
        if (bithMD.integerValue >= currentMD.integerValue) {
            [NAT showToastWithTitle:nil content:PNLocalizedString(@"ALERT_MSG_AUTHEN_AGE_18_LIMIT", @"根据NBC要求，未满18周岁不支持账户升级") type:HDTopToastTypeWarning];

            [SATalkingData trackEvent:@"用户年龄校验失败" label:@"年龄-月份" parameters:@{
                @"用户选择日期月份[升级]":
                    [NSString stringWithFormat:@"%@-%@ -%@", dateString, [NSDate dateSecondToDate:[[NSDate date] timeIntervalSince1970] DateFormat:@"yyyy-MM-dd"], self.viewModel.currentDateStr]
            }];
            return;
        }
    }

    self.lastName = [self.lastNameInputView.inputText hd_trim].uppercaseString;
    self.firstName = [self.firstNameInputView.inputText hd_trim].uppercaseString;

    [HDMediator.sharedInstance navigaveToPayNowUpgradeAccountVC:@{
        @"step": @(2),
        @"needCall": @(NO),
        @"headUrl": self.headUrl,
        @"lastName": self.lastName,
        @"firstName": self.firstName,
        @"sex": @(self.sex),
        @"birthday": @(self.birthday),
        @"country": self.country,
        @"userInfo": [self.viewModel.userInfoModel yy_modelToJSONObject]
    }];
}

#pragma mark
/// 性别选择
- (void)handleSelectGender {
    [self endEditing:YES];
    
    void (^continueUpdateView)(PNSexType) = ^(PNSexType type) {
        self.sex = type;
        self.sexInfoView.model.valueText = [PNCommonUtils getSexBySexCode:type];
        self.sexInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        self.sexInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15M;
        [self.sexInfoView setNeedsUpdateContent];
        [self ruleLimit];
    };

    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];

    HDActionSheetViewButton *maleBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"SEX_TYPE_MALE", @"男性") type:HDActionSheetViewButtonTypeCustom
                                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                            [sheetView dismiss];
                                                                            continueUpdateView(PNSexTypeMen);
                                                                        }];
    HDActionSheetViewButton *femaleBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"SEX_TYPE_FEMALE", @"女性") type:HDActionSheetViewButtonTypeCustom
                                                                          handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                              [sheetView dismiss];
                                                                              continueUpdateView(PNSexTypeWomen);
                                                                          }];
    [sheetView addButtons:@[maleBTN, femaleBTN]];
    [sheetView show];
}

/// 日期选择
- (void)handleSelectBirthday {
    
    [self endEditing:YES];
    
    
    SADatePickerViewController *vc = [[SADatePickerViewController alloc] init];
    vc.datePickStyle = SADatePickerStyleDMY;

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMdd"];
    [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];

    // 生日不要超过今天
    NSDate *maxDate = [NSDate date];
    // 年龄不超过 130
    NSDate *minDate = [maxDate dateByAddingTimeInterval:-130 * 365 * 24 * 60 * 60.0];

    vc.maxDate = maxDate;
    vc.minDate = minDate;
    vc.delegate = self;

    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [self.viewController.navigationController presentViewController:vc animated:YES completion:nil];

    NSString *currDateStr = @"15/06/2000";
    if (HDIsStringNotEmpty(self.birthdayInfoView.model.valueText) && ![self.birthdayInfoView.model.valueText isEqualToString:PNLocalizedString(@"please_select", @"请选择")]) {
        currDateStr = self.birthdayInfoView.model.valueText;
    }

    [fmt setDateFormat:@"dd/MM/yyyy"];
    NSDate *currDate = [fmt dateFromString:currDateStr];
    if (currDate) {
        [vc setCurrentDate:currDate];
    }
}

- (void)handleSelectCountry {
    [self endEditing:YES];

    NationalityOptionController *vc = [NationalityOptionController new];
    @HDWeakify(self);
    vc.choosedCountryHandler = ^(CountryModel *_Nonnull country) {
        @HDStrongify(self);
        self.country = country.countryCode;
        self.countryInfoView.model.valueText = country.countryName;
        self.countryInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        [self.countryInfoView setNeedsUpdateContent];
        [self ruleLimit];
    };

    [SAWindowManager navigateToViewController:vc];
}

#pragma mark SADatePickerViewDelegate
/// 点击确定选中日期
- (void)datePickerView:(SADatePickerView *)pickView didSelectDate:(NSString *)date {
    NSString *dateStr = [date stringByAppendingFormat:@" 00:00:00"];
    self.birthday = [NSDate dateStringddMMyyyyHHmmss:dateStr] * 1000;
    self.birthdayInfoView.model.valueText = date;
    self.birthdayInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    self.birthdayInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15M;
    [self.birthdayInfoView setNeedsUpdateContent];
    [self ruleLimit];
}

#pragma mark - 按钮点亮限制
- (void)ruleLimit {
    self.lastName = [self.lastNameInputView.inputText hd_trim].uppercaseString;
    self.firstName = [self.firstNameInputView.inputText hd_trim].uppercaseString;

    NSString *tempBirthday = [NSString stringWithFormat:@"%zd", self.birthday];

    HDLog(@"进行按钮状态判断 %@ - %@ - %zd - %@ - %@ - %@", self.lastName, self.firstName, self.sex, tempBirthday, self.country, self.headUrl);

    if (![self.firstName.uppercaseString isEqualToString:self.firstNameInputView.model.value.uppercaseString]) {
        HDLog(@"❀❀❀firstName 需要更新");
        self.firstNameInputView.model.value = self.firstName;
        [self.firstNameInputView update];
    }

    if (![self.lastName.uppercaseString isEqualToString:self.lastNameInputView.model.value.uppercaseString]) {
        HDLog(@"❀❀❀lastName 需要更新");
        self.lastNameInputView.model.value = self.lastName;
        [self.lastNameInputView update];
    }

    if (WJIsStringNotEmpty(self.firstName) && WJIsStringNotEmpty(self.lastName) && self.sex > 0 && WJIsStringNotEmpty(tempBirthday) && self.birthday && WJIsStringNotEmpty(self.country)
        && WJIsStringNotEmpty(self.headUrl)) {
        [self.nextButton setEnabled:YES];
    } else {
        [self.nextButton setEnabled:NO];
    }
}

#pragma mark PNInputItemViewDelegate
- (BOOL)pn_textFieldShouldReturn:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark
#pragma mark other 根据countryCode 找到对应的 countryName
- (NSString *)getCountryName:(NSString *)key {
    NSString *countryName = @"";
    for (HDCountrySectionModel *sectionModel in self.countryModels) {
        for (CountryModel *model in sectionModel.data) {
            if ([model.countryCode isEqualToString:key]) {
                countryName = model.countryName;
                break;
            }
        }
    }
    return countryName;
}

#pragma mark
- (PNStepTipsView *)stepView {
    if (!_stepView) {
        _stepView = [[PNStepTipsView alloc] init];
        _stepView.step = 1;
    }
    return _stepView;
}

- (SAOperationButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:PNLocalizedString(@"BUTTON_TITLE_NEXT", @"下一步") forState:0];
        _nextButton.enabled = NO;
        @HDWeakify(self);
        [_nextButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            @HDStrongify(self);
            [self nextAction];
        }];

        _nextButton.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(20)];
        };
    }
    return _nextButton;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
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

- (SAInfoView *)picInfoView {
    if (!_picInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"User_Photo", @"用户照片")];
        model.valueImageURL = SAUser.shared.headURL;
        model.needValueImageRounded = true;
        model.valueImagePlaceholderImage = [UIImage imageNamed:@"pn_default_user_neutral"];
        model.valueImageSize = CGSizeMake(kRealWidth(40), kRealWidth(40));
        model.valueImageURL = SAUser.shared.headURL;
        model.lineWidth = 0;
        model.backgroundColor = [UIColor whiteColor];

        @HDWeakify(self);
        void (^callback)(NSString *) = ^(NSString *resultStr) {
            HDLog(@"结果是：%@", resultStr);
            model.valueImageURL = resultStr;
            self.headUrl = resultStr;
            @HDStrongify(self);
            [self.picInfoView setNeedsUpdateContent];
            [self ruleLimit];
        };

        model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToPayNowUploadImageVC:@{
                @"callback": callback,
                @"viewType": @(0),
                @"url": self.picInfoView.model.valueImageURL,
            }];
        };
        view.model = model;
        _picInfoView = view;
    }
    return _picInfoView;
}

- (PNInputItemView *)firstNameInputView {
    if (!_firstNameInputView) {
        _firstNameInputView = [[PNInputItemView alloc] init];
        _firstNameInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.title = PNLocalizedString(@"givenName", @"名字");
        model.placeholder = PNLocalizedString(@"set_givenName", @"请输入名字");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        model.fixWhenInputSpace = YES;
        model.isUppercaseString = YES;
        model.isWhenEidtClearValue = YES;
        model.canInputMoreSpace = NO;
        _firstNameInputView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapable theme:theme];

        kb.inputSource = _firstNameInputView.textFiled;
        _firstNameInputView.textFiled.inputView = kb;
    }
    return _firstNameInputView;
}

- (PNInputItemView *)lastNameInputView {
    if (!_lastNameInputView) {
        _lastNameInputView = [[PNInputItemView alloc] init];
        _lastNameInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.title = PNLocalizedString(@"familyName", @"姓");
        model.placeholder = PNLocalizedString(@"set_familyName", @"请输入姓");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        model.fixWhenInputSpace = YES;
        model.isUppercaseString = YES;
        model.isWhenEidtClearValue = YES;
        model.canInputMoreSpace = NO;
        _lastNameInputView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapable theme:theme];

        kb.inputSource = _lastNameInputView.textFiled;
        _lastNameInputView.textFiled.inputView = kb;
    }
    return _lastNameInputView;
}

- (SAInfoView *)sexInfoView {
    if (!_sexInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"TF_TITLE_SEX", @"性别")];
        model.valueText = PNLocalizedString(@"please_select", @"请选择");
        model.valueFont = HDAppTheme.PayNowFont.standard15M;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(18), kRealWidth(15), kRealWidth(18), kRealWidth(15));
        model.lineColor = HDAppTheme.PayNowColor.cECECEC;
        model.backgroundColor = [UIColor whiteColor];
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self handleSelectGender];
        };
        view.model = model;
        _sexInfoView = view;
    }
    return _sexInfoView;
}

- (SAInfoView *)birthdayInfoView {
    if (!_birthdayInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"birthday", @"出生日期")];
        model.valueText = PNLocalizedString(@"please_select", @"请选择");
        model.valueFont = HDAppTheme.PayNowFont.standard15M;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(18), kRealWidth(15), kRealWidth(18), kRealWidth(15));
        model.backgroundColor = [UIColor whiteColor];
        model.lineColor = HDAppTheme.PayNowColor.cECECEC;
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self handleSelectBirthday];
        };
        view.model = model;
        _birthdayInfoView = view;
    }
    return _birthdayInfoView;
}

- (SAInfoView *)countryInfoView {
    if (!_countryInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"Nation/Region", @"国籍/地区")];
        model.valueText = PNLocalizedString(@"please_select", @"请选择");
        model.valueFont = HDAppTheme.PayNowFont.standard15M;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(18), kRealWidth(15), kRealWidth(18), kRealWidth(15));
        model.lineColor = HDAppTheme.PayNowColor.cECECEC;
        model.lineWidth = 0;
        model.backgroundColor = [UIColor whiteColor];
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self handleSelectCountry];
        };
        view.model = model;
        _countryInfoView = view;
    }
    return _countryInfoView;
}

- (UIImageView *)tipsIconImgView {
    if (!_tipsIconImgView) {
        _tipsIconImgView = [[UIImageView alloc] init];
        _tipsIconImgView.image = [UIImage imageNamed:@"pn_tips_info_icon"];
    }
    return _tipsIconImgView;
}

- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[SALabel alloc] init];
        _tipsLabel.textColor = HDAppTheme.PayNowColor.c9599A2;
        _tipsLabel.font = HDAppTheme.PayNowFont.standard12;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.text = PNLocalizedString(@"get_more", @"为了获得更多的功能和账户额度，实名信息需与证件信息完全一致");
    }
    return _tipsLabel;
}

- (NSArray<HDCountrySectionModel *> *)countryModels {
    if (!_countryModels) {
        _countryModels = [NSMutableArray array];
        NSString *file = [[NSBundle mainBundle] pathForResource:PNLocalizedString(@"COUNTRY_TYPE", @"chineseCountryJson") ofType:@"txt"];
        NSData *data = [NSData dataWithContentsOfFile:file];

        _countryModels = [NSArray yy_modelArrayWithClass:HDCountrySectionModel.class json:[NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil]];
    }
    return _countryModels;
}
@end
