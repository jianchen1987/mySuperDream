//
//  WXApiManager.m
//  SuperApp
//
//  Created by VanJay on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WXApiManager.h"
#import "SANotificationConst.h"
#import "SAShareImageObject.h"
#import "SAShareWebpageObject.h"
#import "SAWechatPayRequestModel.h"
#import <HDKitCore/HDCommonDefines.h>


@implementation WXApiManager
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedManager];
}

#pragma mark - WXApiDelegate
/*! @brief 发送一个 sendReq 后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有 SendMessageToWXResp、SendAuthResp 等。
 * @param resp 具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg;

        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                HDLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;

            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode, resp.errStr];
                HDLog(@"错误，retcode = %d, retstr = %@", resp.errCode, resp.errStr);
                break;
        }
        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationWechatPayOnResponse object:resp];

    } else if ([resp isKindOfClass:SendAuthResp.class]) {
        SendAuthResp *trueResp = (SendAuthResp *)resp;
        switch (trueResp.errCode) {
            case WXSuccess:
                HDLog(@"微信授权成功,授权码:%@", trueResp.code);
                break;
            case WXErrCodeAuthDeny:
                HDLog(@"微信授权失败,原因:%@", trueResp.errStr);
                break;
            case WXErrCodeUserCancel:
                HDLog(@"用户取消");
                break;
            default:
                HDLog(@"微信授权异常,code:%d msg:%@", trueResp.errCode, trueResp.errStr);
                break;
        }

        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationWechatAuthLoginResponse object:trueResp];
    } else {
    }
}

- (void)onReq:(BaseReq *)req {
    //获取开放标签传递的extinfo数据逻辑
    if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
        if (_delegate && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    } else {
        [WXApi sendReq:req completion:^(BOOL success) {
            HDLog(@"向微信发送支付请求成功");
        }];
    }
}

#pragma mark - public methods
- (void)sendPayReq:(SAWechatPayRequestModel *)requestModel {
    PayReq *payReq = [[PayReq alloc] init];
    payReq.partnerId = requestModel.partnerid;
    payReq.prepayId = requestModel.prepayid;
    payReq.nonceStr = requestModel.noncestr;
    payReq.timeStamp = requestModel.timestamp;
    payReq.package = requestModel.package;
    payReq.sign = requestModel.sign;
    [self onReq:payReq];
}

- (void)sendLoginReqWithViewController:(UIViewController *)vc {
    SendAuthReq *authReq = [[SendAuthReq alloc] init];
    authReq.scope = @"snsapi_userinfo";
    authReq.state = @"WOWNOW";

    [WXApi sendAuthReq:authReq viewController:vc delegate:self completion:^(BOOL success) {
        HDLog(@"向微信发送授权登录请求成功");
    }];
}

- (void)sendShareReq:(SAShareObject *)shareObject inScene:(int)scene completion:(void (^_Nullable)(BOOL))completion {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.scene = scene;

    if ([shareObject isKindOfClass:SAShareWebpageObject.class]) {
        SAShareWebpageObject *trueShareObject = (SAShareWebpageObject *)shareObject;
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = trueShareObject.webpageUrl;
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = trueShareObject.title;
        message.description = HDIsStringNotEmpty(trueShareObject.descr) ? trueShareObject.descr : trueShareObject.webpageUrl;
        message.thumbData = trueShareObject.thumbData;
        message.mediaObject = webpageObject;
        req.message = message;
    } else if ([shareObject isKindOfClass:SAShareImageObject.class]) {
        SAShareImageObject *trueShareObject = (SAShareImageObject *)shareObject;
        WXImageObject *imageObject = [WXImageObject object];
        imageObject.imageData = trueShareObject.shareImageData;
        WXMediaMessage *message = [WXMediaMessage message];
        message.thumbData = trueShareObject.thumbData;
        message.mediaObject = imageObject;
        req.message = message;
    } else {
        HDLog(@"分享模型类型暂不支持");
        !completion ?: completion(false);
        return;
    }

    [WXApi sendReq:req completion:completion];
}

@end
