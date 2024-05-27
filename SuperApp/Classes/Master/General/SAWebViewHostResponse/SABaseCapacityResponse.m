//
//  SABaseCapacityResponse.m
//  SuperApp
//
//  Created by seeu on 2020/7/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SABaseCapacityResponse.h"
#import "SAApolloManager.h"
#import "SAAppAuthorizeDTO.h"
#import "SACacheManager.h"
#import "SAImageAccessor.h"
#import "SAMessageManager.h"
#import "SARecorderTools.h"
#import "SARecorderView.h"
#import "SAShoppingAddressModel.h"
#import "SASocialShareView.h"
#import "SAUploadFileDTO.h"
#import "SAUploadImageDTO.h"
#import "SAUser.h"
#import "SAUserCenterDTO.h"
#import "SAUserSilentPermissionRspModel.h"
#import "SAWindowManager.h"
#import "LKDataRecord.h"


@interface SABaseCapacityResponse ()
/// 图片选择器
@property (nonatomic, strong) SAImageAccessor *imageAccessor;
/// 图片上传 DTO
@property (nonatomic, strong) SAUploadImageDTO *uploadImageDTO;
@property (nonatomic, strong) SAUserCenterDTO *userDTO; ///<
/// 选择图片回调key
@property (nonatomic, copy) NSString *chooseIamgeCallBackKey;
@property (nonatomic, copy) NSString *loginPermissionCallbackKey; ///< 授权回调Key

///文件上传DTO
@property (nonatomic, copy) SAUploadFileDTO *uploadFileDTO;
/// 录音回调key
@property (nonatomic, copy) NSString *voiceRecordCallBackKey;

@property (nonatomic, copy) SAAppAuthorizeDTO *authorizeDTO;

@end


@implementation SABaseCapacityResponse
+ (NSDictionary<NSString *, NSString *> *)supportActionList {
    return @{
        @"getUserInfo$": kHDWHResponseMethodOn,
        @"chooseImage_$": kHDWHResponseMethodOn,
        @"loginWithPermissions_$": kHDWHResponseMethodOn,
        @"networkRequest_$": kHDWHResponseMethodOn,
        @"socialShare_$": kHDWHResponseMethodOn,
        @"getUserUnreadMsgCount$": kHDWHResponseMethodOn,
        @"getShippingAddress$": kHDWHResponseMethodOn,
        @"voiceRecord_$": kHDWHResponseMethodOn,
        @"goToAppSystemSetting_$": kHDWHResponseMethodOn,
        @"ocr_$": kHDWHResponseMethodOn,
    };
}

/// 网络请求指令
/// @param paramsDict {path: 接口地址, params:请求参数}
/// @param callBackKey 回调key
- (void)networkRequest:(NSDictionary *)paramsDict callback:(NSString *)callBackKey {
    // 白名单校验
    NSString *curHost = self.webViewHost.webView.URL.host;
    HDLog(@"当前host:%@", curHost);
    NSArray<NSString *> *whiteList = [SAApolloManager getApolloConfigForKey:ApolloConfigKeyH5WhiteList];
    if (![whiteList containsObject:curHost]) {
        [self.webViewHost fireCallback:callBackKey actionName:@"networkRequest" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{}];
        return;
    }
    // 登陆校验
    if (![SAUser hasSignedIn]) {
        [self.webViewHost fireCallback:callBackKey actionName:@"networkRequest" code:HDWHRespCodeUserNotSignedIn type:HDWHCallbackTypeFail params:@{}];
        return;
    }

    NSString *path = [paramsDict valueForKey:@"path"];
    NSDictionary *params = [paramsDict objectForKey:@"params"];
    BOOL showError = [[paramsDict objectForKey:@"showError"] boolValue];

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = path;
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = showError;

    request.requestParameter = params;
    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        [self.webViewHost fireCallback:callBackKey actionName:@"networkRequest" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:response.responseObject];
    } failure:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        [self.webViewHost fireCallback:callBackKey actionName:@"networkRequest" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:response.responseObject];
    }];
}

/// 获取用户信息
/// @param callBackKey 回调Key
- (void)getUserInfoWithCallback:(NSString *)callBackKey {
    if ([SAUser hasSignedIn]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:6];
        params[@"loginName"] = [SAUser.shared loginName];
        params[@"operatorNo"] = [SAUser.shared operatorNo];
        params[@"language"] = SAMultiLanguageManager.currentLanguage;

        [self.webViewHost fireCallback:callBackKey actionName:@"getUserInfo" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:params];
    } else {
        [self.webViewHost fireCallback:callBackKey actionName:@"getUserInfo" code:HDWHRespCodeUserNotSignedIn type:HDWHCallbackTypeFail params:@{}];
    }
}

- (void)getUserUnreadMsgCountWithCallback:(NSString *)callBackKey {
    if (![SAUser hasSignedIn]) {
        [self.webViewHost fireCallback:callBackKey actionName:@"getUserUnreadMsgCount" code:HDWHRespCodeUserNotSignedIn type:HDWHCallbackTypeFail params:@{}];
        return;
    }

    @HDWeakify(self);
    [SAMessageManager.share getUnreadMessageCount:^(NSUInteger count, NSDictionary<SAAppInnerMessageType, NSNumber *> *_Nonnull details) {
        @HDStrongify(self);
        [self.webViewHost fireCallback:callBackKey actionName:@"getUserUnreadMsgCount" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{@"unReadCount": @(count)}];
    }];
}

/// 获取收货地址
/// @param callBackKey 回调key
- (void)getShippingAddressWithCallback:(NSString *)callBackKey {
    if ([SAUser hasSignedIn]) {
        @HDWeakify(self);
        void (^cancelBlock)(void) = ^{
            @HDStrongify(self);
            [self.webViewHost fireCallback:callBackKey actionName:@"getShippingAddress" code:HDWHRespCodeUserCancel type:HDWHCallbackTypeCancel params:@{}];
        };
        void (^callback)(SAShoppingAddressModel *) = ^(SAShoppingAddressModel *addressModel) {
            @HDStrongify(self);
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"addressData"] = [addressModel yy_modelToJSONString];
            [self.webViewHost fireCallback:callBackKey actionName:@"getShippingAddress" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:params];
        };
        [HDMediator.sharedInstance navigaveToChooseMyAddressViewController:@{@"callback": callback, @"cancelCallback": cancelBlock}];
    } else {
        [self.webViewHost fireCallback:callBackKey actionName:@"getShippingAddress" code:HDWHRespCodeUserNotSignedIn type:HDWHCallbackTypeFail params:@{}];
    }
}

/// 选择图片
/// @param paramDict {count:张数,sourceType:类型（album:相册,camera:相机}
/// @param callBackKey 回调key
- (void)chooseImage:(NSDictionary *)paramDict callback:(NSString *)callBackKey {
    if (![SAUser hasSignedIn]) {
        [self.webViewHost fireCallback:callBackKey actionName:@"chooseImage" code:HDWHRespCodeUserNotSignedIn type:HDWHCallbackTypeFail params:@{}];
        return;
    }

    // NSArray<NSString *> *sizeType = [paramDict objectForKey:@"sizeType"];
    NSNumber *imageCount = [paramDict objectForKey:@"count"];
    NSArray<NSString *> *sourceTypeArray = [paramDict objectForKey:@"sourceType"];
    if (!sourceTypeArray.count) {
        [self.webViewHost fireCallback:callBackKey actionName:@"chooseImage" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:@{}];
        return;
    }
    self.chooseIamgeCallBackKey = callBackKey;
    _imageAccessor = nil;

    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];
    sheetView.allowTapBackgroundDismiss = NO;
    @HDWeakify(self);
    sheetView.cancelButtonHandler = ^(HDActionSheetView *actionSheetView, HDActionSheetViewButton *cancel) {
        [actionSheetView dismiss];
        @HDStrongify(self);
        [self.webViewHost fireCallback:callBackKey actionName:@"chooseImage" code:HDWHRespCodeUserCancel type:HDWHCallbackTypeFail params:@{}];
    };
    SAImageAccessorMultiImageCompletionBlock block = ^(NSArray<UIImage *> *images, NSError *_Nullable error) {
        @HDStrongify(self);
        if (!HDIsArrayEmpty(images)) {
            [self uploadImages:images];
        } else {
            [self.webViewHost fireCallback:callBackKey actionName:@"chooseImage" code:HDWHRespCodeUserCancel type:HDWHCallbackTypeFail params:@{}];
        }
    };
    NSMutableArray<HDActionSheetViewButton *> *sourceTypeButtons = [[NSMutableArray alloc] init];
    // clang-format off
    for (NSString *source in sourceTypeArray) {
        if ([source isEqualToString:@"album"]) {
            HDActionSheetViewButton *chooseImageBTN = [HDActionSheetViewButton buttonWithTitle:SALocalizedStringFromTable(@"choose_image", @"选择照片", @"Buttons")
                                                                                          type:HDActionSheetViewButtonTypeCustom
                                                                                       handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                [sheetView dismiss];
                [self.imageAccessor fetchImageWithType:SAImageAccessorTypeBrowserPhotos maxImageCount:imageCount.integerValue completion:block];
            }];
            [sourceTypeButtons addObject:chooseImageBTN];
        } else if ([source isEqualToString:@"camera"]) {
            HDActionSheetViewButton *takePhotoBTN = [HDActionSheetViewButton buttonWithTitle:SALocalizedStringFromTable(@"take_photo", @"拍照", @"Buttons")
                                                                                        type:HDActionSheetViewButtonTypeCustom
                                                                                     handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                [sheetView dismiss];
                [self.imageAccessor fetchImageWithType:SAImageAccessorTypeTakingPhoto completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
                    !block ?: block(image? @[image] : nil, error);
                }];
            }];
            [sourceTypeButtons addObject:takePhotoBTN];
        }
    }
    // clang-format on

    [sheetView addButtons:sourceTypeButtons];
    [sheetView show];
}

/// 授权登录
/// @param paramDict 请求参数
/// permissions  NSArrary<NSString *>  : base_info,
///  appId  NSString
/// @param callBackKey 授权回调
- (void)loginWithPermissions:(NSDictionary *)paramDict callback:(NSString *)callBackKey {
    if (![SAUser hasSignedIn]) {
        [self.webViewHost fireCallback:callBackKey actionName:@"loginWithPermissons" code:HDWHRespCodeUserNotSignedIn type:HDWHCallbackTypeFail params:@{}];
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }

    self.loginPermissionCallbackKey = callBackKey;
    [self.webViewHost showloading];
    @HDWeakify(self);
    [self.userDTO userPermissionSilentlyWithParams:paramDict success:^(SAUserSilentPermissionRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.webViewHost dismissLoading];
        [self.webViewHost fireCallback:self.loginPermissionCallbackKey actionName:@"loginWithPermissons" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess
                                params:@{@"accessToken": rspModel.accessToken, @"openId": rspModel.openId}];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.webViewHost dismissLoading];
        [self.webViewHost fireCallback:self.loginPermissionCallbackKey actionName:@"loginWithPermissons" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail
                                params:[rspModel yy_modelToJSONObject]];
    }];
}

- (void)socialShare:(NSDictionary *)paramDic callback:(NSString *)callBackKey {
    NSString *title = [paramDic valueForKey:@"title"];
    NSString *titleImage = [paramDic valueForKey:@"image"];
    NSString *content = [paramDic valueForKey:@"content"];

    if (HDIsStringEmpty(title) && HDIsStringEmpty(titleImage) && HDIsStringEmpty(content)) {
        [self.webViewHost fireCallback:callBackKey actionName:@"socialShare" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:@{}];
        return;
    }

    NSString *facebookUrl = [paramDic valueForKey:@"facebookWebpageUrl"];
    NSString *desc = [paramDic valueForKey:@"desc"];

    NSArray *shareChannels = [paramDic valueForKey:@"channels"];
    NSArray *functions = [paramDic valueForKey:@"functions"];
    BOOL hiddenFunctions = [[paramDic valueForKey:@"hiddenFunctions"] boolValue];

    // 埋点追踪用
    NSString *traceId = [paramDic valueForKey:@"traceId"];
    NSString *traceContent = [paramDic valueForKey:@"traceContent"];

    SAShareWebpageObject *shareObject = SAShareWebpageObject.new;
    shareObject.title = title;
    shareObject.thumbImage = titleImage;
    shareObject.webpageUrl = content;
    shareObject.facebookWebpageUrl = facebookUrl;
    shareObject.descr = desc;
    [SASocialShareView showShareWithShareObject:shareObject inChannels:shareChannels functions:functions hiddenFunctions:hiddenFunctions completion:^(BOOL completion,
                                                                                                                                                      NSString *_Nullable shareChannel) {
        HDLog(@"分享结果:%@", @(completion));
        if (completion) {
            [self.webViewHost fireCallback:callBackKey actionName:@"socialShare" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess
                                    params:@{@"channel": HDIsStringNotEmpty(shareChannel) ? shareChannel : @""}];
        } else {
            [self.webViewHost fireCallback:callBackKey actionName:@"socialShare" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail
                                    params:@{@"channel": HDIsStringNotEmpty(shareChannel) ? shareChannel : @""}];
        }

        [LKDataRecord.shared traceEvent:@"click_pv_socialShare" name:@""
                             parameters:@{@"shareResult": completion ? @"success" : @"fail", @"traceId": traceId, @"traceUrl": content, @"traceContent": traceContent, @"channel": shareChannel}];
    }];
}

//录音
- (void)voiceRecord:(NSDictionary *)paramDic callback:(NSString *)callBackKey {
    if (![SAUser hasSignedIn]) { //未登录
        [self.webViewHost fireCallback:callBackKey actionName:@"voiceRecord" code:HDWHRespCodeUserNotSignedIn type:HDWHCallbackTypeFail params:@{}];
        return;
    }

    if (![[SARecorderTools shareManager] canRecord]) { //拒绝麦克风授权
        [self.webViewHost fireCallback:callBackKey actionName:@"voiceRecord" code:HDWHRespCodeUserRejected type:HDWHCallbackTypeFail params:@{@"reason": @"用户已拒绝麦克风授权"}];
        return;
    }

    NSString *title = [paramDic valueForKey:@"title"];
    NSString *subTitle = [paramDic valueForKey:@"subTitle"];
    NSInteger second = [[paramDic valueForKey:@"sec"] integerValue];
    if (second < 0 || second > 60) {
        second = 60;
    }
    self.voiceRecordCallBackKey = callBackKey;
    @HDWeakify(self);
    SARecorderView *view = [[SARecorderView alloc] initWithTitle:title subTitle:subTitle limitMaxRecordSecond:second completion:^(BOOL finish, NSString *_Nullable filePath, NSInteger second) {
        @HDStrongify(self);
        if (finish) { //录音完成
            [self uploadFile:filePath second:second];
        } else { //点击取消按钮
            [self.webViewHost fireCallback:callBackKey actionName:@"voiceRecord" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{}];
        }
    }];
    //点击黑色遮罩
    view.didTappedBackgroundHandler = ^(HDActionAlertView *_Nonnull alertView) {
        [self.webViewHost fireCallback:callBackKey actionName:@"voiceRecord" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{}];
    };

    [view show];
}


//跳转到app的隐私设置页面
- (void)goToAppSystemSetting:(NSDictionary *)paramDic callback:(NSString *)callBackKey {
    NSInteger authorizeType = [[paramDic valueForKey:@"authorizeType"] integerValue];
    if (authorizeType == 1) { //通知权限
        if (SAGeneralUtil.isNotificationEnable) {
            HDLog(@"已开启通知");
            @HDWeakify(self);
            [self.authorizeDTO submitWithAuthorize:authorizeType success:^{
                @HDStrongify(self);
                [self.webViewHost fireCallback:callBackKey actionName:@"goToAppSystemSetting" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                [self.webViewHost fireCallback:callBackKey actionName:@"goToAppSystemSetting" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{}];
            }];

        } else {
            HDLog(@"未开启通知");
            [self.webViewHost fireCallback:callBackKey actionName:@"goToAppSystemSetting" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{}];
            [HDSystemCapabilityUtil openAppSystemSettingPage];
        }
    } else {
        [self.webViewHost fireCallback:callBackKey actionName:@"goToAppSystemSetting" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{}];
    }
}

// ocr识别
- (void)ocr:(NSDictionary *)paramDic callback:(NSString *)callBackKey {
    if (![SAUser hasSignedIn]) { //未登录
        [self.webViewHost fireCallback:callBackKey actionName:@"ocr" code:HDWHRespCodeUserNotSignedIn type:HDWHCallbackTypeFail params:@{}];
        return;
    }
    // 类型，1-身份证，2-护照
    NSInteger type = [[paramDic valueForKey:@"type"] integerValue];
    @HDWeakify(self);
    void (^cancelBlock)(void) = ^{
        @HDStrongify(self);
        [self.webViewHost fireCallback:callBackKey actionName:@"ocr" code:HDWHRespCodeUserCancel type:HDWHCallbackTypeCancel params:@{}];
    };
    void (^callback)(NSDictionary *dic) = ^(NSDictionary *dic) {
        @HDStrongify(self);
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
        if (params[@"data"]) { //有data，说明调用ocr接口成功，有返回
            [self.webViewHost fireCallback:callBackKey actionName:@"ocr" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:params];
        } else {
            [self.webViewHost fireCallback:callBackKey actionName:@"ocr" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:params];
        }
    };
    [HDMediator.sharedInstance navigaveToOcrScanViewController:@{@"callback": callback, @"cancelCallback": cancelBlock, @"type": @(type)}];
}


#pragma mark - private methods
/// 上传图片
/// @param imageList 图标列表
- (void)uploadImages:(NSArray<UIImage *> *)imageList {
    HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self.webView];
    @HDWeakify(self);
    [self.uploadImageDTO batchUploadImages:imageList progress:^(NSProgress *_Nonnull progress) {
        hd_dispatch_main_async_safe(^{
            [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
        });
    } success:^(NSArray *_Nonnull imageURLArray) {
        @HDStrongify(self);
        hd_dispatch_main_async_safe(^{
            [hud showSuccessNotCreateNew:SALocalizedString(@"upload_completed", @"上传完毕")];
            if (imageURLArray.count > 0) {
                [self.webViewHost fireCallback:self.chooseIamgeCallBackKey actionName:@"chooseImage" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{@"images": imageURLArray}];
            } else {
                [self.webViewHost fireCallback:self.chooseIamgeCallBackKey actionName:@"chooseImage" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{}];
            }
        });
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        [hud hideAnimated:true];
    }];
}

/// 上传音频
/// @param filePath 音频文件路径
/// @param second 音频时长
- (void)uploadFile:(NSString *)filePath second:(NSInteger)second {
    HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self.webView];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data) {
        [self.webViewHost fireCallback:self.voiceRecordCallBackKey actionName:@"voiceRecord" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{}];
        return;
    }

    @HDWeakify(self);
    [self.uploadFileDTO batchUploadFileData:data fileName:@"files" fileType:@"wav" mimeType:@"audio/x-wave" progress:^(NSProgress *_Nonnull progress) {
        hd_dispatch_main_async_safe(^{
            [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
        });
    } success:^(NSString *_Nonnull fileURLString) {
        @HDStrongify(self);
        hd_dispatch_main_async_safe(^{
            [hud showSuccess:SALocalizedString(@"upload_completed", @"上传完毕")];
            if (fileURLString.length) {
                [self.webViewHost fireCallback:self.voiceRecordCallBackKey actionName:@"voiceRecord" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess
                                        params:
                                            @{@"recordUrl": fileURLString,
                                              @"recordSec": @(second)}];
            } else {
                [self.webViewHost fireCallback:self.voiceRecordCallBackKey actionName:@"voiceRecord" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{}];
            }
        });
        [[SARecorderTools shareManager] removeCurrentRecordFile:filePath];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        hd_dispatch_main_async_safe(^{
            [hud hideAnimated:true];
            [self.webViewHost fireCallback:self.voiceRecordCallBackKey actionName:@"voiceRecord" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{}];
        });
        [[SARecorderTools shareManager] removeCurrentRecordFile:filePath];
    }];
}

#pragma mark - lazy load
/** @lazy imageAssesor */
- (SAImageAccessor *)imageAccessor {
    if (!_imageAccessor) {
        _imageAccessor = [[SAImageAccessor alloc] initWithSourceViewController:self.webViewHost needCrop:NO];
    }
    return _imageAccessor;
}

- (SAUploadImageDTO *)uploadImageDTO {
    return _uploadImageDTO ?: ({ _uploadImageDTO = SAUploadImageDTO.new; });
}
/** @lazy userDTO */
- (SAUserCenterDTO *)userDTO {
    if (!_userDTO) {
        _userDTO = [[SAUserCenterDTO alloc] init];
    }
    return _userDTO;
}

- (SAUploadFileDTO *)uploadFileDTO {
    return _uploadFileDTO ?: ({ _uploadFileDTO = SAUploadFileDTO.new; });
}

- (SAAppAuthorizeDTO *)authorizeDTO {
    return _authorizeDTO ?: ({ _authorizeDTO = SAAppAuthorizeDTO.new; });
}

@end
