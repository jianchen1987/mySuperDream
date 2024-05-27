//
//  PNAccountInfoView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/1/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNAccountInfoView.h"
#import "HDCountrySectionModel.h"
#import "HDUserInfoRspModel.h"
#import "NSDate+Extension.h"
#import "NationalityOptionController.h"
#import "PNAccountUpgradeDTO.h"
#import "PNAccountViewModel.h"
#import "PNCommonUtils.h"
#import "PNInfoView.h"
#import "PNInputItemView.h"
#import "PNRspModel.h"
#import "PNUploadInfoView.h"
#import "SADatePickerViewController.h"


@interface PNAccountInfoView () <SADatePickerViewDelegate, PNInputItemViewDelegate>
/// 账号
@property (nonatomic, strong) PNInfoView *accountNoInfoView;
/// 账户级别
@property (nonatomic, strong) PNInfoView *accountLevelInfoView;
/// 名字
@property (nonatomic, strong) PNInputItemView *firstNameInfoView;
/// 姓
@property (nonatomic, strong) PNInputItemView *lastNameInfoView;
/// 性别
@property (nonatomic, strong) PNInfoView *genderInfoView;
/// 出生日期
@property (nonatomic, strong) PNInfoView *birthdayInfoView;
/// 用户照片
@property (nonatomic, strong) PNUploadInfoView *headerInfoView;
@property (nonatomic, strong) UIView *sectionView;

/// 国家/区域
@property (nonatomic, strong) PNInfoView *countryInfoView;
/// 证件类型
@property (nonatomic, strong) PNInfoView *legalTypeInfoView;
/// 证件号
@property (nonatomic, strong) PNInputItemView *legalNumberInfoView;
/// 证件有效期
@property (nonatomic, strong) PNInfoView *legalExpDateInfoView;
/// 签证到期日
@property (nonatomic, strong) PNInfoView *visaExpDateInfoView;
/// 证件照片正面
@property (nonatomic, strong) PNUploadInfoView *legalPhotoFrontInfoView;
/// 证件照片反面
@property (nonatomic, strong) PNUploadInfoView *legalPhotoBackInfoView;
/// 手持证件照
@property (nonatomic, strong) PNInfoView *legalPhotoInHandInfoView;

@property (nonatomic, strong) UIView *bottomBgView;
/// 按钮
@property (nonatomic, strong) SAOperationButton *confirmButton;

/// 升级中 【高级账户升级中 || 尊享账户升级中】
@property (nonatomic, assign) BOOL isUpgradIng;
/// 记录当前哪个在使用 日期选择控件 【1 证件有效期】【2 签证到期日】【3 出生日期】
@property (nonatomic, assign) NSInteger currentSelectDateType;
@property (nonatomic, strong) NSArray<HDCountrySectionModel *> *countryModels;

//提交字段
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, assign) PNSexType sex;
@property (nonatomic, assign) NSInteger birthday;

@property (nonatomic, copy) NSString *country; // code
@property (nonatomic, assign) PNPapersType cardType;
@property (nonatomic, copy) NSString *cardNum;
@property (nonatomic, assign) NSInteger expirationTime;
@property (nonatomic, assign) NSInteger visaExpirationTime;
@property (nonatomic, copy) NSString *idCardFrontUrl;
@property (nonatomic, copy) NSString *idCardBackUrl;
@property (nonatomic, copy) NSString *cardHandUrl;

@property (nonatomic, strong) PNAccountUpgradeDTO *upgradeDTO;
@property (nonatomic, strong) PNAccountViewModel *viewModel;
@end


@implementation PNAccountInfoView

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    self.scrollViewContainer.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;

    [self.scrollViewContainer addSubview:self.accountNoInfoView];
    [self.scrollViewContainer addSubview:self.accountLevelInfoView];
    [self.scrollViewContainer addSubview:self.lastNameInfoView];
    [self.scrollViewContainer addSubview:self.firstNameInfoView];
    [self.scrollViewContainer addSubview:self.genderInfoView];
    [self.scrollViewContainer addSubview:self.birthdayInfoView];
    [self.scrollViewContainer addSubview:self.headerInfoView];
    [self.scrollViewContainer addSubview:self.sectionView];
    [self.scrollViewContainer addSubview:self.countryInfoView];
    [self.scrollViewContainer addSubview:self.legalTypeInfoView];
    [self.scrollViewContainer addSubview:self.legalNumberInfoView];
    [self.scrollViewContainer addSubview:self.legalExpDateInfoView];
    [self.scrollViewContainer addSubview:self.visaExpDateInfoView];
    [self.scrollViewContainer addSubview:self.legalPhotoFrontInfoView];
    [self.scrollViewContainer addSubview:self.legalPhotoBackInfoView];
    [self.scrollViewContainer addSubview:self.legalPhotoInHandInfoView];

    [self addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.confirmButton];
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        if (!self.bottomBgView.hidden) {
            make.bottom.mas_equalTo(self.bottomBgView.mas_top);
        } else {
            make.bottom.mas_equalTo(self.mas_bottom);
        }
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    NSArray<UIView *> *visableViews = [self.scrollViewContainer.subviews hd_filterWithBlock:^BOOL(UIView *_Nonnull item) {
        return !item.isHidden;
    }];

    UIView *lastView;
    for (UIView *view in visableViews) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.top.equalTo(self.scrollViewContainer);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            make.left.right.equalTo(self.scrollViewContainer);
            if (view == visableViews.lastObject) {
                make.bottom.equalTo(self.scrollViewContainer);
                if ([view isKindOfClass:PNInfoView.class]) {
                    PNInfoView *infoView = (PNInfoView *)view;
                    infoView.model.lineWidth = 0;
                    [infoView setNeedsUpdateContent];
                }
            }

            if ([view isKindOfClass:PNInputItemView.class]) {
                make.height.equalTo(@(kRealWidth(50)));
            }
            if (view.tag == 999) {
                make.height.equalTo(@(kRealWidth(5)));
            }
        }];
        lastView = view;
    }

    if (!self.bottomBgView.hidden) {
        [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
        }];

        [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.bottomBgView.mas_width).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
            make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
            make.centerX.mas_equalTo(self.bottomBgView.mas_centerX);
            make.top.mas_equalTo(self.bottomBgView.mas_top).offset(kRealWidth(10));
            make.bottom.mas_equalTo(self.bottomBgView.mas_bottom).offset((iPhoneXSeries ? -(kiPhoneXSeriesSafeBottomHeight + kRealWidth(15)) : -kRealWidth(15)));
        }];
    }

    [super updateConstraints];
}

#pragma mark
- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self setData];
    }];

    [self.viewModel getCurrentDate];
}

- (void)setData {
    HDUserInfoRspModel *user = self.viewModel.userInfoModel;

    PNAccountLevelUpgradeStatus upgradeStatus = user.upgradeStatus;
    if (upgradeStatus == PNAccountLevelUpgradeStatus_SENIOR_UPGRADING || upgradeStatus == PNAccountLevelUpgradeStatus_INTERMEDIATE_UPGRADEING) {
        self.isUpgradIng = YES;
    }

    if (WJIsStringNotEmpty(user.loginName)) {
        self.accountNoInfoView.model.valueText = [PNCommonUtils deSensitiveString:user.loginName ?: @""];
        self.accountNoInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        [self.accountNoInfoView setNeedsUpdateContent];
    }

    if (user.accountLevel > 0) {
        self.accountLevelInfoView.model.valueText = [PNCommonUtils getAccountLevelNameByCode:user.accountLevel];
        self.accountLevelInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        [self.accountLevelInfoView setNeedsUpdateContent];
    }

    if (WJIsStringNotEmpty(user.firstName)) {
        self.firstName = user.firstName;
        self.firstNameInfoView.model.value = user.firstName;
        self.firstNameInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    }

    if (WJIsStringNotEmpty(user.lastName)) {
        self.lastName = user.lastName;
        self.lastNameInfoView.model.value = user.lastName;
        self.lastNameInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    }

    if (user.sex > 0) {
        self.sex = user.sex;
        self.genderInfoView.model.valueText = [PNCommonUtils getSexBySexCode:user.sex];
        self.genderInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    } else {
        [self setInfoPleaseSelectStatus:self.genderInfoView];
    }

    NSString *tempBirthday = [NSString stringWithFormat:@"%zd", user.birthday];
    if (WJIsStringNotEmpty(tempBirthday) && user.birthday) {
        self.birthday = user.birthday;
        self.birthdayInfoView.model.valueText = [PNCommonUtils dateSecondToDate:user.birthday / 1000 dateFormat:@"dd/MM/yyyy"];
        self.birthdayInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    } else {
        [self setInfoPleaseSelectStatus:self.birthdayInfoView];
    }

    self.headUrl = user.headUrl;
    [self setPhotoStatus:self.headerInfoView value:user.headUrl];

    if (WJIsStringNotEmpty(user.country)) {
        self.country = user.country;
        self.countryInfoView.model.valueText = [self getCountryName:user.country];
        self.countryInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    } else {
        [self setInfoPleaseSelectStatus:self.countryInfoView];
    }

    if (user.cardType > 0) {
        self.cardType = user.cardType;
        self.legalTypeInfoView.model.valueText = [PNCommonUtils getPapersNameByPapersCode:user.cardType];
        self.legalTypeInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    } else {
        [self setInfoPleaseSelectStatus:self.legalTypeInfoView];
    }

    if (WJIsStringNotEmpty(user.cardNum)) {
        self.cardNum = user.cardNum;
        self.legalNumberInfoView.model.value = user.cardNum;
        self.legalNumberInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    }

    if (user.expirationTime > 0) {
        self.expirationTime = user.expirationTime;
        NSString *str = [PNCommonUtils dateSecondToDate:user.expirationTime / 1000 dateFormat:@"dd/MM/yyyy"];
        if ([str isEqualToString:PNSPECIALTIMEFOREVER]) {
            str = PNLocalizedString(@"Permanently_valid", @"永久有效期");
        }
        self.legalExpDateInfoView.model.valueText = str;
        self.legalExpDateInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    } else {
        [self setInfoPleaseSelectStatus:self.legalExpDateInfoView];
    }

    if (user.visaExpirationTime > 0) {
        self.visaExpirationTime = user.visaExpirationTime;
        NSString *str = [PNCommonUtils dateSecondToDate:user.visaExpirationTime / 1000 dateFormat:@"dd/MM/yyyy"];
        self.visaExpDateInfoView.model.valueText = str;
        self.visaExpDateInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    } else {
        [self setInfoPleaseSelectStatus:self.visaExpDateInfoView];
    }

    self.idCardFrontUrl = user.idCardFrontUrl;
    [self setPhotoStatus:self.legalPhotoFrontInfoView value:user.idCardFrontUrl];

    self.idCardBackUrl = user.idCardBackUrl;
    [self setPhotoStatus:self.legalPhotoBackInfoView value:user.idCardBackUrl];

    self.cardHandUrl = user.cardHandUrl;
    [self setPhotoStatus:self.legalPhotoInHandInfoView value:user.cardHandUrl];

    //额外处理
    [self reSetPassport];
    [self checkDateTime];
    [self setBottomTipsWithPhotoInHandInfoView];

    ///设置按钮
    if (self.isUpgradIng) {
        self.confirmButton.enabled = NO;
        [self.confirmButton setTitle:PNLocalizedString(@"Under_upgrade", @"升级中") forState:0];
        [self setEditStatus:NO];
    } else {
        self.confirmButton.enabled = YES;
        [self.confirmButton setTitle:PNLocalizedString(@"confirm_update", @"确认修改") forState:0];
        [self setEditStatus:YES];
    }

    [self ruleLimit];

    [self setNeedsUpdateConstraints];
}

#pragma mark
#pragma mark 提交按钮
- (void)confirmAction {
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
            @"用户选择日期年龄[info]":
                [NSString stringWithFormat:@"%@-%@- %@", dateString, [NSDate dateSecondToDate:[[NSDate date] timeIntervalSince1970] DateFormat:@"yyyy-MM-dd"], self.viewModel.currentDateStr]
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

            [SATalkingData trackEvent:@"用户年龄校验失败" label:@"年龄-月份"

                           parameters:@{
                               @"用户选择日期月份[info]": [NSString
                                   stringWithFormat:@"%@-%@ -%@", dateString, [NSDate dateSecondToDate:[[NSDate date] timeIntervalSince1970] DateFormat:@"yyyy-MM-dd"], self.viewModel.currentDateStr]
                           }];
            return;
        }
    }

    //这里校验有值就往服务器里面传，按理来说 在ruleLimit function 里面已经做好校验

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (WJIsStringNotEmpty(self.headUrl)) {
        [dict setValue:self.headUrl forKey:@"headUrl"];
    }

    if (WJIsStringNotEmpty(self.firstName) && ![self.firstName containsString:@"***"]) {
        [dict setValue:self.firstName forKey:@"name"]; // name    名字
    }

    if (WJIsStringNotEmpty(self.lastName) && ![self.lastName containsString:@"***"]) {
        [dict setValue:self.lastName forKey:@"surname"]; // surname  姓氏
    }

    if (self.sex > 0) {
        [dict setValue:@(self.sex) forKey:@"sex"];
    }

    NSString *tempBirthday = [NSString stringWithFormat:@"%zd", self.birthday];
    if (WJIsStringNotEmpty(tempBirthday)) {
        [dict setValue:@(self.birthday) forKey:@"birthday"];
    }

    if (WJIsStringNotEmpty(self.country)) {
        [dict setValue:self.country forKey:@"country"];
    }

    if (self.cardType > 0) {
        [dict setValue:@(self.cardType) forKey:@"cardType"];
    }

    if (WJIsStringNotEmpty(self.cardNum) && ![self.cardNum containsString:@"***"]) {
        [dict setValue:self.cardNum forKey:@"cardNum"];
    }

    if (self.expirationTime > 0) {
        [dict setValue:@(self.expirationTime) forKey:@"expirationTime"];
    }

    if (self.visaExpirationTime > 0) {
        [dict setValue:@(self.visaExpirationTime) forKey:@"visaExpirationTime"];
    }

    if (WJIsStringNotEmpty(self.idCardFrontUrl)) {
        [dict setValue:self.idCardFrontUrl forKey:@"idCardFrontUrl"];
    }

    if (WJIsStringNotEmpty(self.idCardBackUrl)) {
        [dict setValue:self.idCardBackUrl forKey:@"idCardBackUrl"];
    }

    if (WJIsStringNotEmpty(self.cardHandUrl)) {
        [dict setValue:self.cardHandUrl forKey:@"cardHandUrl"];
    }

    [self showloading];
    @HDWeakify(self);
    [self.upgradeDTO submitRealNameV2WithParams:dict successBlock:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        NSDictionary *dict = rspModel.data;
        if ([dict.allKeys containsObject:@"message"]) {
            NSString *messageStr = [dict objectForKey:@"message"];
            [NAT showAlertWithMessage:messageStr buttonTitle:SALocalizedStringFromTable(@"confirm", @"确认", @"Buttons")
                              handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                  [alertView dismissCompletion:^{
                                      [self.viewController.navigationController popViewControllerAnimated:YES];
                                  }];
                              }];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark
#pragma mark 按钮规则判断
/// 基本信息包括：名字、姓、性别、出生日期、用户照片
- (BOOL)ruleBaseInfo {
    self.lastName = [self.lastNameInfoView.model.value hd_trim];
    self.firstName = [self.firstNameInfoView.model.value hd_trim];
    //    if (![self.firstName.uppercaseString isEqualToString:self.firstNameInfoView.model.value.uppercaseString]) {
    //        HDLog(@"❀❀❀firstName 需要更新");
    //        self.firstNameInfoView.model.value = self.firstName;
    //        [self.firstNameInfoView update];
    //    }

    //    if (![self.lastName.uppercaseString isEqualToString:self.lastNameInfoView.model.value]) {
    //        HDLog(@"❀❀❀lastName 需要更新");
    //        self.lastNameInfoView.model.value = self.lastName;
    //        [self.lastNameInfoView update];
    //    }
    NSString *tempBirthday = [NSString stringWithFormat:@"%zd", self.birthday];

    HDLog(@"🚀🚀🚀ruleBaseInfo: 姓：%@ \n 名：%@ \n 性别：%zd \n 出生日期:%zd [%@] \n 头像：%@", self.lastName, self.firstName, self.sex, self.birthday, tempBirthday, self.headUrl);

    if (WJIsStringNotEmpty(self.firstName) && WJIsStringNotEmpty(self.lastName) && self.sex > 0 && WJIsStringNotEmpty(tempBirthday) && self.birthday && WJIsStringNotEmpty(self.headUrl)) {
        HDLog(@"ruleBaseInfo: YES");
        return YES;
    } else {
        HDLog(@"ruleBaseInfo: NO");
        return NO;
    }
}

/// 证件信息：证件类型、证件号、证件有效期、签证到期日、证件照片正面、证件照反面
- (BOOL)ruleCerInfo {
    self.cardNum = [self.legalNumberInfoView.model.value hd_trim];

    HDLog(@"🚀🚀🚀ruleCerInfo:   国家：%@ \n 证件类型：%zd \n 证件号码：%@ \n 有效时间：%zd \n 证件到期日：%zd \n 证件照正面：%@ \n 证件照反面：%@",
          self.country,
          self.cardType,
          self.cardNum,
          self.expirationTime,
          self.visaExpirationTime,
          self.idCardFrontUrl,
          self.idCardBackUrl);

    /// “柬埔寨”，且证件类型选择了“护照”，则该项为非必填项[idCardBackUrl]
    if ([self.country isEqualToString:@"KH"] && self.cardType == PNPapersTypePassport) {
        if (self.cardType > 0 && WJIsStringNotEmpty(self.cardNum) && self.expirationTime > 0 && WJIsStringNotEmpty(self.idCardFrontUrl)) {
            HDLog(@"1 ruleCerInfo YES");
            return YES;
        } else {
            HDLog(@"1 ruleCerInfo NO");
            return NO;
        }
    } else {
        /// 非“柬埔寨”，且证件类型选择了“护照”，则增加必填项【签证到期日】
        if (![self.country isEqualToString:@"KH"] && self.cardType == PNPapersTypePassport && WJIsStringNotEmpty(self.country)) {
            if (self.cardType > 0 && WJIsStringNotEmpty(self.cardNum) && self.expirationTime > 0 && WJIsStringNotEmpty(self.idCardFrontUrl) && WJIsStringNotEmpty(self.idCardBackUrl)
                && self.visaExpirationTime > 0) {
                HDLog(@"2 ruleCerInfo YES");
                return YES;
            } else {
                HDLog(@"2 ruleCerInfo NO");
                return NO;
            }
        } else {
            if (WJIsStringNotEmpty(self.country) && self.cardType > 0 && WJIsStringNotEmpty(self.cardNum) && self.expirationTime > 0 && WJIsStringNotEmpty(self.idCardFrontUrl)
                && WJIsStringNotEmpty(self.idCardBackUrl)) {
                HDLog(@"3 ruleCerInfo YES");
                return YES;
            } else {
                HDLog(@"3 ruleCerInfo NO");
                return NO;
            }
        }
    }
}

/// 判断是否有值 【证件类型、证件号、证件有效期、签证到期日、证件照片正面、证件照反面】
- (BOOL)ruleCerNotValue {
    self.cardNum = [self.legalNumberInfoView.model.value hd_trim];

    HDLog(@"🚀🚀🚀ruleCerNotValue:   国家：%@ \n 证件类型：%zd \n 证件号码：%@ \n 有效时间：%zd \n 证件到期日：%zd \n 证件照正面：%@ \n 证件照反面：%@",
          self.country,
          self.cardType,
          self.cardNum,
          self.expirationTime,
          self.visaExpirationTime,
          self.idCardFrontUrl,
          self.idCardBackUrl);

    if (WJIsStringEmpty(self.country) && self.cardType <= 0 && WJIsStringEmpty(self.cardNum) && self.expirationTime <= 0 && self.visaExpirationTime <= 0 && WJIsStringEmpty(self.idCardFrontUrl)
        && WJIsStringEmpty(self.idCardFrontUrl)) {
        HDLog(@"ruleCerNotValue YES");
        return YES;
    } else {
        HDLog(@"ruleCerNotValue NO");
        return NO;
    }
}

/// 手持证件照 是否有值
- (BOOL)ruleCardInHand {
    HDLog(@"🚀🚀🚀ruleCardInHand: 手持证件照：%@", self.cardHandUrl);
    if (WJIsStringNotEmpty(self.cardHandUrl)) {
        HDLog(@"ruleCardInHand YES");
        return YES;
    } else {
        HDLog(@"ruleCardInHand NO");
        return NO;
    }
}

- (void)ruleLimit {
    if (self.isUpgradIng) {
        HDLog(@"升级中");
        self.confirmButton.enabled = NO;
    } else {
        HDUserInfoRspModel *user = self.viewModel.userInfoModel;
        PNUserLevel userLevel = user.accountLevel;
        PNAccountLevelUpgradeStatus upgradeStatus = user.upgradeStatus;
        HDLog(@"🌺🌺等级：%@ - %zd", [PNCommonUtils getAccountLevelNameByCode:userLevel], userLevel);
        HDLog(@"🌺🌺等级：%@ - %zd", [PNCommonUtils getAccountUpgradeStatusNameByCode:upgradeStatus], upgradeStatus);
        if (userLevel == PNUserLevelNormal) {
            if ([self ruleBaseInfo] && [self ruleCerNotValue] && ![self ruleCardInHand]) {
                HDLog(@"😄😄 按钮可用1");
                self.confirmButton.enabled = YES;
            } else if ([self ruleBaseInfo] && ![self ruleCardInHand] && [self ruleCerInfo]) {
                HDLog(@"😄😄 按钮可用1-1");
                self.confirmButton.enabled = YES;
            } else if ([self ruleBaseInfo] && [self ruleCardInHand] && [self ruleCerInfo]) {
                HDLog(@"😄😄 按钮可用1-2");
                self.confirmButton.enabled = YES;
            } else if ([self ruleBaseInfo] && [self ruleCardInHand] && [self ruleCerNotValue]) {
                HDLog(@"😄😄 按钮不可用1");
                self.confirmButton.enabled = NO;
            } else {
                HDLog(@"😒😒 按钮不可用1-1");
                self.confirmButton.enabled = NO;
            }
        } else if (userLevel == PNUserLevelAdvanced) {
            if ([self ruleBaseInfo] && [self ruleCerInfo]) {
                HDLog(@"😄😄 按钮可用4");
                self.confirmButton.enabled = YES;
            } else {
                HDLog(@"😒😒 按钮不可用4");
                self.confirmButton.enabled = NO;
            }
        } else if (userLevel == PNUserLevelHonour) {
            if ([self ruleBaseInfo] && [self ruleCerInfo] && [self ruleCardInHand]) {
                HDLog(@"😄😄 按钮可用6");
                self.confirmButton.enabled = YES;
            } else {
                HDLog(@"😒😒 按钮不可用6");
                self.confirmButton.enabled = NO;
            }
        }
    }
}

#pragma mark
/// 检查 手持证件照是否有值
- (void)setBottomTipsWithPhotoInHandInfoView {
    if (WJIsStringEmpty(self.cardHandUrl) && !self.isUpgradIng) {
        self.legalPhotoInHandInfoView.model.bottomTipsText = PNLocalizedString(@"pn_To_upgrade_to_Platinum_account_tips", @"* 如需升级尊享账户及使用国际转账功能，则手持证件照为必填项");
        [self.legalPhotoInHandInfoView setNeedsUpdateContent];
    }
}
/// 检查日期
- (void)checkDateTime {
    if (!self.isUpgradIng) {
        ///先转成统一的 格式  再转成时间戳
        NSString *formatStr = @"dd/MM/yyyy";
        NSString *currDateStr = [PNCommonUtils getDateStrByFormat:formatStr withDate:[NSDate date]];
        NSInteger todayInt = [NSDate dateString:currDateStr DateFormat:formatStr];
        // 降级之后 有效期 签证到期日会清空
        NSInteger expirationTimeInt = self.expirationTime == 0 ? 0 : [NSDate dateString:[PNCommonUtils dateSecondToDate:self.expirationTime / 1000 dateFormat:formatStr] DateFormat:formatStr];
        NSInteger visaExpirationTimeInt
            = self.visaExpirationTime == 0 ? 0 : [NSDate dateString:[PNCommonUtils dateSecondToDate:self.visaExpirationTime / 1000 dateFormat:formatStr] DateFormat:formatStr];
        // 证件有效期判断
        if (expirationTimeInt < todayInt && expirationTimeInt != 0) {
            if (![self.legalExpDateInfoView.model.valueText isEqualToString:PNLocalizedString(@"please_upload", @"请上传")]) {
                self.legalExpDateInfoView.model.bottomTipsText = PNLocalizedString(@"pn_Expired_select_again", @"*已过期,请重新选择");
                [self.legalExpDateInfoView setNeedsUpdateContent];
            }

            if (![self.legalPhotoFrontInfoView.model.valueText isEqualToString:PNLocalizedString(@"please_upload", @"请上传")]) {
                self.legalPhotoFrontInfoView.model.bottomTipsText = PNLocalizedString(@"pn_Expired_upload_again", @"*已过期，请重新上传");
                [self.legalPhotoFrontInfoView setNeedsUpdateContent];
            }

            if (![self.legalPhotoBackInfoView.model.valueText isEqualToString:PNLocalizedString(@"please_upload", @"请上传")]) {
                self.legalPhotoBackInfoView.model.bottomTipsText = PNLocalizedString(@"pn_Expired_upload_again", @"*已过期，请重新上传");
                [self.legalPhotoBackInfoView setNeedsUpdateContent];
            }

            if (![self.legalPhotoInHandInfoView.model.valueText isEqualToString:PNLocalizedString(@"please_upload", @"请上传")]) {
                self.legalPhotoInHandInfoView.model.bottomTipsText = PNLocalizedString(@"pn_Expired_upload_again", @"*已过期，请重新上传");
                [self.legalPhotoInHandInfoView setNeedsUpdateContent];
            }
        }

        // 签证到期日的判断
        if (!self.visaExpDateInfoView.hidden) {
            if (visaExpirationTimeInt < todayInt && visaExpirationTimeInt != 0) {
                if (![self.visaExpDateInfoView.model.valueText isEqualToString:PNLocalizedString(@"please_upload", @"请上传")]) {
                    self.visaExpDateInfoView.model.bottomTipsText = PNLocalizedString(@"pn_Expired_select_again", @"*已过期,请重新选择");
                    [self.visaExpDateInfoView setNeedsUpdateContent];
                }

                if (![self.legalPhotoBackInfoView.model.valueText isEqualToString:PNLocalizedString(@"please_upload", @"请上传")]) {
                    self.legalPhotoBackInfoView.model.bottomTipsText = PNLocalizedString(@"pn_Expired_upload_again", @"*已过期，请重新上传");
                    [self.legalPhotoBackInfoView setNeedsUpdateContent];
                }
            }
        }
    }
}

#pragma mark 设置
- (void)setEditStatus:(BOOL)canEdit {
    [self setInputEditStatus:self.firstNameInfoView canEdit:canEdit];
    [self setInputEditStatus:self.lastNameInfoView canEdit:canEdit];
    [self setInputEditStatus:self.legalNumberInfoView canEdit:canEdit];

    [self setInfoEditStatus:self.genderInfoView canEdit:canEdit];
    [self setInfoEditStatus:self.birthdayInfoView canEdit:canEdit];
    [self setInfoEditStatus:self.headerInfoView canEdit:canEdit];
    [self setInfoEditStatus:self.countryInfoView canEdit:canEdit];
    [self setInfoEditStatus:self.legalTypeInfoView canEdit:canEdit];
    [self setInfoEditStatus:self.legalExpDateInfoView canEdit:canEdit];
    [self setInfoEditStatus:self.visaExpDateInfoView canEdit:canEdit];
    [self setInfoEditStatus:self.legalPhotoFrontInfoView canEdit:canEdit];
    [self setInfoEditStatus:self.legalPhotoBackInfoView canEdit:canEdit];
    [self setInfoEditStatus:self.legalPhotoInHandInfoView canEdit:canEdit];
}

- (void)setInfoEditStatus:(PNInfoView *)infoView canEdit:(BOOL)canEdit {
    if (canEdit) {
        infoView.model.rightButtonImage = [UIImage imageNamed:@"pn_arrow_gray_small"];
        infoView.model.enableTapRecognizer = YES;
    } else {
        infoView.model.rightButtonImage = nil;
        infoView.model.enableTapRecognizer = NO;
    }
    [infoView setNeedsUpdateContent];
}

- (void)setInputEditStatus:(PNInputItemView *)inputView canEdit:(BOOL)canEdit {
    if (canEdit) {
        inputView.model.enabled = YES;
    } else {
        inputView.model.enabled = NO;
    }
    [inputView update];
}

/// photo 的专属设置
- (void)setPhotoStatus:(PNInfoView *)infoView value:(NSString *)value {
    if (WJIsStringNotEmpty(value)) {
        infoView.model.valueText = PNLocalizedString(@"Uploaded", @"已上传");
        infoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    } else {
        infoView.model.valueText = PNLocalizedString(@"please_upload", @"请上传");
        infoView.model.valueColor = HDAppTheme.color.G3;
    }
}

/// info 的请选择
- (void)setInfoPleaseSelectStatus:(PNInfoView *)infoView {
    infoView.model.valueText = PNLocalizedString(@"please_select", @"请选择");
    infoView.model.valueColor = HDAppTheme.color.G3;
}

/// 清除底部提示文案
- (void)clearBottomTipsTextInfoView:(PNInfoView *)infoView {
    if (WJIsStringNotEmpty(infoView.model.bottomTipsText)) {
        infoView.model.bottomTipsText = @"";
        [infoView setNeedsUpdateContent];
    }
}

#pragma mark
#pragma mark PNInputItemViewDelegate
- (BOOL)pn_textFieldShouldReturn:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [textField resignFirstResponder];
    return YES;
}

- (void)pn_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason view:(PNInputItemView *)view {
    [self ruleLimit];
}

#pragma mark
#pragma mark eventHandler
/// 性别选择
- (void)handleSelectGender {
    void (^continueUpdateView)(PNSexType) = ^(PNSexType type) {
        self.sex = type;
        self.genderInfoView.model.valueText = [PNCommonUtils getSexBySexCode:type];
        self.genderInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        self.genderInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15M;
        [self.genderInfoView setNeedsUpdateContent];
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

/// 证件有效期
- (void)handleSelecLegalExpDate {
    void (^continueUpdateView)(NSString *) = ^(NSString *data) {
        if ([data isEqualToString:PNLocalizedString(@"Permanently_valid", @"永久有效期")]) {
            ///  永久有效传这个 9999/12/31 23:59:59
            self.expirationTime = [NSDate dateStringddMMyyyyHHmmss:[PNSPECIALTIMEFOREVER stringByAppendingString:@" 23:59:59"]] * 1000;
            [self clearBottomTipsTextInfoView:self.legalExpDateInfoView];

            self.legalExpDateInfoView.model.valueText = data;
            self.legalExpDateInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
            self.legalExpDateInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15M;
            [self.legalExpDateInfoView setNeedsUpdateContent];
            [self ruleLimit];
        } else {
            [self handlerSelectDate:1];
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

/// 日期选择 [【1 证件有效期】【2 签证到期日】【3 出生日期】]
- (void)handlerSelectDate:(NSInteger)type {
    self.currentSelectDateType = type;

    SADatePickerViewController *vc = [[SADatePickerViewController alloc] init];
    vc.datePickStyle = SADatePickerStyleDMY;

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMdd"];
    [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];

    NSDate *maxDate;
    NSDate *minDate;
    if (type == 3) {
        // 生日不要超过今天
        maxDate = [NSDate date];
        // 年龄不超过 130
        minDate = [maxDate dateByAddingTimeInterval:-130 * 365 * 24 * 60 * 60.0];
    } else {
        minDate = [NSDate date];
        maxDate = [minDate dateByAddingTimeInterval:500 * 365 * 24 * 60 * 60.0];
    }

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
    } else if (self.currentSelectDateType == 3) {
        if (self.birthday > 0) {
            currDateStr = [PNCommonUtils dateSecondToDate:self.birthday / 1000 dateFormat:@"dd/MM/yyyy"];
        } else {
            currDateStr = @"15/06/2000";
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

/// 点击确定选中日期
- (void)datePickerView:(SADatePickerView *)pickView didSelectDate:(NSString *)date {
    NSString *dateStr = [date stringByAppendingFormat:@" 00:00:00"];
    NSInteger selectDateInt = [NSDate dateStringddMMyyyyHHmmss:dateStr] * 1000;
    if (self.currentSelectDateType == 1) { //【1 证件有效期】
        if (self.expirationTime != selectDateInt) {
            [self clearBottomTipsTextInfoView:self.legalExpDateInfoView];
        }
        self.expirationTime = selectDateInt;
        self.legalExpDateInfoView.model.valueText = date;
        self.legalExpDateInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        self.legalExpDateInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15M;
        [self.legalExpDateInfoView setNeedsUpdateContent];
    } else if (self.currentSelectDateType == 2) { // 【2 签证到期日】
        if (self.visaExpirationTime != selectDateInt) {
            [self clearBottomTipsTextInfoView:self.visaExpDateInfoView];
        }
        self.visaExpirationTime = selectDateInt;
        self.visaExpDateInfoView.model.valueText = date;
        self.visaExpDateInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        self.visaExpDateInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15M;
        [self.visaExpDateInfoView setNeedsUpdateContent];
    } else if (self.currentSelectDateType == 3) { //【3 出生日期】
        self.birthday = selectDateInt;
        self.birthdayInfoView.model.valueText = date;
        self.birthdayInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
        self.birthdayInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15M;
        [self.birthdayInfoView setNeedsUpdateContent];
    }
    [self ruleLimit];
}

/// 重置护照
- (void)reSetPassport {
    /// 非“柬埔寨”，且证件类型选择了“护照” ”柬埔寨驾照“，则增加必填项【签证到期日】 否则不展示该字段；
    if (![self.country isEqualToString:@"KH"] && (self.cardType == PNPapersTypePassport || self.cardType == PNPapersTypeDrivingLince)) {
        self.visaExpDateInfoView.hidden = NO;
    } else {
        self.visaExpDateInfoView.hidden = YES;
        self.visaExpirationTime = 0;
        [self setInfoPleaseSelectStatus:self.visaExpDateInfoView];
        [self.visaExpDateInfoView setNeedsUpdateContent];
    }

    if ([self.country isEqualToString:@"KH"] && self.cardType == PNPapersTypePassport) {
        self.legalPhotoBackInfoView.hidden = YES;
    } else {
        self.legalPhotoBackInfoView.hidden = NO;
    }

    [self reSetSelectActionItem];
    [self reSetLegalPhotoInfoViewTitle];
}

/// 如果证件类型是护照，则【证件照反面】文案改为【签证页】
- (void)reSetLegalPhotoInfoViewTitle {
    if (![self.country isEqualToString:@"KH"]) {
        if (self.cardType == PNPapersTypePassport) {
            self.legalPhotoFrontInfoView.model.keyText = PNLocalizedString(@"pn_Passport_front_page", @"护照首页");
            self.legalPhotoBackInfoView.model.keyText = PNLocalizedString(@"pn_visa_page", @"有效签证页");
        }

        if (self.cardType == PNPapersTypeDrivingLince) {
            self.legalPhotoFrontInfoView.model.keyText = PNLocalizedString(@"front_photo", @"证件照正面");
            self.legalPhotoBackInfoView.model.keyText = PNLocalizedString(@"pn_visa_page", @"有效签证页");
        }
    } else {
        if (self.cardType == PNPapersTypePassport) {
            self.legalPhotoBackInfoView.model.keyText = @""; //隐藏了
            self.legalPhotoFrontInfoView.model.keyText = PNLocalizedString(@"pn_Passport_front_page", @"护照首页");
        } else {
            self.legalPhotoBackInfoView.model.keyText = PNLocalizedString(@"back_photo", @"证件照反面");
            self.legalPhotoFrontInfoView.model.keyText = PNLocalizedString(@"front_photo", @"证件照正面");
        }
    }

    [self.legalPhotoBackInfoView setNeedsUpdateContent];
    [self.legalPhotoFrontInfoView setNeedsUpdateContent];
}

/// 如果用户选择的国家为【柬埔寨】，且证件类型为【身份证】，则点击【证件照反面】下拉选项新增一个【使用默认照片】选项
- (void)reSetSelectActionItem {
    if ([self.country isEqualToString:@"KH"] && self.cardType == PNPapersTypeIDCard) {
        self.legalPhotoBackInfoView.isCanSelectDefaultPhoto = YES;
    } else {
        self.legalPhotoBackInfoView.isCanSelectDefaultPhoto = NO;
    }
}

- (void)setCardTypeNameWithName:(PNPapersType)cardType {
    self.cardType = cardType;
    self.legalTypeInfoView.model.valueText = [PNCommonUtils getPapersNameByPapersCode:cardType];
    self.legalTypeInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    self.legalTypeInfoView.model.valueFont = HDAppTheme.PayNowFont.standard15M;
    [self.legalTypeInfoView setNeedsUpdateContent];
}

/// 证件类型
- (void)handleSelectLegalType {
    @HDWeakify(self);
    void (^continueUpdateView)(PNPapersType) = ^(PNPapersType type) {
        @HDStrongify(self);
        [self setCardTypeNameWithName:type];
        [self ruleLimit];

        [self reSetPassport];
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
- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc] init];
        _bottomBgView.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    }
    return _bottomBgView;
}

- (SAOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:PNLocalizedString(@"confirm_update", @"确认修改") forState:0];
        _confirmButton.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(20)];
        };

        @HDWeakify(self);
        [_confirmButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self confirmAction];
        }];
    }
    return _confirmButton;
}

- (PNInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    PNInfoViewModel *model = PNInfoViewModel.new;
    model.keyText = key;
    model.lineColor = HDAppTheme.PayNowColor.cECECEC;
    model.backgroundColor = [UIColor whiteColor];
    model.valueFont = HDAppTheme.PayNowFont.standard15M;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(18), kRealWidth(15), kRealWidth(18), kRealWidth(15));
    return model;
}

- (PNInfoView *)accountNoInfoView {
    if (!_accountNoInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"TF_TITLE_LOGINNAME", @"账号")];
        model.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        view.model = model;
        _accountNoInfoView = view;
    }
    return _accountNoInfoView;
}

- (PNInfoView *)accountLevelInfoView {
    if (!_accountLevelInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"Account_level", @"账户级别")];
        model.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        view.model = model;
        _accountLevelInfoView = view;
    }
    return _accountLevelInfoView;
}

- (PNInputItemView *)lastNameInfoView {
    if (!_lastNameInfoView) {
        _lastNameInfoView = [[PNInputItemView alloc] init];
        _lastNameInfoView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.title = PNLocalizedString(@"familyName", @"姓");
        model.placeholder = PNLocalizedString(@"set_familyName", @"请输入姓");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        model.fixWhenInputSpace = YES;
        //        model.coverUp = PNInputCoverUpName;
        model.isUppercaseString = YES;
        model.isWhenEidtClearValue = YES;
        model.canInputMoreSpace = NO;
        _lastNameInfoView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapable theme:theme];

        kb.inputSource = _lastNameInfoView.textFiled;
        _lastNameInfoView.textFiled.inputView = kb;
    }
    return _lastNameInfoView;
}

- (PNInputItemView *)firstNameInfoView {
    if (!_firstNameInfoView) {
        _firstNameInfoView = [[PNInputItemView alloc] init];
        _firstNameInfoView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.title = PNLocalizedString(@"givenName", @"名字");
        model.placeholder = PNLocalizedString(@"set_givenName", @"请输入名字");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        model.fixWhenInputSpace = YES;
        //        model.coverUp = PNInputCoverUpName;
        model.isUppercaseString = YES;
        model.isWhenEidtClearValue = YES;
        model.canInputMoreSpace = NO;
        _firstNameInfoView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapable theme:theme];

        kb.inputSource = _firstNameInfoView.textFiled;
        _firstNameInfoView.textFiled.inputView = kb;
    }
    return _firstNameInfoView;
}

- (PNInfoView *)genderInfoView {
    if (!_genderInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"TF_TITLE_SEX", @"性别")];
        view.model = model;
        _genderInfoView = view;

        @HDWeakify(self);
        model.eventHandler = ^{
            HDLog(@"click");
            @HDStrongify(self);
            [self handleSelectGender];
        };
    }
    return _genderInfoView;
}

- (PNInfoView *)birthdayInfoView {
    if (!_birthdayInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"birthday", @"出生日期")];
        view.model = model;
        _birthdayInfoView = view;

        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self handlerSelectDate:3];
        };
    }
    return _birthdayInfoView;
}

- (PNUploadInfoView *)headerInfoView {
    if (!_headerInfoView) {
        PNUploadInfoView *view = PNUploadInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"User_Photo", @"用户照片")];
        view.model = model;
        view.cropMode = SAImageCropModeSquare;
        _headerInfoView = view;

        @HDWeakify(self);
        _headerInfoView.uploadInfoBlock = ^(NSString *url) {
            @HDStrongify(self);
            self.headUrl = url;
            [self setPhotoStatus:self.headerInfoView value:url];
            [self.headerInfoView setNeedsUpdateContent];
            [self ruleLimit];
        };
    }
    return _headerInfoView;
}

- (PNInfoView *)countryInfoView {
    if (!_countryInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"Nation/Region", @"国籍/地区")];
        view.model = model;
        _countryInfoView = view;

        model.eventHandler = ^{
            NationalityOptionController *vc = [NationalityOptionController new];
            vc.choosedCountryHandler = ^(CountryModel *_Nonnull country) {
                self.country = country.countryCode;
                self.countryInfoView.model.valueText = country.countryName;
                self.countryInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;

                if (![self.country isEqualToString:@"KH"]) {
                    /// 强制转成选择护照
                    if (self.cardType != PNPapersTypePassport || self.cardType != PNPapersTypeDrivingLince) {
                        [self setCardTypeNameWithName:PNPapersTypePassport];
                    }
                }

                [self.countryInfoView setNeedsUpdateContent];
                [self reSetPassport];
                [self setNeedsUpdateConstraints];
                [self ruleLimit];
            };

            [SAWindowManager navigateToViewController:vc];
        };
    }
    return _countryInfoView;
}

- (PNInfoView *)legalTypeInfoView {
    if (!_legalTypeInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"Legal_type", @"证件类型")];
        view.model = model;
        _legalTypeInfoView = view;

        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self handleSelectLegalType];
        };
    }
    return _legalTypeInfoView;
}

- (PNInputItemView *)legalNumberInfoView {
    if (!_legalNumberInfoView) {
        _legalNumberInfoView = [[PNInputItemView alloc] init];
        _legalNumberInfoView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.title = PNLocalizedString(@"Legal_number", @"证件号");
        model.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        //        model.coverUp = PNInputCoverUpNumber;
        model.isWhenEidtClearValue = YES;
        _legalNumberInfoView.model = model;
    }
    return _legalNumberInfoView;
}

- (PNInfoView *)legalExpDateInfoView {
    if (!_legalExpDateInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"Legal_expiration_date", @"证件有效期")];

        view.model = model;
        _legalExpDateInfoView = view;

        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self handleSelecLegalExpDate];
        };
    }
    return _legalExpDateInfoView;
}

- (PNInfoView *)visaExpDateInfoView {
    if (!_visaExpDateInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"visa_expiration_date", @"签证到期日")];
        view.model = model;
        view.hidden = YES;
        _visaExpDateInfoView = view;

        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self handlerSelectDate:2];
        };
    }
    return _visaExpDateInfoView;
}

- (PNUploadInfoView *)legalPhotoFrontInfoView {
    if (!_legalPhotoFrontInfoView) {
        PNUploadInfoView *view = PNUploadInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"front_photo", @"证件照正面")];
        view.model = model;
        _legalPhotoFrontInfoView = view;

        @HDWeakify(self);
        _legalPhotoFrontInfoView.uploadInfoBlock = ^(NSString *url) {
            @HDStrongify(self);
            [self clearBottomTipsTextInfoView:self.legalPhotoFrontInfoView];

            self.idCardFrontUrl = url;
            [self setPhotoStatus:self.legalPhotoFrontInfoView value:url];
            [self.legalPhotoFrontInfoView setNeedsUpdateContent];
            [self ruleLimit];
        };
    }
    return _legalPhotoFrontInfoView;
}

- (PNUploadInfoView *)legalPhotoBackInfoView {
    if (!_legalPhotoBackInfoView) {
        PNUploadInfoView *view = PNUploadInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"back_photo", @"证件照反面")];
        view.model = model;

        _legalPhotoBackInfoView = view;

        @HDWeakify(self);
        _legalPhotoBackInfoView.uploadInfoBlock = ^(NSString *url) {
            @HDStrongify(self);
            [self clearBottomTipsTextInfoView:self.legalPhotoBackInfoView];

            self.idCardBackUrl = url;
            [self setPhotoStatus:self.legalPhotoBackInfoView value:url];
            [self.legalPhotoBackInfoView setNeedsUpdateContent];
            [self ruleLimit];
        };
    }
    return _legalPhotoBackInfoView;
}

- (PNInfoView *)legalPhotoInHandInfoView {
    if (!_legalPhotoInHandInfoView) {
        PNUploadInfoView *view = PNUploadInfoView.new;
        view.needCrop = NO;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"Photo_legal_in_hand", @"手持证件照")];
        view.model = model;

        _legalPhotoInHandInfoView = view;

        @HDWeakify(self);

        model.eventHandler = ^{
            @HDStrongify(self);

            if (self.cardType <= 0) {
                [NAT showAlertWithMessage:PNLocalizedString(@"pn_select_Legal_document_type", @"请先选择【证件类型】") buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定")
                                  handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                      [alertView dismiss];
                                  }];
                return;
            }

            @HDWeakify(self);
            void (^callback)(NSString *) = ^(NSString *resultStr) {
                HDLog(@"结果是：%@", resultStr);
                @HDStrongify(self);
                [self clearBottomTipsTextInfoView:self.legalPhotoInHandInfoView];

                self.cardHandUrl = resultStr;
                [self setPhotoStatus:self.legalPhotoInHandInfoView value:resultStr];
                [self.legalPhotoInHandInfoView setNeedsUpdateContent];
                [self ruleLimit];
            };

            [HDMediator.sharedInstance navigaveToPayNowUploadImageVC:@{
                @"callback": callback,
                @"viewType": @(1),
                @"url": self.cardHandUrl,
                @"cardType": @(self.cardType),
            }];
        };
    }
    return _legalPhotoInHandInfoView;
}

- (UIView *)sectionView {
    if (!_sectionView) {
        _sectionView = [[UIView alloc] init];
        _sectionView.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        _sectionView.tag = 999;
    }
    return _sectionView;
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

- (PNAccountUpgradeDTO *)upgradeDTO {
    if (!_upgradeDTO) {
        _upgradeDTO = [[PNAccountUpgradeDTO alloc] init];
    }
    return _upgradeDTO;
}

@end
