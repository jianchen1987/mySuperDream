//
//  TNShareManager.m
//  SuperApp
//
//  Created by 张杰 on 2021/2/26.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNShareManager.h"
#import "SASocialShareView.h"
#import "SATalkingData.h"
#import "TNShortLinkManager.h"
#import "TNSocialShareProductDetailImageView.h"
#import "LKDataRecord.h"


@implementation TNShareManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TNShareManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}
+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}
- (void)showShareWithShareModel:(TNShareModel *)shareModel {
    [[UIApplication sharedApplication].keyWindow showloading];
    [[TNShortLinkManager sharedInstance] getShortLinkByShareModel:shareModel completion:^(TNShortLinkModel *_Nonnull linkModel) {
        [[UIApplication sharedApplication].keyWindow dismissLoading];
        TNShareWebpageObject *object = [[TNShareWebpageObject alloc] init];
        object.title = HDIsStringNotEmpty(linkModel.shareTitle) ? linkModel.shareTitle : shareModel.shareTitle;
        object.webpageUrl = linkModel.shortUrl;
        NSString *shareImage = HDIsStringNotEmpty(linkModel.shareImage) ? linkModel.shareImage : shareModel.shareImage;
        object.facebookWebpageUrl = linkModel.spareUrl;
        object.thumbImage = HDIsStringNotEmpty(shareImage) ? shareImage : [UIImage imageNamed:@"tn_share_photo_dafalut"];
        object.descr = HDIsStringNotEmpty(linkModel.shareContent) ? linkModel.shareContent : shareModel.shareContent;

        void (^shareCompletion)(BOOL, NSString *_Nullable) = ^(BOOL success, NSString *_Nullable shareChannel) {
            [LKDataRecord.shared traceEvent:@"click_pv_socialShare" name:@"" parameters:@{
                @"shareResult": success ? @"success" : @"fail",
                @"traceId": shareModel.sourceId,
                @"traceUrl": linkModel.shortUrl,
                @"traceContent": HDIsObjectNil(shareModel.productDetailModel) ? @"other_share" : @"product_pic_share",
                @"channel": shareChannel
            }];
        };

        if (!HDIsObjectNil(shareModel.productDetailModel)) {
            object.businessType = TNShareBusinessTypeProductDetail;
            object.associationModel = shareModel.productDetailModel;
            //自定义图片分享
            HDSocialShareCellModel *generateImageFunctionModel = [SASocialShareView generateImageFunctionModel];
            generateImageFunctionModel.clickedHandler = ^(HDSocialShareCellModel *_Nonnull cellModel, NSInteger index) {
                [SATalkingData trackEvent:[shareModel.trackPrefixName stringByAppendingString:@"商品详情页_分享-生成分享海报"]];
                TNSocialShareProductDetailImageView *imageShareView = [[TNSocialShareProductDetailImageView alloc] initWithShareObject:object];
                [SASocialShareView showShareWithTopCustomView:imageShareView completion:nil];
            };

            [SASocialShareView showShareWithShareObject:object functionModels:@[SASocialShareView.copyLinkFunctionModel, generateImageFunctionModel] completion:shareCompletion];
        } else {
            [SASocialShareView showShareWithShareObject:object completion:shareCompletion];
        }
    }];
}
@end
