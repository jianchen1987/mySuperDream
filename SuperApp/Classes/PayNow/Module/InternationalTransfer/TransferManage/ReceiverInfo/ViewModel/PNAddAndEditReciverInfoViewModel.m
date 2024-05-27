//
//  PNAddAndEditReciverInfoViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNAddAndEditReciverInfoViewModel.h"
#import "HDAppTheme+PayNow.h"
#import "NSDate+Extension.h"
#import "PNCityPickerViewController.h"
#import "PNInterTransferReciverDTO.h"
#import "PNRspModel.h"
#import "PNSingleSelectedAlertView.h"
#import "PNTransferFormConfig.h"
#import "SADatePickerViewController.h"
#import "VipayUser.h"

//与转账人关系tag
static NSString *const kRelationConfigTag = @"kRelationConfigTag";


@interface PNAddAndEditReciverInfoViewModel () <SADatePickerViewDelegate, PNCityPickerViewDelegate>
///
@property (strong, nonatomic) PNInterTransferReciverDTO *reciverDto;
///
@property (strong, nonatomic) PNTransferFormConfig *birthDayConfig;
/// 其它关系配置项
@property (strong, nonatomic) PNTransferFormConfig *otherRelationConfig;

@property (nonatomic, strong) PNTransferFormConfig *provinceConfig;
@property (nonatomic, strong) PNTransferFormConfig *cityConfig;
@end


@implementation PNAddAndEditReciverInfoViewModel

- (void)queryRelationList {
    @HDWeakify(self);
    [self.reciverDto queryRelationListSuccess:^(NSArray<PNInterTransferRelationModel *> *_Nonnull list) {
        @HDStrongify(self);
        self.relationList = list;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error){

    }];
}

/// 新增或者修改 收款人
- (void)saveOrUpdateReciverInfoToServiceCompletion:(void (^)(void))completion {
    self.uploadModel.lastName = self.uploadModel.lastName.uppercaseString;
    self.uploadModel.firstName = self.uploadModel.firstName.uppercaseString;
    self.uploadModel.middleName = self.uploadModel.middleName.uppercaseString;
    self.uploadModel.fullName = self.uploadModel.fullName.uppercaseString;

    [self.view showloading];
    @HDWeakify(self);
    if (self.isEditStyle) {
        [self.reciverDto updateReciverInfoWithModel:self.uploadModel channel:self.channel success:^{
            @HDStrongify(self);
            [self.view dismissLoading];
            !completion ?: completion();
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    } else {
        [self.reciverDto saveReciverInfoWithModel:self.uploadModel channel:self.channel success:^{
            @HDStrongify(self);
            [self.view dismissLoading];
            !completion ?: completion();
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    }
}

/// 删除收款人
- (void)deleteReciverInfoToServiceCompletion:(void (^)(void))completion {
    [self.view showloading];
    @HDWeakify(self);
    [self.reciverDto deleteReciverInfoWithModel:self.uploadModel success:^{
        @HDStrongify(self);
        [self.view dismissLoading];
        !completion ?: completion();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark
#pragma mark -按钮是否可点击
- (void)checkSaveBtnEanbled {
    if (self.channel == PNInterTransferThunesChannel_Wechat) {
        if (HDIsStringNotEmpty(self.uploadModel.msisdn) && HDIsStringNotEmpty(self.uploadModel.idTypeCode) && HDIsStringNotEmpty(self.uploadModel.idCode)
            && HDIsStringNotEmpty(self.uploadModel.fullName)) {
            self.saveBtnEnabled = YES;
        } else {
            self.saveBtnEnabled = NO;
        }
    } else {
        if (HDIsStringNotEmpty(self.uploadModel.msisdn) && HDIsStringNotEmpty(self.uploadModel.idTypeCode) && HDIsStringNotEmpty(self.uploadModel.idCode)
                && HDIsStringNotEmpty(self.uploadModel.firstName) && HDIsStringNotEmpty(self.uploadModel.lastName) &&
                //        HDIsStringNotEmpty(self.uploadModel.fullName) &&
                //        HDIsStringNotEmpty(self.uploadModel.birthDate) &&
                HDIsStringNotEmpty(self.uploadModel.nationality) && HDIsStringNotEmpty(self.uploadModel.province) && HDIsStringNotEmpty(self.uploadModel.city)
            &&HDIsStringNotEmpty(self.uploadModel.address) && HDIsStringNotEmpty(self.uploadModel.relationType)) {
            if ([self hasContainOtherRelationConfig] && HDIsStringEmpty(self.uploadModel.otherRelation)) {
                self.saveBtnEnabled = NO;
            } else {
                self.saveBtnEnabled = YES;
            }
        } else {
            self.saveBtnEnabled = NO;
        }
    }
}

#pragma mark -选择证件回调
- (void)showIDTypeAlertView:(PNTransferFormConfig *)config {
    PNSingleSelectedModel *model = [[PNSingleSelectedModel alloc] init];
    model.name = PNLocalizedString(@"PAPER_TYPE_IDCARD", @"身份证");
    model.itemId = @"12";
    if (self.uploadModel.idType == [model.itemId integerValue]) {
        model.isSelected = YES;
    }

    PNSingleSelectedModel *model2 = [[PNSingleSelectedModel alloc] init];
    model2.name = PNLocalizedString(@"PAPER_TYPE_PASSPORT", @"护照");
    model2.itemId = @"13";
    if (self.uploadModel.idType == [model2.itemId integerValue]) {
        model2.isSelected = YES;
    }

    NSArray *arr;
    if (self.channel == PNInterTransferThunesChannel_Wechat) {
        arr = @[model];
    } else {
        arr = @[model, model2];
    }

    PNSingleSelectedAlertView *alertView = [[PNSingleSelectedAlertView alloc] initWithDataArr:arr title:PNLocalizedString(@"Legal_type", @"证件类型")];
    @HDWeakify(self);
    alertView.selectedCallback = ^(PNSingleSelectedModel *_Nonnull model) {
        @HDStrongify(self);
        config.valueText = model.name;
        self.uploadModel.idTypeCode = model.name;
        self.uploadModel.idType = [model.itemId intValue];
        self.refreshFlag = !self.refreshFlag;
    };
    [alertView show];
}

#pragma mark -选择关系回调
- (void)showRelationAlertView:(PNTransferFormConfig *)config {
    NSMutableArray *array = [NSMutableArray array];
    for (PNInterTransferRelationModel *reModel in self.relationList) {
        PNSingleSelectedModel *model = [[PNSingleSelectedModel alloc] init];
        model.name = reModel.relationCode;
        model.itemId = reModel.relationType;
        if ([self.uploadModel.relationType isEqualToString:model.itemId]) {
            model.isSelected = YES;
        }
        [array addObject:model];
    }

    PNSingleSelectedAlertView *alertView = [[PNSingleSelectedAlertView alloc] initWithDataArr:array title:PNLocalizedString(@"lYXV87bl", @"与转账人关系")];
    @HDWeakify(self);
    alertView.selectedCallback = ^(PNSingleSelectedModel *_Nonnull model) {
        @HDStrongify(self);
        config.valueText = model.name;
        self.uploadModel.relationType = model.itemId;
        self.uploadModel.relationCode = model.name;
        [self checkRelationSelected];
    };
    [alertView show];
}

/// 检查关系选项  如果选了其它 就要展示其它选项
- (void)checkRelationSelected {
    HDTableViewSectionModel *sectionModel = self.dataArr.lastObject;
    __block NSInteger index; //关系的位置
    [sectionModel.list enumerateObjectsUsingBlock:^(PNTransferFormConfig *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj.associateString isEqualToString:kRelationConfigTag]) {
            index = idx;
            *stop = YES;
        }
    }];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:sectionModel.list];
    //选择了其它选项
    if ([self.uploadModel.relationType isEqualToString:@"OTHER"]) {
        if (![temp containsObject:self.otherRelationConfig]) {
            [temp insertObject:self.otherRelationConfig atIndex:index + 1];
            sectionModel.list = temp;
        }
    } else {
        self.uploadModel.otherRelation = @"";
        if ([temp containsObject:self.otherRelationConfig]) {
            [temp removeObject:self.otherRelationConfig];
            sectionModel.list = temp;
        }
    }

    self.refreshFlag = !self.refreshFlag;
    [self checkSaveBtnEanbled];
}

#pragma mark -选择关系回调
- (void)showBirthDayAlertView:(PNTransferFormConfig *)config {
    self.birthDayConfig = config;
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

    [[SAWindowManager visibleViewController].navigationController presentViewController:vc animated:YES completion:nil];

    if (HDIsStringNotEmpty(self.uploadModel.birthDate)) {
        NSString *currDateStr = self.uploadModel.showBirthDateStr;
        [fmt setDateFormat:@"dd/MM/yyyy"];
        NSDate *currDate = [fmt dateFromString:currDateStr];
        if (currDate) {
            [vc setCurrentDate:currDate];
        }
    }
}

///是否选了其它关系
- (BOOL)hasContainOtherRelationConfig {
    HDTableViewSectionModel *sectionModel = self.dataArr.lastObject;
    return [sectionModel.list containsObject:self.otherRelationConfig];
}

#pragma mark SADatePickerViewDelegate
/// 点击确定选中日期
- (void)datePickerView:(SADatePickerView *)pickView didSelectDate:(NSString *)date {
    NSString *dateStr = [date stringByAppendingFormat:@" 00:00:00"];
    self.uploadModel.birthDate = [NSString stringWithFormat:@"%ld", [NSDate dateStringddMMyyyyHHmmss:dateStr] * 1000];

    self.birthDayConfig.valueText = self.uploadModel.showBirthDateStr;
    [self checkSaveBtnEanbled];
    self.refreshFlag = !self.refreshFlag;
}

- (void)selectChianCity:(PNTransferFormConfig *)config {
    PNCityPickerViewController *vc = [[PNCityPickerViewController alloc] init];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [[SAWindowManager visibleViewController].navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)cityPickerView:(PNCityPickerView *)pickView didSelectprovince:(NSString *)province city:(NSString *)city {
    self.uploadModel.province = province;
    self.uploadModel.city = city;

    self.provinceConfig.valueText = province;
    self.cityConfig.valueText = city;

    self.refreshFlag = !self.refreshFlag;
    [self checkSaveBtnEanbled];
}

#pragma mark
- (void)initDataArr {
    if (self.channel == PNInterTransferThunesChannel_Wechat) {
        HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        sectionModel.headerModel.title = PNLocalizedString(@"Wqhob2CB", @"收款账户信息");

        NSMutableArray *temp = [NSMutableArray array];

        PNTransferFormConfig *config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"EflnCwt2", @"手机号");
        config.valuePlaceHold = PNLocalizedString(@"please_enter", @"请输入");
        config.showKeyStar = YES;
        config.editType = PNSTransferFormValueEditTypeEnter;
        config.subKeyText = PNLocalizedString(@"pn_wechat_bind_phone_tips", @"请输入微信绑定银行的手机号");
        config.keyboardType = UIKeyboardTypeNumberPad;
        config.maxInputLength = 11;
        NSString *phone = self.uploadModel.msisdn;
        if (HDIsStringNotEmpty(self.uploadModel.msisdn) && [self.uploadModel.msisdn hasPrefix:@"86"]) {
            phone = [self.uploadModel.msisdn stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
        }
        config.valueText = phone;
        config.leftLabelString = @"  +86";
        @HDWeakify(self);
        config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            self.uploadModel.msisdn = targetConfig.valueText;
            [self checkSaveBtnEanbled];
        };
        [temp addObject:config];

        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"Legal_type", @"证件类型");
        config.valuePlaceHold = PNLocalizedString(@"pn_wechat_bind_cardType_tips", @"请输入微信收款账户绑定的证件类型");
        config.showKeyStar = YES;
        config.editType = PNSTransferFormValueEditTypeDrop;
        config.valueText = self.uploadModel.idTypeCode;
        config.valueContainerClickCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            [self.view endEditing:YES];
            [self showIDTypeAlertView:targetConfig];
            [self checkSaveBtnEanbled];
        };
        [temp addObject:config];

        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"Legal_number", @"证件号");
        config.valuePlaceHold = PNLocalizedString(@"pn_wechat_bind_cardNum_tips", @"请输入微信收款账户账户的证件号");
        config.showKeyStar = YES;
        config.editType = PNSTransferFormValueEditTypeEnter;
        config.valueText = self.uploadModel.idCode;
        config.useWOWNOWKeyboard = YES;
        config.maxInputLength = 18;
        config.wownowKeyBoardType = HDKeyBoardTypeNumberPadCanSwitchToLetter;
        config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            self.uploadModel.idCode = targetConfig.valueText;
            [self checkSaveBtnEanbled];
        };
        [temp addObject:config];

        sectionModel.list = temp;
        [self.dataArr addObject:sectionModel];

        sectionModel = HDTableViewSectionModel.new;
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        sectionModel.headerModel.title = PNLocalizedString(@"mKw25x8s", @"收款人信息");
        sectionModel.headerModel.rightButtonImage = [UIImage imageNamed:@"pn_rate_tip"];

        temp = [NSMutableArray array];

        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"pn_full_name", @"姓名");
        config.subKeyText = PNLocalizedString(@"pn_fullname_capital", @"（姓+名拼音大写）");
        config.valuePlaceHold = PNLocalizedString(@"pn_input_wechat_full_name", @"请输入微信收款名片的客户姓名");
        config.showKeyStar = YES;
        config.editType = PNSTransferFormValueEditTypeEnter;
        config.valueText = self.uploadModel.fullName;
        config.useWOWNOWKeyboard = YES;
        config.wownowKeyBoardType = HDKeyBoardTypeLetterCapable;
        config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            self.uploadModel.fullName = targetConfig.valueText;
            [self checkSaveBtnEanbled];
        };
        [temp addObject:config];

        sectionModel.list = temp;
        [self.dataArr addObject:sectionModel];

    } else {
        HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        sectionModel.headerModel.title = PNLocalizedString(@"Wqhob2CB", @"收款账户信息");

        NSMutableArray *temp = [NSMutableArray array];

        PNTransferFormConfig *config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"EflnCwt2", @"手机号");
        config.valuePlaceHold = PNLocalizedString(@"pn_bind_alipay_phone", @"支付宝绑定手机号");
        config.showKeyStar = YES;
        config.editType = PNSTransferFormValueEditTypeEnter;
        config.keyboardType = UIKeyboardTypeNumberPad;
        config.maxInputLength = 11;
        NSString *phone = self.uploadModel.msisdn;
        if (HDIsStringNotEmpty(self.uploadModel.msisdn) && [self.uploadModel.msisdn hasPrefix:@"86"]) {
            phone = [self.uploadModel.msisdn stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
        }
        config.valueText = phone;
        config.leftLabelString = @"  +86";
        @HDWeakify(self);
        config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            self.uploadModel.msisdn = targetConfig.valueText;
            [self checkSaveBtnEanbled];
        };
        [temp addObject:config];

        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"Legal_type", @"证件类型");
        config.valuePlaceHold = PNLocalizedString(@"pn_bind_alipay_idType", @"支付宝绑定证件类型");
        config.showKeyStar = YES;
        config.editType = PNSTransferFormValueEditTypeDrop;
        config.valueText = self.uploadModel.idTypeCode;
        config.valueContainerClickCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            [self.view endEditing:YES];
            [self showIDTypeAlertView:targetConfig];
            [self checkSaveBtnEanbled];
        };
        [temp addObject:config];

        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"Legal_number", @"证件号");
        config.valuePlaceHold = PNLocalizedString(@"pn_bind_alipay_idNo", @"支付宝绑定证件号");
        config.showKeyStar = YES;
        config.editType = PNSTransferFormValueEditTypeEnter;
        config.valueText = self.uploadModel.idCode;
        config.useWOWNOWKeyboard = YES;
        config.wownowKeyBoardType = HDKeyBoardTypeNumberPadCanSwitchToLetter;
        config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            self.uploadModel.idCode = targetConfig.valueText;
            [self checkSaveBtnEanbled];
        };
        [temp addObject:config];

        //    config = PNTransferFormConfig.new;
        //    config.keyText = PNLocalizedString(@"info_email", @"邮箱");
        //    config.valuePlaceHold = PNLocalizedString(@"please_enter", @"请输入");
        //    config.editType = PNSTransferFormValueEditTypeEnter;
        //    config.valueText = self.uploadModel.email;
        //    config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
        //        @HDStrongify(self);
        //        self.uploadModel.email = targetConfig.valueText;
        //    };
        //    [temp addObject:config];

        sectionModel.list = temp;
        [self.dataArr addObject:sectionModel];

        sectionModel = HDTableViewSectionModel.new;
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        sectionModel.headerModel.title = PNLocalizedString(@"mKw25x8s", @"收款人信息");
        sectionModel.headerModel.rightButtonImage = [UIImage imageNamed:@"pn_rate_tip"];

        temp = [NSMutableArray array];

        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"TF_TITLE_LAST_NAME", @"姓");
        config.subKeyText = PNLocalizedString(@"pn_up_letters", @"（必须大写英文字母）");
        config.valuePlaceHold = PNLocalizedString(@"pn_bind_alipay_lastName", @"支付宝账号姓");
        config.showKeyStar = YES;
        config.editType = PNSTransferFormValueEditTypeEnter;
        config.valueText = self.uploadModel.lastName;
        config.useWOWNOWKeyboard = YES;
        config.wownowKeyBoardType = HDKeyBoardTypeLetterCapable;
        config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            self.uploadModel.lastName = targetConfig.valueText;
            self.uploadModel.fullName = [NSString stringWithFormat:@"%@ %@", self.uploadModel.lastName, self.uploadModel.firstName];
            [self checkSaveBtnEanbled];
        };

        [temp addObject:config];

        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"UNzSjgTY", @"名");
        config.subKeyText = PNLocalizedString(@"pn_up_letters", @"（必须大写英文字母）");
        config.valuePlaceHold = PNLocalizedString(@"pn_bind_alipay_firstName", @"支付宝账号名");
        config.showKeyStar = YES;
        config.editType = PNSTransferFormValueEditTypeEnter;
        config.valueText = self.uploadModel.firstName;
        config.useWOWNOWKeyboard = YES;
        config.wownowKeyBoardType = HDKeyBoardTypeLetterCapable;
        config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            self.uploadModel.firstName = targetConfig.valueText;
            self.uploadModel.fullName = [NSString stringWithFormat:@"%@ %@", self.uploadModel.lastName, self.uploadModel.firstName];
            [self checkSaveBtnEanbled];
        };
        [temp addObject:config];

        //    config = PNTransferFormConfig.new;
        //    config.keyText = PNLocalizedString(@"OwjdGw1x", @"中间名");
        //    config.valuePlaceHold = PNLocalizedString(@"please_enter", @"请输入");
        //    config.editType = PNSTransferFormValueEditTypeEnter;
        //    config.valueText = self.uploadModel.middleName;
        //    config.useWOWNOWKeyboard = YES;
        //    config.wownowKeyBoardType = HDKeyBoardTypeLetterCapable;
        //    config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
        //        @HDStrongify(self);
        //        self.uploadModel.middleName = targetConfig.valueText;
        //    };
        //    [temp addObject:config];

        //    config = PNTransferFormConfig.new;
        //    config.keyText = PNLocalizedString(@"v06KEcfu", @"全名");
        //    config.valuePlaceHold = PNLocalizedString(@"please_enter", @"请输入");
        //    config.showKeyStar = YES;
        ////    config.editType = PNSTransferFormValueEditTypeEnter;
        //    config.valueText = self.uploadModel.fullName;
        ////    config.useWOWNOWKeyboard = YES;
        ////    config.wownowKeyBoardType = HDKeyBoardTypeLetterCapable;
        //    config.onlyShow = YES;
        ////    config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
        ////        @HDStrongify(self);
        ////        self.uploadModel.fullName = targetConfig.valueText;
        ////        [self checkSaveBtnEanbled];
        ////    };
        //    self.fullNameConfig = config;
        //    [temp addObject:self.fullNameConfig];

        //    config = PNTransferFormConfig.new;
        //    config.keyText = PNLocalizedString(@"TF_TITLE_BIRTHDAY", @"出生日期");
        //    config.valuePlaceHold = PNLocalizedString(@"please_select", @"请选择");
        //    config.showKeyStar = YES;
        //    config.editType = PNSTransferFormValueEditTypeDrop;
        //    config.valueText = self.uploadModel.showBirthDateStr;
        //    config.valueContainerClickCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
        //        @HDStrongify(self);
        //        [self showBirthDayAlertView:targetConfig];
        //    };
        //    [temp addObject:config];

        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"Suw8Q4KU", @"国家");
        config.valueText = self.uploadModel.nationality;
        config.showKeyStar = YES;
        config.onlyShow = YES;
        [temp addObject:config];

        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"MAOLJbCr", @"省");
        config.valuePlaceHold = PNLocalizedString(@"please_enter", @"请输入");
        config.showKeyStar = YES;
        config.editType = PNSTransferFormValueEditTypeDrop;
        config.valueText = self.uploadModel.province;
        //    config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
        //        @HDStrongify(self);
        //        self.uploadModel.province = targetConfig.valueText;
        //        [self checkSaveBtnEanbled];
        //    };

        config.valueContainerClickCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            HDLog(@"省");
            @HDStrongify(self);
            [self selectChianCity:targetConfig];
        };
        self.provinceConfig = config;
        [temp addObject:config];

        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"WFLBHUE4", @"城市");
        config.valuePlaceHold = PNLocalizedString(@"please_enter", @"请输入");
        config.showKeyStar = YES;
        config.editType = PNSTransferFormValueEditTypeDrop;
        config.valueText = self.uploadModel.city;
        //    config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
        //        @HDStrongify(self);
        //        self.uploadModel.city = targetConfig.valueText;
        //        [self checkSaveBtnEanbled];
        //    };
        config.valueContainerClickCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            HDLog(@"城市");
            @HDStrongify(self);
            [self selectChianCity:targetConfig];
        };
        self.cityConfig = config;
        [temp addObject:config];

        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"LQPsLBJh", @"地址");
        config.valuePlaceHold = PNLocalizedString(@"please_enter", @"请输入");
        config.showKeyStar = YES;
        config.editType = PNSTransferFormValueEditTypeEnter;
        config.valueText = self.uploadModel.address;
        config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            self.uploadModel.address = targetConfig.valueText;
            [self checkSaveBtnEanbled];
        };
        [temp addObject:config];

        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"lYXV87bl", @"与转账人关系");
        config.valuePlaceHold = PNLocalizedString(@"please_select", @"请选择");
        config.showKeyStar = YES;
        config.editType = PNSTransferFormValueEditTypeDrop;
        config.valueText = self.uploadModel.relationCode;
        config.associateString = kRelationConfigTag;
        config.valueContainerClickCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            if (!HDIsArrayEmpty(self.relationList)) {
                [self showRelationAlertView:targetConfig];
            } else {
                @HDWeakify(self);
                [self.view showloading];
                [self.reciverDto queryRelationListSuccess:^(NSArray<PNInterTransferRelationModel *> *_Nonnull list) {
                    @HDStrongify(self);
                    [self.view dismissLoading];
                    self.relationList = list;
                    [self showRelationAlertView:targetConfig];
                } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
                    @HDStrongify(self);
                    [self.view dismissLoading];
                }];
            }
        };
        [temp addObject:config];

        //是否选泽了 其它关系
        if (HDIsStringNotEmpty(self.uploadModel.relationType) && [self.uploadModel.relationType isEqualToString:@"OTHER"]) {
            if (![temp containsObject:self.otherRelationConfig]) {
                [temp addObject:self.otherRelationConfig];
            }
        }

        sectionModel.list = temp;
        [self.dataArr addObject:sectionModel];
    }

    [self checkSaveBtnEanbled];
}

/** @lazy otherRelationConfig */
- (PNTransferFormConfig *)otherRelationConfig {
    if (!_otherRelationConfig) {
        PNTransferFormConfig *config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"nRb6CYfa", @"其它关系");
        config.valuePlaceHold = PNLocalizedString(@"please_enter", @"请输入");
        config.editType = PNSTransferFormValueEditTypeEnter;
        config.showKeyStar = YES;
        config.valueText = self.uploadModel.otherRelation;
        config.keyFont = HDAppTheme.PayNowFont.standard12;
        @HDWeakify(self);
        config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            self.uploadModel.otherRelation = targetConfig.valueText;
            [self checkSaveBtnEanbled];
        };
        _otherRelationConfig = config;
    }
    return _otherRelationConfig;
}

/** @lazy dataArr */
- (NSMutableArray<HDTableViewSectionModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

/** @lazy reciverDto */
- (PNInterTransferReciverDTO *)reciverDto {
    if (!_reciverDto) {
        _reciverDto = [[PNInterTransferReciverDTO alloc] init];
    }
    return _reciverDto;
}

/** @lazy uploadModel */
- (PNInterTransferReciverModel *)uploadModel {
    if (!_uploadModel) {
        _uploadModel = [[PNInterTransferReciverModel alloc] init];
        _uploadModel.nationality = PNLocalizedString(@"SMSpgXLZ", @"中国");
    }
    return _uploadModel;
}
@end
