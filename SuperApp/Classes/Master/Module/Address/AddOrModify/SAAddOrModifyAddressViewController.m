//
//  SAAddOrModifyAddressViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/5/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressViewController.h"
#import "SAAddOrModifyAddressContactView.h"
#import "SAAddOrModifyAddressDemoView.h"
#import "SAAddOrModifyAddressIsDefaultView.h"
#import "SAAddOrModifyAddressLocationView.h"
#import "SAAddOrModifyAddressPhoneView.h"
#import "SAAddOrModifyAddressTagsView.h"
#import "SAAddOrModifyAddressTakePhotoView.h"
#import "SAAddOrModifyAddressValidateCodeView.h"
#import "SAAddOrModifyAddressView.h"
#import "SAAddOrModifyConsigneeAddressView.h"
#import "SAAddressModel.h"
#import "SAApolloManager.h"
#import "SACheckMobileValidRspModel.h"
#import "SAPhoneFormatValidator.h"
#import "SAShoppingAddressDTO.h"
#import "SAUploadImageDTO.h"
#import "SAAppSwitchManager.h"


@interface SAAddOrModifyAddressViewController ()
/// 当前定位地址
@property (nonatomic, strong) SAAddOrModifyAddressLocationView *locationView;
/// 信息卡片
@property (nonatomic, strong) UIView *infoView;
/// 照片卡片
@property (nonatomic, strong) UIView *photoView;

@property (nonatomic, strong) SAAddOrModifyAddressView *addressView;
@property (nonatomic, strong) SAAddOrModifyAddressContactView *contactView;
@property (nonatomic, strong) SAAddOrModifyConsigneeAddressView *consigneeAddressView;
@property (nonatomic, strong) SAAddOrModifyAddressPhoneView *phoneView;
//@property (nonatomic, strong) SAAddOrModifyAddressValidateCodeView *validateCodeView;

@property (nonatomic, copy) NSString *validateCode;

@property (nonatomic, strong) SAAddOrModifyAddressTagsView *tagsView;
@property (nonatomic, strong) SAAddOrModifyAddressTakePhotoView *takePhotoView;
@property (nonatomic, strong) SAAddOrModifyAddressIsDefaultView *isDefaultView;
/// 样例
@property (nonatomic, strong) SAAddOrModifyAddressDemoView *demoView;
/// 模型
@property (nonatomic, strong) SAShoppingAddressModel *model;
/// 删除按钮
@property (nonatomic, strong) HDUIButton *deleteBTN;
/// 提交按钮
@property (nonatomic, strong) HDUIButton *submitBTN;
/// 上传图片 VM
@property (nonatomic, strong) SAUploadImageDTO *uploadImageDTO;
/// 地址 DTO
@property (nonatomic, strong) SAShoppingAddressDTO *addressDTO;
/// 当前选择的地址模型
@property (nonatomic, weak) SAAddressModel *currentAddressModel;
@property (nonatomic, copy) void (^addOrModifyAddressBlock)(SAShoppingAddressModel *addressModel);
/// 是否不需要主动pop
@property (nonatomic, assign) BOOL notNeedPop;
@property (nonatomic, assign) BOOL needCheckPhoneValid; ///< 需要检查手机号是否有效
@end


@implementation SAAddOrModifyAddressViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    self.model = parameters[@"model"];

    void (^callback)(SAShoppingAddressModel *) = parameters[@"callback"];
    self.addOrModifyAddressBlock = callback;
    self.currentAddressModel = parameters[@"currentAddressModel"];
    self.notNeedPop = [parameters[@"notNeedPop"] boolValue];
    self.needCheckPhoneValid = NO;
    self.validateCode = @"";
    return self;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.color.G5;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollView addSubview:self.locationView];
    [self.scrollView addSubview:self.infoView];
    [self.scrollView addSubview:self.photoView];
    [self.infoView addSubview:self.addressView];
    [self.infoView addSubview:self.consigneeAddressView];
    [self.infoView addSubview:self.contactView];
    [self.infoView addSubview:self.phoneView];
    //    [self.infoView addSubview:self.validateCodeView];
    [self.infoView addSubview:self.tagsView];
    [self.infoView addSubview:self.isDefaultView];
    [self.photoView addSubview:self.takePhotoView];
    [self.photoView addSubview:self.demoView];

    [self.view addSubview:self.submitBTN];

    [self setupLocation];
}

- (void)hd_setupNavigation {
    if (self.model) {
        self.boldTitle = SALocalizedString(@"edit_address", @"修改地址");
        self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.deleteBTN]];
    } else {
        self.boldTitle = SALocalizedString(@"add_address", @"添加地址");
    }
    self.hd_navTitleColor = HDAppTheme.color.G1;
    self.hd_backButtonImage = [UIImage imageNamed:@"icon_back_black"];
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.submitBTN.mas_top);
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self.locationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.locationView.isHidden) {
            make.top.equalTo(self.scrollViewContainer).offset(kRealWidth(6));
            make.left.equalTo(self.scrollViewContainer).offset(kRealWidth(10));
            make.centerX.equalTo(self.scrollViewContainer);
        }
    }];
    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.locationView.isHidden) {
            make.top.equalTo(self.scrollViewContainer).offset(kRealWidth(10));
        } else {
            make.top.equalTo(self.locationView.mas_bottom).offset(kRealWidth(6));
        }
        make.left.equalTo(self.scrollViewContainer).offset(kRealWidth(10));
        make.centerX.equalTo(self.scrollViewContainer);
    }];
    [self.contactView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.infoView);
    }];
    [self.phoneView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contactView.mas_bottom);
        make.left.right.equalTo(self.infoView);
    }];

    //    if (!self.validateCodeView.isHidden) {
    //        [self.validateCodeView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //            make.top.equalTo(self.phoneView.mas_bottom);
    //            make.left.right.equalTo(self.infoView);
    //        }];
    //    }

    [self.addressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        if (!self.validateCodeView.isHidden) {
        //            make.top.equalTo(self.validateCodeView.mas_bottom);
        //        } else {
        make.top.equalTo(self.phoneView.mas_bottom);
        //        }

        make.left.right.equalTo(self.infoView);
    }];
    [self.consigneeAddressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_bottom);
        make.left.right.equalTo(self.infoView);
    }];
    [self.tagsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.consigneeAddressView.mas_bottom);
        make.left.right.equalTo(self.infoView);
    }];
    [self.isDefaultView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagsView.mas_bottom);
        make.left.right.equalTo(self.infoView);
        make.bottom.equalTo(self.infoView);
    }];
    [self.photoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(kRealWidth(6));
        make.left.right.equalTo(self.infoView);
        make.bottom.equalTo(self.scrollViewContainer).offset(-kRealWidth(45));
    }];
    [self.takePhotoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoView);
        make.left.right.equalTo(self.photoView);
    }];
    [self.demoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.takePhotoView.mas_bottom);
        make.bottom.equalTo(self.photoView);
        make.left.right.equalTo(self.photoView);
    }];
    [self.submitBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
        make.bottom.equalTo(self.view).offset(-kRealWidth(41));
        make.left.equalTo(self.view).offset(kRealWidth(25));
        make.centerX.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

- (void)setupLocation {
    // 不是新增地址，不展示当前定位地址，直接返回
    if (self.model) {
        return;
    }
    // 当前定位无效，直接返回
    if (!HDLocationManager.shared.isCurrentCoordinate2DValid) {
        return;
    }
    CLLocationCoordinate2D coordinate2D = HDLocationManager.shared.coordinate2D;
    [SALocationUtil transferCoordinateToAddress:coordinate2D
                                     completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary) {
                                         if (HDIsStringNotEmpty(address)) {
                                             SAAddressModel *addressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
                                             addressModel.lat = @(coordinate2D.latitude);
                                             addressModel.lon = @(coordinate2D.longitude);
                                             addressModel.address = address;
                                             addressModel.consigneeAddress = consigneeAddress;
                                             addressModel.fromType = SAAddressModelFromTypeLocate;
                                             self.locationView.hidden = false;
                                             self.locationView.addressModel = addressModel;
                                             [self.view setNeedsUpdateConstraints];
                                         }
                                     }];
}

#pragma mark - Data
- (void)uploadImagesCompletion:(void (^)(NSArray<NSString *> *imgUrlArray))completion {
    NSArray<UIImage *> *images = [self.takePhotoView.selectedPhotos mapObjectsUsingBlock:^UIImage *_Nonnull(HXPhotoModel *_Nonnull model, NSUInteger idx) {
        return model.previewPhoto ?: model.thumbPhoto;
    }];

    HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self.view];
    [self.uploadImageDTO batchUploadImages:images progress:^(NSProgress *_Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
        });
    } success:^(NSArray *_Nonnull imageURLArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud showSuccessNotCreateNew:SALocalizedString(@"upload_completed", @"上传完毕")];
        });
        !completion ?: completion(imageURLArray);
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        [hud hideAnimated:true];
    }];
}

- (BOOL)checkIsOperationValid {
    if (self.addressView.addressModel.isNeedCompleteAddress) {
        [NAT showToastWithTitle:nil content:SALocalizedString(@"1qlk3HjQ", @"请补充完善地址信息。") type:HDTopToastTypeError];
        return false;
    }
    if (self.addressView.addressModel.address.length <= 0) {
        [NAT showToastWithTitle:nil content:SALocalizedString(@"address_tip_choose_address", @"请选择地址") type:HDTopToastTypeError];
        return false;
    }
    if (self.contactView.nameTF.text.length <= 0) {
        [NAT showToastWithTitle:nil content:SALocalizedString(@"address_tip_input_name", @"请输入姓名") type:HDTopToastTypeError];
        return false;
    }
    if (!self.contactView.selectedBTN) {
        [NAT showToastWithTitle:nil content:SALocalizedString(@"address_tip_choose_gender", @"请选择性别") type:HDTopToastTypeError];
        return false;
    }
    if (self.phoneView.phoneNumberTF.validInputText.length <= 0) {
        [NAT showToastWithTitle:nil content:SALocalizedString(@"address_tip_input_phone", @"请输入号码") type:HDTopToastTypeError];
        return false;
    }

    if (![SAPhoneFormatValidator isCambodia:self.phoneView.phoneNumberTF.validInputText]) {
        [NAT showToastWithTitle:nil content:SALocalizedString(@"adress_tips_phone_format_error", @"请输入正确的号码") type:HDTopToastTypeError];
        return false;
    }

    //    if (!self.validateCodeView.isHidden && (HDIsStringEmpty(self.validateCodeView.validateCode) || self.validateCodeView.validateCode.length < 6)) {
    //        [NAT showToastWithTitle:nil content:SALocalizedString(@"input_correct_opt", @"请输入正确的验证码") type:HDTopToastTypeError];
    //        return false;
    //    }

    return true;
}

#pragma mark - event response
- (void)clickedAddressViewHandler {
    if (HDIsStringNotEmpty(self.phoneView.phoneNumberTF.validInputText) && ![SAPhoneFormatValidator isCambodia:self.phoneView.phoneNumberTF.validInputText]) {
        [self.phoneView.phoneNumberTF becomeFirstResponder];
        [NAT showToastWithTitle:nil content:SALocalizedString(@"adress_tips_phone_format_error", @"请输入正确的号码") type:HDTopToastTypeError];
        return;
    }

    void (^callback)(SAAddressModel *) = ^(SAAddressModel *addressModel) {
        self.currentAddressModel = addressModel;
        self.addressView.addressModel = addressModel;
        self.consigneeAddressView.consigneeAddress = addressModel.consigneeAddress;
    };
    SAChooseAddressMapGeocodeType style = SAChooseAddressMapGeocodeTypeDefault;
    NSString *buttonTitle = nil;
    NSString *addOrModifyswitch = [SAApolloManager getApolloConfigForKey:ApolloConfigKeyAppSelectAddressInMapForAddOrModify];
    if ([addOrModifyswitch isEqualToString:@"on"]) {
        style = SAChooseAddressMapGeocodeTypeOnce;
        buttonTitle = SALocalizedString(@"choose_receiving_address", @"选择收货地址");
    }
    if (self.model) {
        // 修改逻辑
        SAAddressModel *addressModel = SAAddressModel.new;
        addressModel.lat = self.model.latitude;
        addressModel.lon = self.model.longitude;
        [HDMediator.sharedInstance
            navigaveToChooseAddressInMapViewController:@{@"callback": callback, @"currentAddressModel": self.currentAddressModel ?: addressModel, @"style": @(style), @"buttonTitle": buttonTitle}];
    } else {
        [HDMediator.sharedInstance
            navigaveToChooseAddressInMapViewController:@{@"callback": callback, @"currentAddressModel": self.currentAddressModel, @"style": @(style), @"buttonTitle": buttonTitle}];
    }
}

- (void)clickedDeleteButtonHandler {
    [NAT showAlertWithMessage:SALocalizedString(@"confirm_to_delete_address", @"确认删除地址？") confirmButtonTitle:SALocalizedStringFromTable(@"confirm", @"确认", @"Buttons")
        confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];

            [self showloading];
            @HDWeakify(self);
            [self.addressDTO removeAddressWithAddressNo:self.model.addressNo success:^{
                @HDStrongify(self);
                [self dismissLoading];
                [self dismissAnimated:true completion:nil];
            } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
                @HDStrongify(self);
                [self dismissLoading];
            }];
        }
        cancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
        }];
}

- (void)clickedSubmitButtonHandler {
    // 检查有效性
    if ([self checkIsOperationValid]) {
        if (self.needCheckPhoneValid) {
            NSString *phoneNumber = self.phoneView.phoneNumberTF.validInputText;
            if (![phoneNumber hasPrefix:@"0"]) {
                phoneNumber = [@"0" stringByAppendingString:phoneNumber];
            }
            NSString *accountNo = phoneNumber.mutableCopy;
            phoneNumber = [NSString stringWithFormat:@"855%@", phoneNumber];
            @HDWeakify(self);
            [self.addressDTO checkConsigneeMobileIsValidWithMobile:phoneNumber success:^(SACheckMobileValidRspModel *_Nonnull rspModel) {
                @HDStrongify(self);
                if (rspModel.isNeedSms) {
                    void (^callBack)(NSString *str) = ^(NSString *str) {
                        if (str.length)
                            self.validateCode = str;
                        [self checkIsNeedUploadImage];
                    };
                    NSMutableDictionary *params = @{@"countryCode": @"855", @"accountNo": accountNo, @"smsCodeType": SASendSMSTypeValidateConsigneeMobile, @"callBack": callBack}.mutableCopy;


                    NSString *switchLine = [SAAppSwitchManager.shared switchForKey:SAAppSwitchNewLoginPage];
                    if (switchLine && [switchLine isEqualToString:@"on"]) {
                        [HDMediator.sharedInstance navigaveToVerificationCodeViewController:params];
                    } else {
                        [HDMediator.sharedInstance navigaveToLoginByVerificationCodeViewController:params];
                    }
                } else {
                    [self checkIsNeedUploadImage];
                }
            } failure:nil];
        } else {
            [self checkIsNeedUploadImage];
        }
    }
}

#pragma mark - private methods
- (void)checkIsNeedUploadImage {
    if (self.takePhotoView.selectedPhotos.count > 0) {
        // 上传图片
        [self uploadImagesCompletion:^(NSArray<NSString *> *imgUrlArray) {
            [self finalSubmit:imgUrlArray];
        }];
    } else {
        [self finalSubmit:nil];
    }
}

- (void)finalSubmit:(NSArray<NSString *> *_Nullable)imageURLArray {
    [self.navigationController.view showloading];

    SAShoppingAddressModel *model = SAShoppingAddressModel.new;
    model.consigneeName = self.contactView.nameTF.text;
    model.address = self.addressView.addressModel.address;
    model.consigneeAddress = self.consigneeAddressView.addressDetailTV.text;
    model.country = self.addressView.addressModel.country;
    model.state = self.addressView.addressModel.state;
    model.city = self.addressView.addressModel.city;
    model.subLocality = self.addressView.addressModel.subLocality;
    model.street = self.addressView.addressModel.street;
    model.shortName = self.addressView.addressModel.shortName;
    model.isDefault = self.isDefaultView.isDefaultAddressSwitch.isOn ? SABoolValueTrue : SABoolValueFalse;
    model.gender = self.contactView.selectedBTN.hd_associatedObject;
    model.provinceCode = self.addressView.addressModel.provinceCode;
    model.districtCode = self.addressView.addressModel.districtCode;
    model.communeCode = self.addressView.addressModel.communeCode;

    NSString *phoneNumber = self.phoneView.phoneNumberTF.validInputText;
    if (![phoneNumber hasPrefix:@"0"]) {
        phoneNumber = [@"0" stringByAppendingString:phoneNumber];
    }
    model.mobile = [NSString stringWithFormat:@"855%@", phoneNumber];
    model.areaCode = @"855";
    if (!HDIsArrayEmpty(imageURLArray)) {
        model.imageURLs = imageURLArray;
    }
    model.latitude = self.addressView.addressModel.lat;
    model.longitude = self.addressView.addressModel.lon;
    if (self.tagsView.selectedBTN) {
        NSString *tag = self.tagsView.selectedBTN.hd_associatedObject;
        model.tags = @[tag.uppercaseString];
    }
    @HDWeakify(self);
    if (!self.model) {
        [self.addressDTO addAddressWithModel:model smsCode:self.validateCode success:^(SAShoppingAddressModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self.navigationController.view dismissLoading];
            !self.addOrModifyAddressBlock ?: self.addOrModifyAddressBlock(rspModel);
            if (self.navigationController.viewControllers.lastObject != self) {
                NSInteger count = self.navigationController.viewControllers.count;
                if (count > 2) {
                    [self.navigationController popToViewController:self.navigationController.viewControllers[count - 3] animated:YES];
                } else {
                    [self dismissAnimated:true completion:nil];
                }
            } else {
                [self dismissAnimated:true completion:nil];
            }
        } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
            @HDStrongify(self);
            [self.navigationController.view dismissLoading];
        }];
    } else {
        model.addressNo = self.model.addressNo;
        [self.addressDTO modifyAddressWithModel:model smsCode:self.validateCode success:^{
            @HDStrongify(self);
            [self.navigationController.view dismissLoading];

            ///更新上次地址缓存
            SAShoppingAddressModel *savedAddressModel = [SACacheManager.shared objectForKey:kCacheKeyUserLastOrderSubmitChoosedCurrentAddress type:SACacheTypeDocumentNotPublic];

            if ([savedAddressModel.addressNo isEqualToString:model.addressNo]) {
                [SACacheManager.shared setObject:model forKey:kCacheKeyUserLastOrderSubmitChoosedCurrentAddress type:SACacheTypeDocumentNotPublic];
            }

            !self.addOrModifyAddressBlock ?: self.addOrModifyAddressBlock(model);
            if (!self.notNeedPop) {
                if (self.navigationController.viewControllers.lastObject != self) {
                    NSInteger count = self.navigationController.viewControllers.count;
                    if (count > 2) {
                        [self.navigationController popToViewController:self.navigationController.viewControllers[count - 3] animated:YES];
                    } else {
                        [self dismissAnimated:true completion:nil];
                    }
                } else {
                    [self dismissAnimated:true completion:nil];
                }
            }
        } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
            @HDStrongify(self);
            [self.navigationController.view dismissLoading];
        }];
    }
}

- (void)chooseLocationAddress:(SAAddressModel *)addressModel {
    if (HDIsObjectNil(addressModel)) {
        return;
    }
    if (HDIsStringNotEmpty(addressModel.address)) {
        self.addressView.addressModel = addressModel;
    }
    self.consigneeAddressView.consigneeAddress = addressModel.consigneeAddress;
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (HDUIButton *)deleteBTN {
    if (!_deleteBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:SALocalizedStringFromTable(@"delete", @"删除", @"Buttons") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedDeleteButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:HDAppTheme.color.C1 forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.standard3;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        _deleteBTN = button;
    }
    return _deleteBTN;
}

- (HDUIButton *)submitBTN {
    if (!_submitBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = self.model ? SALocalizedStringFromTable(@"confirm", @"确认", @"Buttons") : SALocalizedStringFromTable(@"address_submit", @"提交", @"Buttons");
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedSubmitButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:HDAppTheme.color.C1];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.layer.cornerRadius = 22.5;
        button.titleLabel.font = HDAppTheme.font.standard2Bold;
        _submitBTN = button;
    }
    return _submitBTN;
}

- (SAUploadImageDTO *)uploadImageDTO {
    return _uploadImageDTO ?: ({ _uploadImageDTO = SAUploadImageDTO.new; });
}

- (SAShoppingAddressDTO *)addressDTO {
    return _addressDTO ?: ({ _addressDTO = SAShoppingAddressDTO.new; });
}

- (SAAddOrModifyAddressView *)addressView {
    if (!_addressView) {
        _addressView = SAAddOrModifyAddressView.new;
        if (!HDIsObjectNil(self.model) && HDIsStringNotEmpty(self.model.address)) {
            SAAddressModel *addressModel = [SAAddressModel addressModelWithShoppingAddressModel:self.model];
            _addressView.addressModel = addressModel;
        }
        // 添加手势
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedAddressViewHandler)];
        [_addressView addGestureRecognizer:recognizer];
    }
    return _addressView;
}

- (SAAddOrModifyConsigneeAddressView *)consigneeAddressView {
    if (!_consigneeAddressView) {
        _consigneeAddressView = SAAddOrModifyConsigneeAddressView.new;
        if (!HDIsObjectNil(self.model)) {
            _consigneeAddressView.consigneeAddress = self.model.consigneeAddress;
        }
    }
    return _consigneeAddressView;
}

- (SAAddOrModifyAddressContactView *)contactView {
    if (!_contactView) {
        _contactView = SAAddOrModifyAddressContactView.new;
        if (!HDIsObjectNil(self.model)) {
            _contactView.gender = self.model.gender;
            _contactView.consigneeName = self.model.consigneeName;
        }
    }
    return _contactView;
}

- (SAAddOrModifyAddressPhoneView *)phoneView {
    if (!_phoneView) {
        _phoneView = SAAddOrModifyAddressPhoneView.new;
        if (!HDIsObjectNil(self.model) && HDIsStringNotEmpty(self.model.mobile)) {
            _phoneView.mobile = [SAGeneralUtil getShortAccountNoFromFullAccountNo:self.model.mobile];
        }
        @HDWeakify(self);
        _phoneView.phoneNoDidChanged = ^(NSString *_Nonnull phoneNo) {
            @HDStrongify(self);
            NSString *tmp = @"855";
            if ([[phoneNo stringByReplacingOccurrencesOfString:@" " withString:@""] hasPrefix:@"0"]) {
                tmp = [@"855" stringByAppendingString:[phoneNo stringByReplacingOccurrencesOfString:@" " withString:@""]];
            } else {
                tmp = [@"8550" stringByAppendingString:[phoneNo stringByReplacingOccurrencesOfString:@" " withString:@""]];
            }
            if ((self.model && [tmp isEqualToString:self.model.mobile])) {
                HDLog(@"手机号码没有变化，不需要验证");
                self.needCheckPhoneValid = NO;
                //                self.validateCodeView.hidden = YES;
                //                [self.view setNeedsUpdateConstraints];

            } else {
                HDLog(@"手机号码发生改变:%@，隐藏验证码输入框，重新验证", phoneNo);
                self.needCheckPhoneValid = YES; // 号码发生改版，需要重新检查
                //                self.validateCodeView.hidden = YES;
                //                [self.view setNeedsUpdateConstraints];
            }
        };

        _phoneView.phoneNoDidEndEditing = ^(NSString *_Nonnull phoneNo) {
            HDLog(@"结束编辑:%@", phoneNo);
            @HDStrongify(self);
            if (![SAPhoneFormatValidator isCambodia:phoneNo]) {
                [self.phoneView.phoneNumberTF becomeFirstResponder];
                [NAT showToastWithTitle:nil content:SALocalizedString(@"adress_tips_phone_format_error", @"请输入正确的号码") type:HDTopToastTypeError];
                return;
            }
        };
    }
    return _phoneView;
}

//- (SAAddOrModifyAddressValidateCodeView *)validateCodeView {
//    if (!_validateCodeView) {
//        _validateCodeView = SAAddOrModifyAddressValidateCodeView.new;
//        _validateCodeView.hidden = YES;
//    }
//    return _validateCodeView;
//}

- (SAAddOrModifyAddressTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = SAAddOrModifyAddressTagsView.new;
        if (!HDIsObjectNil(self.model) && !HDIsArrayEmpty(self.model.tags)) {
            _tagsView.tags = self.model.tags;
        }
    }
    return _tagsView;
}

- (SAAddOrModifyAddressIsDefaultView *)isDefaultView {
    if (!_isDefaultView) {
        _isDefaultView = SAAddOrModifyAddressIsDefaultView.new;
        if (!HDIsObjectNil(self.model)) {
            _isDefaultView.isDefault = [self.model.isDefault isEqualToString:SABoolValueTrue];
        }
    }
    return _isDefaultView;
}
- (SAAddOrModifyAddressTakePhotoView *)takePhotoView {
    if (!_takePhotoView) {
        _takePhotoView = SAAddOrModifyAddressTakePhotoView.new;
        if (!HDIsObjectNil(self.model) && !HDIsArrayEmpty(self.model.imageURLs)) {
            _takePhotoView.imageURLs = self.model.imageURLs;
        }
    }
    return _takePhotoView;
}
- (SAAddOrModifyAddressDemoView *)demoView {
    if (!_demoView) {
        _demoView = [[SAAddOrModifyAddressDemoView alloc] init];
    }
    return _demoView;
}
- (SAAddOrModifyAddressLocationView *)locationView {
    if (!_locationView) {
        _locationView = SAAddOrModifyAddressLocationView.new;
        _locationView.layer.cornerRadius = 10;
        _locationView.hidden = true;
        @HDWeakify(self);
        _locationView.chooseLocationAddress = ^(SAAddressModel *_Nonnull addressModel) {
            @HDStrongify(self);
            [self chooseLocationAddress:addressModel];
        };
    }
    return _locationView;
}

- (UIView *)infoView {
    if (!_infoView) {
        _infoView = UIView.new;
        _infoView.backgroundColor = UIColor.whiteColor;
        _infoView.layer.cornerRadius = 10;
    }
    return _infoView;
}

- (UIView *)photoView {
    if (!_photoView) {
        _photoView = UIView.new;
        _photoView.backgroundColor = UIColor.whiteColor;
        _photoView.layer.cornerRadius = 10;
    }
    return _photoView;
}

@end
