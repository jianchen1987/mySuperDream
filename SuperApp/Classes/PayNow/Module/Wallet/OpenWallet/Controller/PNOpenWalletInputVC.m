//
//  OpenWalletInputVC.m
//  SuperApp
//
//  Created by Quin on 2021/11/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNOpenWalletInputVC.h"
#import "NSDate+Extension.h"
#import "NSString+matchs.h"
#import "PNCommonUtils.h"
#import "PNInputItemView.h"
#import "PNOpenWalletReqModel.h"
#import "PNOpenWalletVC.h"
#import "PNUserDTO.h"
#import "SADatePickerViewController.h"
#import "SAInfoView.h"
#import "SASettingPayPwdViewController.h"
#import "SASettingPayPwdViewModel.h"
#import "SATalkingData.h"


@interface PNOpenWalletInputVC () <PNInputItemViewDelegate, SADatePickerViewDelegate>
/// 用户头像
@property (nonatomic, strong) SAInfoView *picInfoView;
@property (nonatomic, strong) UIView *bgView;
/// 姓
@property (nonatomic, strong) PNInputItemView *firstNameInputView;
/// 名字
@property (nonatomic, strong) PNInputItemView *lastNameInputView;
/// 性别
@property (nonatomic, strong) SAInfoView *sexInfoView;
/// 出生日期
@property (nonatomic, strong) SAInfoView *birthdayInfoView;
/// 下一步
@property (nonatomic, strong) SAOperationButton *nextBtn;

@property (nonatomic, strong) PNOpenWalletReqModel *openWalletReqModel;
@property (nonatomic, strong) SASettingPayPwdViewModel *viewModel;
@property (nonatomic, assign) NSInteger actionType;
/// 回调
@property (nonatomic, copy) void (^successHandler)(BOOL needSetting, BOOL isSuccess);

@property (nonatomic, strong) PNUserDTO *userDTO;
@property (nonatomic, strong) NSString *currentDateStr;
@end


@implementation PNOpenWalletInputVC
#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.actionType = [[parameters objectForKey:@"actionType"] integerValue];
        self.successHandler = [parameters objectForKey:@"completion"];
    }
    return self;
}

#pragma mark
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    [self ruleLimit];
}

#pragma mark - SAViewControllerProtocol
- (void)hd_bindViewModel {
    [self.userDTO getCurrentDay:^(NSString *_Nonnull rspDate) {
        self.currentDateStr = rspDate;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error){

    }];
}

- (void)hd_setupViews {
    [self addNotification];

    self.view.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;

    [self.view addSubview:self.bgView];
    [self.view addSubview:self.picInfoView];

    [self.bgView addSubview:self.lastNameInputView];
    [self.bgView addSubview:self.firstNameInputView];

    [self.bgView addSubview:self.sexInfoView];
    [self.bgView addSubview:self.birthdayInfoView];
    [self.view addSubview:self.nextBtn];
}
#pragma mark - layout
- (void)updateViewConstraints {
    [self.picInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(5));
        make.left.equalTo(self.bgView.mas_left);
        make.right.equalTo(self.bgView.mas_right);
        //        make.height.mas_equalTo(kRealWidth(74));
    }];

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picInfoView.mas_bottom).offset(kRealWidth(5));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.birthdayInfoView.mas_bottom);
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

    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(20)));
        make.left.equalTo(self.view.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.view.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(50));
    }];
    [super updateViewConstraints];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"Input_user_info", @"输入用户信息");
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

#pragma mark 按钮
- (void)nextTap {
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"dd/MM/yyyy"];
    [fm setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    NSString *dateString = self.birthdayInfoView.model.valueText;
    NSDate *birthDay = [fm dateFromString:dateString];
    NSInteger age = 0;
    if (WJIsStringNotEmpty(self.currentDateStr)) {
        age = [PNCommonUtils getDiffenrenceYearByDate_age:dateString date2:self.currentDateStr];
    } else {
        age = [PNCommonUtils getDiffenrenceYearByDate:birthDay];
    }

    if (age < 18) {
        [NAT showToastWithTitle:nil content:PNLocalizedString(@"ALERT_MSG_AUTHEN_AGE_18_LIMIT", @"根据NBC要求，未满18周岁不支持账户升级") type:HDTopToastTypeWarning];
        [SATalkingData trackEvent:@"用户年龄校验失败" label:@"年龄" parameters:@{
            @"用户选择日期年龄[开通]":
                [NSString stringWithFormat:@"%@-%@ -%@", dateString, [NSDate dateSecondToDate:[[NSDate date] timeIntervalSince1970] DateFormat:@"yyyy-MM-dd"], self.currentDateStr]
        }];

        return;
    }

    if (18 == age) {
        NSString *currentMD = @"";
        if (WJIsStringNotEmpty(self.currentDateStr)) {
            NSDate *md = [fm dateFromString:self.currentDateStr];
            currentMD = [PNCommonUtils getDateStrByFormat:@"MMdd" withDate:md];
        } else {
            currentMD = [PNCommonUtils getCurrentDateStrByFormat:@"MMdd"];
        }
        NSString *bithMD = [PNCommonUtils getDateStrByFormat:@"MMdd" withDate:birthDay];
        if (bithMD.integerValue >= currentMD.integerValue) {
            [NAT showToastWithTitle:nil content:PNLocalizedString(@"ALERT_MSG_AUTHEN_AGE_18_LIMIT", @"根据NBC要求，未满18周岁不支持账户升级") type:HDTopToastTypeWarning];

            [SATalkingData trackEvent:@"用户年龄校验失败" label:@"年龄-月份" parameters:@{
                @"用户选择日期月份[开通]":
                    [NSString stringWithFormat:@"%@-%@ -%@", dateString, [NSDate dateSecondToDate:[[NSDate date] timeIntervalSince1970] DateFormat:@"yyyy-MM-dd"], self.currentDateStr]
            }];
            return;
        }
    }

    NSMutableDictionary *modelDict = [self.openWalletReqModel yy_modelToJSONObject];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:modelDict];
    [newDict setObject:@(self.actionType) forKey:@"actionType"];
    [newDict setObject:self.successHandler forKey:@"completion"];

    HDLog(@"%@", newDict);

    [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:newDict];
}

#pragma mark
/// 性别选择
- (void)handleSelectGender {
    void (^continueUpdateView)(PNSexType) = ^(PNSexType type) {
        self.openWalletReqModel.sex = type;
        self.sexInfoView.model.valueText = [PNCommonUtils getSexBySexCode:type];
        self.sexInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        self.sexInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15B;
        [self.sexInfoView setNeedsUpdateContent];
        [self ruleLimit];
    };

    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];

    HDActionSheetViewButton *maleBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"SEX_TYPE_MALE", @"男") type:HDActionSheetViewButtonTypeCustom
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

    [self.navigationController presentViewController:vc animated:YES completion:nil];

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

#pragma mark SADatePickerViewDelegate
/// 点击确定选中日期
- (void)datePickerView:(SADatePickerView *)pickView didSelectDate:(NSString *)date {
    NSString *dateStr = [date stringByAppendingFormat:@" 00:00:00"];
    self.openWalletReqModel.birthday = dateStr;
    self.birthdayInfoView.model.valueText = date;
    self.birthdayInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    self.birthdayInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15B;
    [self.birthdayInfoView setNeedsUpdateContent];
    [self ruleLimit];
}

#pragma mark - 按钮点亮限制
- (void)ruleLimit {
    self.openWalletReqModel.firstName = [self.firstNameInputView.inputText hd_trim].uppercaseString;
    self.openWalletReqModel.lastName = [self.lastNameInputView.inputText hd_trim].uppercaseString;

    if (![self.openWalletReqModel.firstName.uppercaseString isEqualToString:self.firstNameInputView.model.value.uppercaseString]) {
        self.firstNameInputView.model.value = self.openWalletReqModel.firstName;
        [self.firstNameInputView update];
    }
    if (![self.openWalletReqModel.lastName.uppercaseString isEqualToString:self.lastNameInputView.model.value.uppercaseString]) {
        self.lastNameInputView.model.value = self.openWalletReqModel.lastName;
        [self.lastNameInputView update];
    }

    if (WJIsStringNotEmpty(self.openWalletReqModel.firstName) && WJIsStringNotEmpty(self.openWalletReqModel.lastName) && self.openWalletReqModel.sex > 0
        && WJIsStringNotEmpty(self.openWalletReqModel.birthday)) {
        [self.nextBtn setEnabled:YES];
    } else {
        [self.nextBtn setEnabled:NO];
    }
}

#pragma mark PNInputItemViewDelegate
- (BOOL)pn_textFieldShouldReturn:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (SAOperationButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:PNLocalizedString(@"next", @"下一步") forState:UIControlStateNormal];
        _nextBtn.enabled = NO;
        [_nextBtn addTarget:self action:@selector(nextTap) forControlEvents:UIControlEventTouchUpInside];

        _nextBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(25)];
        };
    }
    return _nextBtn;
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

        self.openWalletReqModel.headUrl = model.valueImageURL;

        @HDWeakify(self);
        void (^callback)(NSString *) = ^(NSString *resultStr) {
            HDLog(@"结果是：%@", resultStr);
            model.valueImageURL = resultStr;
            self.openWalletReqModel.headUrl = resultStr;
            @HDStrongify(self);
            [self.picInfoView setNeedsUpdateContent];
            [self ruleLimit];
        };

        model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToPayNowUploadImageVC:@{@"callback": callback, @"viewType": @(0), @"url": self.picInfoView.model.valueImageURL}];
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
        model.valueFont = HDAppTheme.PayNowFont.standard15B;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(18), kRealWidth(15), kRealWidth(18), kRealWidth(15));
        model.lineColor = HDAppTheme.PayNowColor.cECECEC;
        model.backgroundColor = [UIColor whiteColor];
        model.eventHandler = ^{
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
        model.valueFont = HDAppTheme.PayNowFont.standard15B;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(18), kRealWidth(15), kRealWidth(18), kRealWidth(15));
        model.backgroundColor = [UIColor whiteColor];
        model.lineColor = HDAppTheme.PayNowColor.cECECEC;
        model.lineWidth = 0;
        model.eventHandler = ^{
            [self handleSelectBirthday];
        };
        view.model = model;
        _birthdayInfoView = view;
    }
    return _birthdayInfoView;
}

- (PNOpenWalletReqModel *)openWalletReqModel {
    if (!_openWalletReqModel) {
        _openWalletReqModel = [[PNOpenWalletReqModel alloc] init];
        _openWalletReqModel.sex = -1;
    }
    return _openWalletReqModel;
}

- (PNUserDTO *)userDTO {
    if (!_userDTO) {
        _userDTO = [[PNUserDTO alloc] init];
    }
    return _userDTO;
}
@end
