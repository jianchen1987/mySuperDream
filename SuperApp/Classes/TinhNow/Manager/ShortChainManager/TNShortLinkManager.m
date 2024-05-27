//
//  ShortChainManager.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNShortLinkManager.h"
#import "TNShareModel.h"


@implementation TNShortLinkModel
@end


@implementation TNShortLinkManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TNShortLinkManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}
+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}
- (void)getShortLinkByOriginalLink:(NSString *)originalLink completion:(void (^)(TNShortLinkModel *_Nonnull))completion {
    TNShareModel *shareModel = [[TNShareModel alloc] init];
    shareModel.shareLink = originalLink;
    [self getShortLinkByShareModel:shareModel completion:completion];
}
- (void)getShortLinkByShareModel:(TNShareModel *)shareModel completion:(void (^)(TNShortLinkModel *_Nonnull))completion {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/shareGenerator/getShortUrl";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    NSAssert(HDIsStringNotEmpty(shareModel.shareLink), @"分享链接不能为空");
    NSString *originalLink = shareModel.shareLink;
    params[@"longUrl"] = originalLink;
    if (shareModel.type != TNShareTypeDefault) {
        params[@"type"] = @(shareModel.type);
    }
    if (HDIsStringNotEmpty(shareModel.sourceId)) {
        params[@"sourceId"] = shareModel.sourceId;
    }
    if (HDIsStringNotEmpty(shareModel.shareImage)) {
        params[@"shareImage"] = shareModel.shareImage;
    }
    if (HDIsStringNotEmpty(shareModel.shareTitle)) {
        params[@"title"] = shareModel.shareTitle;
    }
    if (HDIsStringNotEmpty(shareModel.shareContent)) {
        params[@"content"] = shareModel.shareContent;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        TNShortLinkModel *model = [TNShortLinkModel yy_modelWithJSON:rspModel.data];
        //以下兜底确保有值
        if (HDIsObjectNil(model)) {
            model = [[TNShortLinkModel alloc] init];
            model.shortUrl = originalLink;
            model.spareUrl = originalLink;
        }
        if (HDIsStringEmpty(model.shortUrl)) {
            model.shortUrl = originalLink;
        }
        if (HDIsStringEmpty(model.spareUrl)) {
            if (HDIsStringNotEmpty(model.shortUrl)) {
                model.spareUrl = model.shortUrl;
            } else {
                model.spareUrl = originalLink;
            }
        }
        !completion ?: completion(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        TNShortLinkModel *model = [[TNShortLinkModel alloc] init];
        model.shortUrl = originalLink;
        model.spareUrl = originalLink;
        !completion ?: completion(model); //失败的话  将原地址返回分享
    }];
}

@end
