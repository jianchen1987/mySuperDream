//
//  SAMyInfoView.m
//  SuperApp
//
//  Created by Tia on 2023/6/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAMyInfoView.h"
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
#import "SAMyInfomationAvatarView.h"
#import "LKDataRecord.h"
#import "SASetPhoneBindViewController.h"
#import "SAMyInfomationSetContactNumberViewController.h"


@interface SAMyInfoView () <SADatePickerViewDelegate, SAAppleIDSignInProvider>
/// 头像
@property (nonatomic, strong) SAMyInfomationAvatarView *headImageView;
/// 昵称
@property (nonatomic, strong) SAInfoView *nickNameView;
/// wownowID
@property (nonatomic, strong) SAInfoView *wownowIdView;
/// 邮箱
@property (nonatomic, strong) SAInfoView *emailView;
/// 手机号码
@property (nonatomic, strong) SAInfoView *phoneNumberView;

@property (nonatomic, strong) SALabel *line1;
/// 社会化渠道标题
@property (nonatomic, strong) SALabel *socialViewTitleLB;
/// Facebook
@property (nonatomic, strong) SAInfoView *facebookView;
/// Wechat
@property (nonatomic, strong) SAInfoView *wechatView;
/// Apple Id
@property (nonatomic, strong) SAInfoView *appleIdView;


@property (nonatomic, strong) SALabel *line2;
/// 我的消息标题
@property (nonatomic, strong) SALabel *myInfoTitleLB;
/// 性别
@property (nonatomic, strong) SAInfoView *genderView;
/// 生日
@property (nonatomic, strong) SAInfoView *birthdayView;
/// 学历
@property (nonatomic, strong) SAInfoView *educationView;
///职业
@property (nonatomic, strong) SAInfoView *professionView;
/// 联系电话
@property (nonatomic, strong) SAInfoView *contactNumberView;

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

@property (nonatomic, strong) SAGetUserInfoRspModel *userInfoRspModel;


@end


@implementation SAMyInfoView

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.headImageView];
    [self.scrollViewContainer addSubview:self.nickNameView];
    [self.scrollViewContainer addSubview:self.wownowIdView];
    [self.scrollViewContainer addSubview:self.emailView];
    [self.scrollViewContainer addSubview:self.phoneNumberView];

    [self.scrollViewContainer addSubview:self.line1];
    [self.scrollViewContainer addSubview:self.socialViewTitleLB];
    [self.scrollViewContainer addSubview:self.facebookView];
    [self.scrollViewContainer addSubview:self.appleIdView];
    [self.scrollViewContainer addSubview:self.wechatView];


    [self.scrollViewContainer addSubview:self.line2];
    [self.scrollViewContainer addSubview:self.myInfoTitleLB];
    [self.scrollViewContainer addSubview:self.genderView];
    [self.scrollViewContainer addSubview:self.birthdayView];
    [self.scrollViewContainer addSubview:self.educationView];
    [self.scrollViewContainer addSubview:self.professionView];
    [self.scrollViewContainer addSubview:self.contactNumberView];

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
        self.userInfoRspModel = userInfoRspModel;
        if (!HDIsObjectNil(userInfoRspModel)) {
            if (HDIsStringNotEmpty(userInfoRspModel.headURL)) {
                [self.headImageView.avatarView sd_setImageWithURL:[NSURL URLWithString:userInfoRspModel.headURL] placeholderImage:[UIImage imageNamed:@"neutral"]];
            }
            if (HDIsStringNotEmpty(userInfoRspModel.nickName)) {
                self.nickNameView.model.valueText = userInfoRspModel.nickName;
                self.nickNameView.model.valueColor = UIColor.sa_C333;
                [self.nickNameView setNeedsUpdateContent];
            }
            if (HDIsStringNotEmpty(userInfoRspModel.email)) {
                if (userInfoRspModel.emailStatus == 11) {
                    self.emailView.model.valueText = userInfoRspModel.email;
                    self.emailView.model.valueColor = UIColor.sa_C333;
                    self.emailView.model.rightButtonImage = nil;
                }
                [self.emailView setNeedsUpdateContent];
            }

            if (HDIsStringNotEmpty(userInfoRspModel.mobile)) {
                self.phoneNumberView.model.valueText = userInfoRspModel.mobile;
                self.phoneNumberView.model.valueColor = UIColor.sa_C333;
                self.phoneNumberView.model.rightButtonImage = nil;
                [self.phoneNumberView setNeedsUpdateContent];
            }


            if (HDIsStringNotEmpty(userInfoRspModel.gender)) {
                self.genderView.model.valueText = [userInfoRspModel.gender isEqualToString:SAGenderMale] ? SALocalizedString(@"male", @"男性") : SALocalizedString(@"female", @"女性");
                self.genderView.model.valueColor = UIColor.sa_C333;
                [self.genderView setNeedsUpdateContent];
            }
            if (HDIsStringNotEmpty(userInfoRspModel.birthday)) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:userInfoRspModel.birthday.integerValue / 1000.0];
                NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy"];
                self.birthdayView.model.valueText = dateStr;
                self.birthdayView.model.valueColor = UIColor.sa_C333;
                [self.birthdayView setNeedsUpdateContent];
            }
            
            if (HDIsStringNotEmpty(userInfoRspModel.education)) {
                self.educationView.model.valueText = SALocalizedString(userInfoRspModel.education, @"学历");
                self.educationView.model.valueColor = UIColor.sa_C333;
                [self.educationView setNeedsUpdateContent];
            }
            
            if (HDIsStringNotEmpty(userInfoRspModel.profession)) {
                self.professionView.model.valueText = SALocalizedString(userInfoRspModel.profession, @"职业");
                self.professionView.model.valueColor = UIColor.sa_C333;
                [self.professionView setNeedsUpdateContent];
            }
            
            if (HDIsStringNotEmpty(userInfoRspModel.contactNumber)) {
                self.contactNumberView.model.valueText = userInfoRspModel.contactNumber;
                self.contactNumberView.model.valueColor = UIColor.sa_C333;
                [self.contactNumberView setNeedsUpdateContent];
            }

            if (!HDIsArrayEmpty(userInfoRspModel.thirdBindsList)) {
                NSArray<SAUserThirdBindModel *> *filteredAppleIdList = [userInfoRspModel.thirdBindsList hd_filterWithBlock:^BOOL(SAUserThirdBindModel *_Nonnull item) {
                    return [item.channel isEqualToString:SAThirdPartyBindChannelApple];
                }];
                if (!HDIsArrayEmpty(filteredAppleIdList)) {
                    SAUserThirdBindModel *bindModel = filteredAppleIdList.firstObject;
                    self.appleIdView.model.hd_associatedObject = @(1);
                    self.appleIdView.model.valueText = HDIsStringEmpty(bindModel.thirdUserName) ? SALocalizedString(@"binded", @"已绑定") : bindModel.thirdUserName;
                    self.appleIdView.model.valueColor = UIColor.sa_C333;
                    [self.appleIdView setNeedsUpdateContent];
                }
                NSArray<SAUserThirdBindModel *> *filteredFacebookList = [userInfoRspModel.thirdBindsList hd_filterWithBlock:^BOOL(SAUserThirdBindModel *_Nonnull item) {
                    return [item.channel isEqualToString:SAThirdPartyBindChannelFacebook];
                }];
                if (!HDIsArrayEmpty(filteredFacebookList)) {
                    SAUserThirdBindModel *bindModel = filteredFacebookList.firstObject;
                    self.facebookView.model.hd_associatedObject = @(1);
                    self.facebookView.model.valueText = HDIsStringEmpty(bindModel.thirdUserName) ? SALocalizedString(@"binded", @"已绑定") : bindModel.thirdUserName;
                    self.facebookView.model.valueColor = UIColor.sa_C333;
                    [self.facebookView setNeedsUpdateContent];
                }
                NSArray<SAUserThirdBindModel *> *filteredWechatList = [userInfoRspModel.thirdBindsList hd_filterWithBlock:^BOOL(SAUserThirdBindModel *_Nonnull item) {
                    return [item.channel isEqualToString:SAThirdPartyBindChannelWechat];
                }];
                if (!HDIsArrayEmpty(filteredWechatList)) {
                    SAUserThirdBindModel *bindModel = filteredWechatList.firstObject;
                    self.wechatView.model.hd_associatedObject = @(1);
                    self.wechatView.model.valueText = HDIsStringEmpty(bindModel.thirdUserName) ? SALocalizedString(@"binded", @"已绑定") : bindModel.thirdUserName;
                    self.wechatView.model.valueColor = UIColor.sa_C333;
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
            [self.headImageView.avatarView sd_setImageWithURL:[NSURL URLWithString:headURL]];
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
    [manager logOut];
    @HDWeakify(self);
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
    model.enableTapRecognizer = true;
    model.keyText = key;
    model.keyColor = UIColor.sa_C666;
    model.keyFont = HDAppTheme.font.sa_standard14;
    model.valueFont = HDAppTheme.font.sa_standard14;
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
        @HDStrongify(self);
        [sheetView dismiss];
        [self.imageAccessor fetchImageWithType:SAImageAccessorTypeTakingPhoto completion:block];
    }];
    HDActionSheetViewButton *chooseImageBTN = [HDActionSheetViewButton buttonWithTitle:SALocalizedStringFromTable(@"choose_image", @"选择照片", @"Buttons") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        @HDStrongify(self);
        [sheetView dismiss];
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
- (SAMyInfomationAvatarView *)headImageView {
    if (!_headImageView) {
        SAMyInfomationAvatarView *view = SAMyInfomationAvatarView.new;
        _headImageView = view;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerChooseHeadImage)];
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
}

- (SAInfoView *)nickNameView {
    if (!_nickNameView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"nickname", @"昵称")];
        model.valueText = HDIsStringNotEmpty(SAUser.shared.nickName) ? SAUser.shared.nickName : SALocalizedString(@"set_nickname", @"设置昵称");
        model.valueColor = HDIsStringNotEmpty(SAUser.shared.nickName) ? UIColor.sa_C333 : HDAppTheme.color.G4;
        model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToSetNickNameController:nil];
        };
        view.model = model;
        _nickNameView = view;
    }
    return _nickNameView;
}

- (SAInfoView *)wownowIdView {
    if (!_wownowIdView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"login_new2_Account/WOWNOW ID", @"账号/WOWNOW ID")];
        model.valueText = SAUser.shared.operatorNo;
        model.valueColor = UIColor.sa_C333;
        model.rightButtonImage = [UIImage imageNamed:@"icon_mine_info_copy"];
        model.enableTapRecognizer = YES;
        model.eventHandler = ^{
            if (HDIsStringNotEmpty(SAUser.shared.operatorNo)) {
                [UIPasteboard generalPasteboard].string = SAUser.shared.operatorNo;
                [HDTips showWithText:SALocalizedString(@"login_new2_copy successfully", @"复制成功")];

                [LKDataRecord.shared traceClickEvent:@"MyInformationPageCopyWownowIdClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SAMyInfomationViewController" area:@"" node:@""]];
            }
        };
        view.model = model;
        _wownowIdView = view;
    }
    return _wownowIdView;
}

- (SAInfoView *)emailView {
    if (!_emailView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"login_new2_Email", @"邮箱")];
        model.valueText = SALocalizedString(@"login_new2_Setting", @"设置");
        model.valueColor = UIColor.sa_C999;
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            if (self.userInfoRspModel.emailStatus == 11)
                return;
            [HDMediator.sharedInstance navigaveToBindEmailController:@{@"email": self.userInfoRspModel.email}];
        };
        view.model = model;
        _emailView = view;
    }
    return _emailView;
}

- (SAInfoView *)phoneNumberView {
    if (!_phoneNumberView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"login_new2_Mobile Number", @"手机号码")];
        model.valueText = SALocalizedString(@"login_new2_Setting", @"设置");
        model.valueColor = UIColor.sa_C999;
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            if (HDIsStringEmpty(self.userInfoRspModel.mobile)) {
                SASetPhoneBindViewController *vc = SASetPhoneBindViewController.new;
                vc.bindSuccessBlock = ^{

                };
                [self.viewController.navigationController pushViewController:vc animated:YES];
            }
        };
        view.model = model;
        _phoneNumberView = view;
    }
    return _phoneNumberView;
}

- (SALabel *)line1 {
    if (!_line1) {
        SALabel *label = SALabel.new;
        label.hd_edgeInsets = UIEdgeInsetsMake(6, 0, 6, 0);
        label.backgroundColor = UIColor.sa_backgroundColor;
        _line1 = label;
    }
    return _line1;
}


- (SALabel *)socialViewTitleLB {
    if (!_socialViewTitleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.sa_standard16M;
        label.textColor = UIColor.sa_C333;
        label.numberOfLines = 0;
        label.text = SALocalizedString(@"login_new2_Linked account", @"关联账户");
        label.hd_edgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
        label.backgroundColor = UIColor.whiteColor;
        _socialViewTitleLB = label;
    }
    return _socialViewTitleLB;
}

- (SAInfoView *)facebookView {
    if (!_facebookView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:SALocalizedString(@"facebook", @"Facebook")];
        model.leftImage = [UIImage imageNamed:@"icon_mine_info_fb"];
        model.valueText = SALocalizedString(@"login_new2_Binding", @"绑定");
        model.valueColor = UIColor.sa_C1;
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

- (SAInfoView *)appleIdView {
    if (!_appleIdView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:SALocalizedString(@"apple_id", @"Apple ID")];
        model.leftImage = [UIImage imageNamed:@"icon_mine_info_Apple Logo"];
        model.valueText = SALocalizedString(@"login_new2_Binding", @"绑定");
        model.valueColor = UIColor.sa_C1;
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

- (SAInfoView *)wechatView {
    if (!_wechatView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:SALocalizedString(@"wechat", @"微信")];
        model.leftImage = [UIImage imageNamed:@"icon_mine_info_wechat"];
        model.valueText = SALocalizedString(@"login_new2_Binding", @"绑定");
        model.valueColor = UIColor.sa_C1;
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

- (SALabel *)line2 {
    if (!_line2) {
        SALabel *label = SALabel.new;
        label.hd_edgeInsets = UIEdgeInsetsMake(6, 0, 6, 0);
        label.backgroundColor = UIColor.sa_backgroundColor;
        _line2 = label;
    }
    return _line2;
}

- (SALabel *)myInfoTitleLB {
    if (!_myInfoTitleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.sa_standard16M;
        label.textColor = UIColor.sa_C333;
        label.numberOfLines = 0;
        label.text = SALocalizedString(@"login_new2_My information", @"我的信息");
        label.hd_edgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
        label.backgroundColor = UIColor.whiteColor;
        _myInfoTitleLB = label;
    }
    return _myInfoTitleLB;
}

- (SAInfoView *)genderView {
    if (!_genderView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"gender", @"性别")];
        if (HDIsStringNotEmpty(SAUser.shared.gender)) {
            model.valueText = [SAUser.shared.gender isEqualToString:SAGenderMale] ? SALocalizedString(@"male", @"男性") : SALocalizedString(@"female", @"女性");
            model.valueColor = UIColor.sa_C333;
        } else {
            model.valueText = SALocalizedString(@"login_new2_Setting", @"设置");
            model.valueColor = UIColor.sa_searchBarTextColor;
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
            model.valueColor = UIColor.sa_C333;
        } else {
            model.valueText = SALocalizedString(@"login_new2_Setting", @"设置");
            model.valueColor = UIColor.sa_searchBarTextColor;
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

- (SAInfoView *)educationView {
    if (!_educationView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"education", @"学历")];
        model.keyColor = UIColor.sa_C666;
        model.keyFont = HDAppTheme.font.sa_standard14;

        if (HDIsStringNotEmpty(SAUser.shared.education)) {
            model.valueText = SALocalizedString(SAUser.shared.education, @"未知");
            model.valueColor = UIColor.sa_C333;
        } else {
            model.valueText = SALocalizedString(@"login_new2_Setting", @"设置");
            model.valueColor = UIColor.sa_searchBarTextColor;
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

- (SAInfoView *)professionView {
    if (!_professionView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"career", @"职业")];
        if (HDIsStringNotEmpty(SAUser.shared.profession)) {
            model.valueText = SALocalizedString(SAUser.shared.profession, @"未知");
            model.valueColor = UIColor.sa_C333;
        } else {
            model.valueText = SALocalizedString(@"login_new2_Setting", @"设置");
            model.valueColor = UIColor.sa_searchBarTextColor;
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

- (SAInfoView *)contactNumberView {
    if (!_contactNumberView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"contact_phone_number", @"联系电话")];
        if (HDIsStringNotEmpty(SAUser.shared.contactNumber)) {
            model.valueText = SALocalizedString(SAUser.shared.profession, @"未知");
            model.valueColor = UIColor.sa_C333;
        } else {
            model.valueText = SALocalizedString(@"login_new2_Setting", @"设置");
            model.valueColor = UIColor.sa_searchBarTextColor;
        }

        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            SAMyInfomationSetContactNumberViewController *vc = SAMyInfomationSetContactNumberViewController.new;
            if (HDIsStringNotEmpty(SAUser.shared.contactNumber)) {
                vc.contactNumber = SAUser.shared.contactNumber;
            }
            [self.viewController.navigationController pushViewController:vc animated:YES];
        };
        view.model = model;
        _contactNumberView = view;
    }
    return _contactNumberView;
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
