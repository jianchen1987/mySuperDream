//
//  SAMyInfomationView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMyInfomationView.h"
#import "SAAppleIDSignInProvider.h"
#import "SADatePickerViewController.h"
#import "SAImageAccessor.h"
#import "SAInfoView.h"
#import "SALoginViewModel.h"
#import "SAMyInfomationViewModel.h"
#import "SAPayHelper.h"
#import "SAUpdateUserInfoViewModel.h"
#import "SAUploadImageDTO.h"
#import "SAUserCenterDTO.h"
#import "SAWechatGetAccessTokenRspModel.h"
#import "WXApiManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface SAMyInfomationView () <SADatePickerViewDelegate, SAAppleIDSignInProvider>
/// 头像
@property (nonatomic, strong) SAInfoView *headImageView;
/// 昵称
@property (nonatomic, strong) SAInfoView *nickNameView;
/// 手机号码
@property (nonatomic, strong) SAInfoView *phoneNumberView;
/// 邮箱
@property (nonatomic, strong) SAInfoView *emailView;
/// 性别
@property (nonatomic, strong) SAInfoView *genderView;
/// 生日
@property (nonatomic, strong) SAInfoView *birthdayView;
///职业
@property (nonatomic, strong) SAInfoView *professionView;
@property (nonatomic, strong) SAInfoView *educationView; ///< 学历
/// 社会化渠道标题
@property (nonatomic, strong) SALabel *socialViewTitleLB;
/// Facebook
@property (nonatomic, strong) SAInfoView *facebookView;
/// gmail
@property (nonatomic, strong) SAInfoView *gmailView;
/// Twitter
@property (nonatomic, strong) SAInfoView *twitterView;
/// Wechat
@property (nonatomic, strong) SAInfoView *wechatView;
/// Apple Id
@property (nonatomic, strong) SAInfoView *appleIdView;
/// 上传图片 VM
@property (nonatomic, strong) SAUploadImageDTO *uploadImageDTO;
/// 更新用户资料 VM
@property (nonatomic, strong) SAUpdateUserInfoViewModel *updateUserInfoViewModel;
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
/// 登录 VM
@property (nonatomic, strong) SALoginViewModel *loginVM;
/// VM
@property (nonatomic, strong) SAMyInfomationViewModel *viewModel;
/// 图片获取
@property (nonatomic, strong) SAImageAccessor *imageAccessor;
/// apple id
@property (nonatomic, strong) SAAppleIDSignInProvider *appleIDSignInProvider;
@property (nonatomic, strong) SAUserCenterDTO *userDTO; ///< 用户中心DTO

@end


@implementation SAMyInfomationView

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.headImageView];
    [self.scrollViewContainer addSubview:self.nickNameView];
    [self.scrollViewContainer addSubview:self.phoneNumberView];
    [self.scrollViewContainer addSubview:self.emailView];
    [self.scrollViewContainer addSubview:self.genderView];
    [self.scrollViewContainer addSubview:self.birthdayView];
    [self.scrollViewContainer addSubview:self.professionView];
    [self.scrollViewContainer addSubview:self.educationView];
    [self.scrollViewContainer addSubview:self.socialViewTitleLB];
    [self.scrollViewContainer addSubview:self.facebookView];
    [self.scrollViewContainer addSubview:self.gmailView];
    [self.scrollViewContainer addSubview:self.twitterView];
    [self.scrollViewContainer addSubview:self.wechatView];
    [self.scrollViewContainer addSubview:self.appleIdView];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(receiveWechatAuthLoginResp:) name:kNotificationWechatAuthLoginResponse object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationWechatAuthLoginResponse object:nil];
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"userInfoRspModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        SAGetUserInfoRspModel *userInfoRspModel = change[NSKeyValueChangeNewKey];
        if (!HDIsObjectNil(userInfoRspModel)) {
            if (HDIsStringNotEmpty(userInfoRspModel.headURL)) {
                self.headImageView.model.valueImageURL = userInfoRspModel.headURL;
                [self.headImageView setNeedsUpdateContent];
            }
            if (HDIsStringNotEmpty(userInfoRspModel.nickName)) {
                self.nickNameView.model.valueText = userInfoRspModel.nickName;
                self.nickNameView.model.valueColor = HDAppTheme.color.G2;
                [self.nickNameView setNeedsUpdateContent];
            }
            if (HDIsStringNotEmpty(userInfoRspModel.email)) {
                self.emailView.model.valueText = userInfoRspModel.email;
                self.emailView.model.valueColor = [UIColor hd_colorWithHexString:@"#ADB6C8"];
                [self.emailView setNeedsUpdateContent];
            }
            if (HDIsStringNotEmpty(userInfoRspModel.gender)) {
                self.genderView.model.valueText = [userInfoRspModel.gender isEqualToString:SAGenderMale] ? SALocalizedString(@"male", @"男性") : SALocalizedString(@"female", @"女性");
                self.genderView.model.valueColor = [UIColor hd_colorWithHexString:@"#ADB6C8"];
                [self.genderView setNeedsUpdateContent];
            }
            if (HDIsStringNotEmpty(userInfoRspModel.birthday)) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:userInfoRspModel.birthday.integerValue / 1000.0];
                NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy"];
                self.birthdayView.model.valueText = dateStr;
                self.birthdayView.model.valueColor = [UIColor hd_colorWithHexString:@"#ADB6C8"];
                [self.birthdayView setNeedsUpdateContent];
            }
            if (HDIsStringNotEmpty(userInfoRspModel.profession)) {
                self.professionView.model.valueText = SALocalizedString(userInfoRspModel.profession, @"职业");
                self.professionView.model.valueColor = [UIColor hd_colorWithHexString:@"#ADB6C8"];
                [self.professionView setNeedsUpdateContent];
            }

            if (HDIsStringNotEmpty(userInfoRspModel.education)) {
                self.educationView.model.valueText = SALocalizedString(userInfoRspModel.education, @"学历");
                self.educationView.model.valueColor = [UIColor hd_colorWithHexString:@"#ADB6C8"];
                [self.educationView setNeedsUpdateContent];
            }

            if (!HDIsArrayEmpty(userInfoRspModel.thirdBindsList)) {
                NSArray<SAUserThirdBindModel *> *filteredAppleIdList = [userInfoRspModel.thirdBindsList hd_filterWithBlock:^BOOL(SAUserThirdBindModel *_Nonnull item) {
                    return [item.channel isEqualToString:SAThirdPartyBindChannelApple];
                }];
                if (!HDIsArrayEmpty(filteredAppleIdList)) {
                    SAUserThirdBindModel *bindModel = filteredAppleIdList.firstObject;
                    self.appleIdView.model.hd_associatedObject = @(1);
                    self.appleIdView.model.valueText = HDIsStringEmpty(bindModel.thirdUserName) ? SALocalizedString(@"Binded", @"已绑定") : bindModel.thirdUserName;
                    [self.appleIdView setNeedsUpdateContent];
                }
                NSArray<SAUserThirdBindModel *> *filteredFacebookList = [userInfoRspModel.thirdBindsList hd_filterWithBlock:^BOOL(SAUserThirdBindModel *_Nonnull item) {
                    return [item.channel isEqualToString:SAThirdPartyBindChannelFacebook];
                }];
                if (!HDIsArrayEmpty(filteredFacebookList)) {
                    SAUserThirdBindModel *bindModel = filteredFacebookList.firstObject;
                    self.facebookView.model.hd_associatedObject = @(1);
                    self.facebookView.model.valueText = HDIsStringEmpty(bindModel.thirdUserName) ? SALocalizedString(@"Binded", @"已绑定") : bindModel.thirdUserName;
                    [self.facebookView setNeedsUpdateContent];
                }
                NSArray<SAUserThirdBindModel *> *filteredWechatList = [userInfoRspModel.thirdBindsList hd_filterWithBlock:^BOOL(SAUserThirdBindModel *_Nonnull item) {
                    return [item.channel isEqualToString:SAThirdPartyBindChannelWechat];
                }];
                if (!HDIsArrayEmpty(filteredWechatList)) {
                    SAUserThirdBindModel *bindModel = filteredWechatList.firstObject;
                    self.wechatView.model.hd_associatedObject = @(1);
                    self.wechatView.model.valueText = HDIsStringEmpty(bindModel.thirdUserName) ? SALocalizedString(@"Binded", @"已绑定") : bindModel.thirdUserName;
                    [self.wechatView setNeedsUpdateContent];
                }
            }
            [self setNeedsUpdateConstraints];
        }
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
                if ([view isKindOfClass:SAInfoView.class]) {
                    SAInfoView *infoView = (SAInfoView *)view;
                    infoView.model.lineWidth = 0;
                    [infoView setNeedsUpdateContent];
                }
            }
        }];
        lastView = view;
    }

    [super updateConstraints];
}

#pragma mark - private methods
- (void)uploadImage:(UIImage *)image {
    HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self];
    [self.uploadImageDTO batchUploadImages:@[image] progress:^(NSProgress *_Nonnull progress) {
        hd_dispatch_main_async_safe(^{
            [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
        });
    } success:^(NSArray *_Nonnull imageURLArray) {
        hd_dispatch_main_async_safe(^{
            [hud showSuccessNotCreateNew:SALocalizedString(@"upload_completed", @"上传完毕")];
            if (imageURLArray.count > 0) {
                [self updateUserHeadURL:imageURLArray.firstObject gender:nil birthday:nil profession:nil education:nil];
            }
        });
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        [hud hideAnimated:true];
    }];
}

- (void)updateUserHeadURL:(NSString *_Nullable)headURL
                   gender:(SAGender _Nullable)gender
                 birthday:(NSString *_Nullable)birthday
               profession:(NSString *_Nullable)profession
                education:(NSString *_Nullable)education {
    [self showloading];
    @HDWeakify(self);
    [self.updateUserInfoViewModel updateUserInfoWithHeadURL:headURL nickName:nil email:nil gender:gender birthday:birthday profession:profession education:education success:^{
        @HDStrongify(self);
        [self dismissLoading];
        if (HDIsStringNotEmpty(headURL)) {
            SAUser.shared.headURL = headURL;
            [SAUser.shared save];

            self.headImageView.model.valueImageURL = headURL;
            [self.headImageView setNeedsUpdateContent];
            [self setNeedsUpdateConstraints];
        }
        [self.viewModel getNewData];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (void)dealingWithThirdAccountBindingForChannel:(SAThirdPartyBindChannel)channel userId:(NSString *)userId userName:(NSString *)userName token:(NSString *)token {
    @HDWeakify(self);
    void (^continueBindingProcessBlock)(void) = ^(void) {
        @HDStrongify(self);
        [self.viewModel updateThirdAccountBindStatusForChannel:channel userName:userName token:token success:^{
            @HDStrongify(self);
            [self dismissLoading];

            [self.viewModel getNewData];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    };

    // 先查询是否已经绑定
    [self showloading];
    [self.loginVM checkThirdPartyAccountBindStatusV2WithChannel:channel userId:userId success:^(SAThirdPartyAccountBindStatusRspModel *_Nonnull rspModel) {
        if (!rspModel.isBind) {
            continueBindingProcessBlock();
        } else {
            @HDStrongify(self);
            [self dismissLoading];
            [NAT showAlertWithMessage:SALocalizedString(@"account_has_binded", @"帐号已绑定") buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                  [alertView dismiss];
                              }];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (void)dealingWithFacebookBinding {
    BOOL hasBinded = [self.facebookView.model.hd_associatedObject boolValue];
    if (hasBinded)
        return;

    FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
    @HDWeakify(self);
    [manager logOut];
    [manager logInWithPermissions:@[@"public_profile", @"email"] fromViewController:self.viewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        @HDStrongify(self);
        HDLog(@"facebook登录结果，权限信息： %@, error = %@", result.grantedPermissions, error);
        if (!error && !result.isCancelled) {
            HDLog(@"获取 token 成功：%@", result.token);
            [FBSDKAccessToken setCurrentAccessToken:result.token];
            [self dealingWithThirdAccountBindingForChannel:SAThirdPartyBindChannelFacebook userId:result.token.userID userName:result.token.userID token:result.token.tokenString];
        }
    }];
}

- (void)dealingWithAppleIdBinding {
    BOOL hasBinded = [self.appleIdView.model.hd_associatedObject boolValue];
    if (hasBinded)
        return;

    if (self.appleIDSignInProvider.isAvailable) {
        [self.appleIDSignInProvider start];
    }
}

- (void)dealingWithWechatIdBinding {
    BOOL hasBind = [self.wechatView.model.hd_associatedObject boolValue];
    if (hasBind)
        return;

    if ([SAPayHelper isSupportWechatPayAppNotInstalledHandler:^{
            [NAT showToastWithTitle:SALocalizedString(@"not_install_wechat", @"未安装微信") content:nil type:HDTopToastTypeError];
        } appNotSupportApiHandler:^{
            [NAT showToastWithTitle:SALocalizedString(@"wechat_not_support", @"当前微信版本不支持此功能") content:nil type:HDTopToastTypeError];
        }]) {
        [WXApiManager.sharedManager sendLoginReqWithViewController:self.viewController];
    }
}

- (void)showChooseGenderAlertView {
    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];

    HDActionSheetViewButton *maleBTN = [HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"male", @"男性") type:HDActionSheetViewButtonTypeCustom
                                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                            [sheetView dismiss];
                                                                            [self updateUserHeadURL:nil gender:SAGenderMale birthday:nil profession:nil education:nil];
                                                                        }];
    HDActionSheetViewButton *femaleBTN = [HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"female", @"女性") type:HDActionSheetViewButtonTypeCustom
                                                                          handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                              [sheetView dismiss];
                                                                              [self updateUserHeadURL:nil gender:SAGenderFemale birthday:nil profession:nil education:nil];
                                                                          }];
    [sheetView addButtons:@[maleBTN, femaleBTN]];
    [sheetView show];
}

- (void)showChooseEducationPickView {
    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];
    NSMutableArray<HDActionSheetViewButton *> *buttons = NSMutableArray.new;

    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"PRIMARY_SCHOOL", @"小学") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:nil education:@"PRIMARY_SCHOOL"];
                                                        }]];
    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"SECONDARY_SCHOOL", @"中学") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:nil education:@"SECONDARY_SCHOOL"];
                                                        }]];
    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"HIGH_SCHOOL", @"高中") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:nil education:@"HIGH_SCHOOL"];
                                                        }]];
    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"BACHELOR_DEGREE", @"大学") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:nil education:@"BACHELOR_DEGREE"];
                                                        }]];
    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"MASTER_DEGREE", @"硕士") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:nil education:@"MASTER_DEGREE"];
                                                        }]];
    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"PHD", @"博士") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:nil education:@"PHD"];
                                                        }]];

    [sheetView addButtons:buttons];
    [sheetView show];
}

- (void)showProfessionPickView {
    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];
    NSMutableArray<HDActionSheetViewButton *> *buttons = NSMutableArray.new;

    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"STUDENT_JOB", @"学生") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:@"STUDENT_JOB" education:nil];
                                                        }]];
    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"EMPLOYEE_JOB", @"员工工作") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:@"EMPLOYEE_JOB" education:nil];
                                                        }]];
    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"PRIVATE_COMPANY_JOB", @"私人公司工作") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:@"PRIVATE_COMPANY_JOB" education:nil];
                                                        }]];
    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"GOVERNMENT_INSTITUTION", @"政府机构") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:@"GOVERNMENT_INSTITUTION" education:nil];
                                                        }]];
    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"ENTREPRENEURSHIP_JOB", @"创业工作") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:@"ENTREPRENEURSHIP_JOB" education:nil];
                                                        }]];
    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"NGO_JOB", @"非政府组织工作") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:@"NGO_JOB" education:nil];
                                                        }]];
    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"CHARITY_JOB", @"慈善工作") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:@"CHARITY_JOB" education:nil];
                                                        }]];
    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"ASSOCIATION_JOB", @"协会工作") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:@"ASSOCIATION_JOB" education:nil];
                                                        }]];
    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"EMBASSY_JOB", @"大使馆工作") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:@"EMBASSY_JOB" education:nil];
                                                        }]];
    [buttons addObject:[HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"EXPATRIATE_JOB", @"外派工作") type:HDActionSheetViewButtonTypeCustom
                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                            [sheetView dismiss];
                                                            [self updateUserHeadURL:nil gender:nil birthday:nil profession:@"EXPATRIATE_JOB" education:nil];
                                                        }]];

    [sheetView addButtons:buttons];
    [sheetView show];
}

- (void)showDatePickerView {
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

    if (HDIsStringNotEmpty(self.birthdayView.model.valueText)) {
        NSString *currDateStr = self.birthdayView.model.valueText;
        [fmt setDateFormat:@"dd/MM/yyyy"];
        NSDate *currDate = [fmt dateFromString:currDateStr];
        if (currDate) {
            [vc setCurrentDate:currDate];
        }
    }
}

#pragma mark - SADatePickerViewDelegate
- (void)datePickerView:(SADatePickerView *)pickerView didSelectDate:(NSString *)dateStr {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"dd-MM-yyyy"];
    [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];

    NSDate *date = [fmt dateFromString:dateStr];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];

    [self updateUserHeadURL:nil gender:nil birthday:[NSString stringWithFormat:@"%.0f", timeInterval * 1000] profession:nil education:nil];
}

#pragma mark - SAAppleIDSignInProvider
- (void)appleIDSignInProvider:(SAAppleIDSignInProvider *)provider
    didCompleteWithCredential:(id<ASAuthorizationCredential>)credential
                         type:(ASAuthorizationCredentialType)type API_AVAILABLE(ios(13.0)) {
    NSString *userName;
    NSString *userId;
    NSString *accessToken;
    if (type == ASAuthorizationCredentialTypeAppleID) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *idCredential = (ASAuthorizationAppleIDCredential *)credential;
        userName = idCredential.email;
        userId = idCredential.user;
        NSData *identityToken = idCredential.identityToken;
        accessToken = [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding];
        // 保存apple返回的唯一标识符
        HDLog(@"user:%@", idCredential.user);
        HDLog(@"userId:%@\naccessToken:%@", userName, accessToken);
    } else if (type == ASAuthorizationCredentialTypePassword) {
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *psdCredential = (ASPasswordCredential *)credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        accessToken = psdCredential.user;
        userName = psdCredential.user;
        userId = psdCredential.user;
    }

    [self dealingWithThirdAccountBindingForChannel:SAThirdPartyBindChannelApple userId:userId userName:userName token:accessToken];
}

- (void)appleIDSignInProvider:(SAAppleIDSignInProvider *)provider didCompleteWithError:(NSError *)error errorMsg:(nonnull NSString *)errorMsg API_AVAILABLE(ios(13.0)) {
    HDLog(@"appleIDSignIn - errorMsg: %@", errorMsg);
}

- (void)appleIDSignInProvider:(SAAppleIDSignInProvider *)provider didReceivedCredentialRevokedNotification:(NSNotification *)notification {
    HDLog(@"didReceivedCredentialRevokedNotification: %@", notification.userInfo);
}

#pragma mark - private methods
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
    model.rightButtonImage = [UIImage imageNamed:@"black_arrow"];
    return model;
}

- (void)handlerChooseHeadImage {
    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];
    @HDWeakify(self);
    SAImageAccessorCompletionBlock block = ^(UIImage *_Nullable image, NSError *_Nullable error) {
        if (image) {
            @HDStrongify(self);
            [self uploadImage:image];
        }
    };

    // clang-format off
    HDActionSheetViewButton *takePhotoBTN = [HDActionSheetViewButton buttonWithTitle:SALocalizedStringFromTable(@"take_photo", @"拍照", @"Buttons") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        @HDStrongify(self);
        [self.imageAccessor fetchImageWithType:SAImageAccessorTypeTakingPhoto completion:block];
    }];
    HDActionSheetViewButton *chooseImageBTN = [HDActionSheetViewButton buttonWithTitle:SALocalizedStringFromTable(@"choose_image", @"选择照片", @"Buttons") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        @HDStrongify(self);
        [self.imageAccessor fetchImageWithType:SAImageAccessorTypeBrowserPhotos completion:block];
    }];
    // clang-format on
    [sheetView addButtons:@[takePhotoBTN, chooseImageBTN]];
    [sheetView show];
}

- (void)receiveWechatAuthLoginResp:(NSNotification *)notification {
    if (!notification.object || ![notification.object isKindOfClass:SendAuthResp.class])
        return;
    SendAuthResp *resp = notification.object;
    if (resp.errCode != WXSuccess)
        return;

    [self showloading];
    @HDWeakify(self);
    [self.userDTO getWechatAccessTokenWithAuthCode:resp.code channel:SAThirdPartyBindChannelWechat success:^(SAWechatGetAccessTokenRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        [self dealingWithThirdAccountBindingForChannel:SAThirdPartyBindChannelWechat userId:rspModel.openId userName:rspModel.nickName token:rspModel.accessToken];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark - lazy load
- (SAInfoView *)headImageView {
    if (!_headImageView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"head_image", @"头像")];
        model.valueImageURL = SAUser.shared.headURL;
        model.needValueImageRounded = true;
        model.valueImagePlaceholderImage = [UIImage imageNamed:@"neutral"];
        model.valueImageSize = CGSizeMake(kRealWidth(50), kRealWidth(50));
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self handlerChooseHeadImage];
        };
        view.model = model;
        _headImageView = view;
    }
    return _headImageView;
}

- (SAInfoView *)nickNameView {
    if (!_nickNameView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"nickname", @"昵称")];
        model.valueText = HDIsStringNotEmpty(SAUser.shared.nickName) ? SAUser.shared.nickName : SALocalizedString(@"set_nickname", @"设置昵称");
        model.valueColor = HDIsStringNotEmpty(SAUser.shared.nickName) ? HDAppTheme.color.G2 : HDAppTheme.color.G4;
        model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToSetNickNameController:nil];
        };
        view.model = model;
        _nickNameView = view;
    }
    return _nickNameView;
}

- (SAInfoView *)phoneNumberView {
    if (!_phoneNumberView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:SALocalizedString(@"phone_number", @"帐号")];
        model.valueText = SAUser.shared.loginName;
        view.model = model;
        _phoneNumberView = view;
    }
    return _phoneNumberView;
}

- (SAInfoView *)emailView {
    if (!_emailView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"email", @"邮箱")];
        model.valueText = HDIsStringNotEmpty(SAUser.shared.email) ? SAUser.shared.email : SALocalizedString(@"please_setup", @"未设置");
        model.valueColor = HDIsStringNotEmpty(SAUser.shared.email) ? [UIColor hd_colorWithHexString:@"#ADB6C8"] : [UIColor hd_colorWithHexString:@"#FA2740"];
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToEmailController:@{@"email": self.emailView.model.valueText}];
        };
        view.model = model;
        _emailView = view;
    }
    return _emailView;
}

- (SAInfoView *)genderView {
    if (!_genderView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"gender", @"性别")];
        if (HDIsStringNotEmpty(SAUser.shared.gender)) {
            model.valueText = [SAUser.shared.gender isEqualToString:SAGenderMale] ? SALocalizedString(@"male", @"男性") : SALocalizedString(@"female", @"女性");
            model.valueColor = [UIColor hd_colorWithHexString:@"#ADB6C8"];
        } else {
            model.valueText = SALocalizedString(@"please_setup", @"未设置");
            model.valueColor = [UIColor hd_colorWithHexString:@"#FA2740"];
        }

        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self showChooseGenderAlertView];
        };
        view.model = model;
        _genderView = view;
    }
    return _genderView;
}

- (SAInfoView *)birthdayView {
    if (!_birthdayView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"birthday", @"生日")];
        if (HDIsStringNotEmpty(SAUser.shared.birthday)) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:SAUser.shared.birthday.integerValue / 1000.0];
            NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy"];
            model.valueText = dateStr;
            model.valueColor = [UIColor hd_colorWithHexString:@"#ADB6C8"];
        } else {
            model.valueText = SALocalizedString(@"please_setup", @"未设置");
            model.valueColor = [UIColor hd_colorWithHexString:@"#FA2740"];
        }

        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self showDatePickerView];
        };
        view.model = model;
        _birthdayView = view;
    }
    return _birthdayView;
}

- (SAInfoView *)professionView {
    if (!_professionView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"career", @"职业")];
        if (HDIsStringNotEmpty(SAUser.shared.profession)) {
            model.valueText = SALocalizedString(SAUser.shared.profession, @"未知");
            model.valueColor = [UIColor hd_colorWithHexString:@"#ADB6C8"];
        } else {
            model.valueText = SALocalizedString(@"please_setup", @"未设置");
            model.valueColor = [UIColor hd_colorWithHexString:@"#FA2740"];
        }

        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self showProfessionPickView];
        };
        view.model = model;
        _professionView = view;
    }
    return _professionView;
}

- (SAInfoView *)educationView {
    if (!_educationView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"education", @"学历")];
        if (HDIsStringNotEmpty(SAUser.shared.education)) {
            model.valueText = SALocalizedString(SAUser.shared.education, @"未知");
            model.valueColor = [UIColor hd_colorWithHexString:@"#ADB6C8"];
        } else {
            model.valueText = SALocalizedString(@"please_setup", @"未设置");
            model.valueColor = [UIColor hd_colorWithHexString:@"#FA2740"];
        }

        model.lineWidth = 0;
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self showChooseEducationPickView];
        };
        view.model = model;
        _educationView = view;
    }
    return _educationView;
}

- (SALabel *)socialViewTitleLB {
    if (!_socialViewTitleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 0;
        label.text = SALocalizedString(@"social_account", @"社交账号");
        label.hd_edgeInsets = UIEdgeInsetsMake(12, 15, 12, 15);
        label.backgroundColor = HDAppTheme.color.G5;
        _socialViewTitleLB = label;
    }
    return _socialViewTitleLB;
}

- (SAInfoView *)facebookView {
    if (!_facebookView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:SALocalizedString(@"facebook", @"Facebook")];
        model.valueText = SALocalizedString(@"not_set", @"未设置");
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self dealingWithFacebookBinding];
        };
        view.model = model;
        _facebookView = view;
    }
    return _facebookView;
}

- (SAInfoView *)gmailView {
    if (!_gmailView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:SALocalizedString(@"google_mail", @"谷歌邮箱")];
        model.valueText = SALocalizedString(@"not_set", @"未设置");
        view.model = model;
        view.hidden = true;
        _gmailView = view;
    }
    return _gmailView;
}

- (SAInfoView *)twitterView {
    if (!_twitterView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:SALocalizedString(@"twitter", @"推特")];
        model.valueText = SALocalizedString(@"not_set", @"未设置");
        view.model = model;
        view.hidden = true;
        _twitterView = view;
    }
    return _twitterView;
}

- (SAInfoView *)wechatView {
    if (!_wechatView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:SALocalizedString(@"wechat", @"微信")];
        model.valueText = SALocalizedString(@"not_set", @"未设置");
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self dealingWithWechatIdBinding];
        };
        view.model = model;
        _wechatView = view;
    }
    return _wechatView;
}

- (SAInfoView *)appleIdView {
    if (!_appleIdView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:SALocalizedString(@"apple_id", @"Apple ID")];
        model.valueText = SALocalizedString(@"not_set", @"未设置");
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self dealingWithAppleIdBinding];
        };
        view.model = model;
        _appleIdView = view;
    }
    return _appleIdView;
}

- (SAImageAccessor *)imageAccessor {
    return _imageAccessor ?: ({ _imageAccessor = [[SAImageAccessor alloc] initWithSourceViewController:self.viewController needCrop:true]; });
}

- (SAUploadImageDTO *)uploadImageDTO {
    return _uploadImageDTO ?: ({ _uploadImageDTO = SAUploadImageDTO.new; });
}

- (SAUpdateUserInfoViewModel *)updateUserInfoViewModel {
    return _updateUserInfoViewModel ?: ({ _updateUserInfoViewModel = SAUpdateUserInfoViewModel.new; });
}

- (SAAppleIDSignInProvider *)appleIDSignInProvider {
    if (!_appleIDSignInProvider) {
        _appleIDSignInProvider = [SAAppleIDSignInProvider new];
        _appleIDSignInProvider.delegate = self;
    }
    return _appleIDSignInProvider;
}

- (SALoginViewModel *)loginVM {
    if (!_loginVM) {
        _loginVM = SALoginViewModel.new;
    }
    return _loginVM;
}
/** @lazy userDTO */
- (SAUserCenterDTO *)userDTO {
    if (!_userDTO) {
        _userDTO = [[SAUserCenterDTO alloc] init];
    }
    return _userDTO;
}
@end
