//
//  SASocialShareView.m
//  SuperApp
//
//  Created by Chaos on 2020/12/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASocialShareView.h"
#import "HDWebImageManager.h"
#import "SAMultiLanguageManager.h"
#import "SAPayHelper.h"
#import "SAShareManager.h"
#import "SASocialShareGenerateImageView.h"
#import "SAWindowManager.h"
#import "UIView+NAT.h"

SAShareChannel const SAShareFunctionlCopyLink = @"link";               ///< 复制链接
SAShareChannel const SAShareFunctionlGenerateImage = @"generateImage"; ///< 生成图片
SAShareChannel const SAShareFunctionlSaveImage = @"PicShare";          ///< 保存图片


@interface SASocialShareView ()

/// 分享回调
@property (nonatomic, copy) ShareObjectCompletion completion;
/// 分享对象
@property (nonatomic, strong) SAShareObject *shareObject;
/// 顶部自定义视图
@property (nonatomic, strong) SASocialShareBaseGenerateImageView *topCustomView;

@property (nonatomic, strong, class, readonly) NSArray *defaultChannel;

@end


@implementation SASocialShareView

+ (NSArray *)defaultChannel {
    return @[
        SAShareChannelWechatSession,
        SAShareChannelWechatTimeline,
        SAShareChannelFacebook,
        SAShareChannelMessenger,
        SAShareChannelTwitter,
        SAShareChannelLine,
        SAShareChannelTelegram,
        SAShareChannelMore
    ];
}

+ (void)showShareWithShareObject:(SAShareObject *)shareObject completion:(ShareObjectCompletion _Nullable)completion {
    [self showShareWithShareObject:shareObject functionModels:@[SASocialShareView.copyLinkFunctionModel, SASocialShareView.generateImageFunctionModel, SASocialShareView.saveImageFunctionModel]
                        completion:completion];
}

+ (void)showShareWithShareObject:(SAShareObject *)shareObject inChannels:(NSArray<SAShareChannel> *)channels completion:(ShareObjectCompletion)completion {
    [self showShareWithShareObject:shareObject inChannels:channels functions:@[SAShareFunctionlCopyLink, SAShareFunctionlGenerateImage, SAShareFunctionlSaveImage] completion:completion];
}

+ (void)showShareWithShareObject:(SAShareObject *)shareObject
                      inChannels:(NSArray<SAShareChannel> *)channels
                       functions:(NSArray<SAShareFunction> *)functions
                      completion:(ShareObjectCompletion)completion {
    [self showShareWithShareObject:shareObject inChannels:channels functions:functions hiddenFunctions:NO completion:completion];
}

+ (void)showShareWithShareObject:(SAShareObject *)shareObject
                      inChannels:(NSArray<SAShareChannel> *)channels
                       functions:(NSArray<SAShareFunction> *)functions
                 hiddenFunctions:(BOOL)hiddenFunctions
                      completion:(ShareObjectCompletion)completion {
    //处理自定义渠道
    NSMutableArray *mChannels = NSMutableArray.new;
    for (NSString *str in channels) {
        if ([self.defaultChannel containsObject:str]) {
            [mChannels addObject:str];
        }
    }

    if (!mChannels.count) {
        mChannels = self.defaultChannel.mutableCopy;
    }

    //处理自定义功能
    NSMutableArray *mFuntionModels = NSMutableArray.new;

    if (!hiddenFunctions) { //不隐藏功能按钮
        for (NSString *str in functions) {
            if ([str isEqualToString:SAShareFunctionlCopyLink]) {
                [mFuntionModels addObject:SASocialShareView.copyLinkFunctionModel];
            } else if ([str isEqualToString:SAShareFunctionlGenerateImage]) {
                [mFuntionModels addObject:SASocialShareView.generateImageFunctionModel];
            } else if ([str isEqualToString:SAShareFunctionlSaveImage]) {
                [mFuntionModels addObject:SASocialShareView.saveImageFunctionModel];
            }
        }

        if (!mFuntionModels.count) {
            [mFuntionModels addObject:SASocialShareView.copyLinkFunctionModel];
            [mFuntionModels addObject:SASocialShareView.generateImageFunctionModel];
            [mFuntionModels addObject:SASocialShareView.saveImageFunctionModel];
        }
    }

    [self showShareWithShareObject:shareObject inChannels:mChannels functionModels:mFuntionModels completion:completion];
}

+ (void)showShareWithShareObject:(SAShareObject *)shareObject functionModels:(NSArray<HDSocialShareCellModel *> *)functionModels completion:(ShareObjectCompletion _Nullable)completion {
    [self showShareWithShareObject:shareObject inChannels:self.defaultChannel functionModels:functionModels completion:completion];
}

+ (void)showShareWithShareObject:(SAShareObject *)shareObject
                      inChannels:(NSArray<SAShareChannel> *)channels
                  functionModels:(NSArray<HDSocialShareCellModel *> *)functionModels
                      completion:(ShareObjectCompletion _Nullable)completion {
    NSArray<HDSocialShareCellModel *> *shareDatas = [self shareModelsWithChannels:channels];

    NSMutableArray *functionDatas = [NSMutableArray array];
    // 为其他操作按钮设置默认实现
    for (HDSocialShareCellModel *model in functionModels) {
        if ([model.associatedObject isEqualToString:SAShareFunctionlCopyLink] && !model.clickedHandler) {
            if (![shareObject isKindOfClass:SAShareWebpageObject.class]) {
                continue; // 分享的不是链接，不添加复制链接操作按钮
            }
        } else if ([model.associatedObject isEqualToString:SAShareFunctionlGenerateImage] && !model.clickedHandler) {
            if (![shareObject isKindOfClass:SAShareWebpageObject.class]) {
                continue; // 分享的不是链接，不添加生成图片操作按钮
            }
        } else if ([model.associatedObject isEqualToString:SAShareFunctionlSaveImage] && !model.clickedHandler) {
            if (![shareObject isKindOfClass:SAShareImageObject.class]) {
                continue; // 分享的不是图片，不添加保存图片操作按钮
            }
        }
        [functionDatas addObject:model];
    }

    SASocialShareView *shareAlertView = [SASocialShareView alertViewWithTitle:SALocalizedString(@"share_title", @"分享到") cancelTitle:SALocalizedString(@"cancel", @"取消") shareData:shareDatas
                                                                 functionData:functionDatas
                                                                       config:self.alertViewconfig];
    shareAlertView.completion = completion;
    shareAlertView.shareObject = shareObject;
    shareAlertView.didTappedBackgroundHandler = ^(HDActionAlertView *_Nonnull alertView) {
        !completion ?: completion(false, nil);
    };

    [shareAlertView addShareDatasClickHandlersWithShareDatas:shareDatas];
    [shareAlertView addFunctionDatasClickHandlersWithFunctionDatas:functionDatas];
    [shareAlertView show];
}

+ (void)showShareWithTopCustomView:(SASocialShareBaseGenerateImageView *)topCustomView completion:(ShareObjectCompletion _Nullable)completion {
    NSMutableArray<HDSocialShareCellModel *> *functionDatas = [[NSMutableArray alloc] init];
    [functionDatas addObject:self.saveImageFunctionModel];
    [functionDatas
        addObjectsFromArray:
            [self
                shareModelsWithChannels:
                    @[SAShareChannelWechatSession, SAShareChannelWechatTimeline, SAShareChannelFacebook, SAShareChannelMessenger, SAShareChannelTwitter, SAShareChannelInstagram, SAShareChannelLine]]];

    SASocialShareView *shareAlertView = [SASocialShareView alertViewWithTitle:SALocalizedString(@"share_title", @"分享到") cancelTitle:SALocalizedString(@"cancel", @"取消") shareData:nil
                                                                 functionData:functionDatas
                                                                       config:self.alertViewconfig];
    @HDWeakify(shareAlertView);
    shareAlertView.clickedFunctionItemHandler = ^(HDSocialShareAlertView *_Nonnull alertView, HDSocialShareCellModel *_Nonnull model, NSInteger index) {
        @HDStrongify(shareAlertView);
        if (index == 0) { // 保存图片
            UIImage *generateImage = [topCustomView generateImageWithChannel:SAShareChannelWechatSession];
            UIImageWriteToSavedPhotosAlbum(generateImage, shareAlertView, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        } else { // 分享
            SAShareImageObject *shareObject = SAShareImageObject.new;
            shareObject.shareImage = [topCustomView generateImageWithChannel:model.associatedObject];
            [SAShareManager shareObject:shareObject inChannel:model.associatedObject completion:completion];
        }
    };
    shareAlertView.completion = completion;
    shareAlertView.didTappedBackgroundHandler = ^(HDActionAlertView *_Nonnull alertView) {
        !completion ?: completion(false, nil);
    };
    shareAlertView.topCustomView = topCustomView;

    [shareAlertView addSubview:topCustomView];
    [topCustomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shareAlertView);
        make.bottom.equalTo(shareAlertView).offset(-(floor((220) * (kScreenHeight / 667.0)))).priorityLow();
        make.top.greaterThanOrEqualTo(shareAlertView).offset(kStatusBarH).priorityHigh();
    }];

    [shareAlertView show];
}

+ (HDSocialShareAlertViewConfig *)alertViewconfig {
    HDSocialShareAlertViewConfig *config = HDSocialShareAlertViewConfig.new;
    config.cancelButtonBackgroundColor = UIColor.whiteColor;
    config.titleColor = HexColor(0x5D5D5D);
    config.titleFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    config.contentViewEdgeInsets = UIEdgeInsetsMake(25, 20, 10, 20);
    config.marginTitleToCollectionView = 10;
    return config;
}

#pragma mark - 重写父类方法
- (void)show {
    if (self.topCustomView) {
        self.topCustomView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.topCustomView.alpha = 1;
        }];
    }
    [super show];
}

- (void)dismissCompletion:(void (^)(void))completion {
    if (self.topCustomView) {
        // 时间需小于弹窗消失的时间
        [UIView animateWithDuration:0.25 animations:^{
            self.topCustomView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.topCustomView removeFromSuperview];
            // 需要再将透明度设为1，否则生成图片时会是一张全透明的图
            self.topCustomView.alpha = 1;
        }];
    }
    [super dismissCompletion:completion];
}

- (void)dismiss {
    !self.completion ?: self.completion(false, nil);
    [super dismiss];
}

#pragma mark - 默认按钮点击实现
// 为分享渠道按钮增加点击事件
- (void)addShareDatasClickHandlersWithShareDatas:(NSArray<HDSocialShareCellModel *> *)shareDatas {
    for (HDSocialShareCellModel *model in shareDatas) {
        model.clickedHandler = ^(HDSocialShareCellModel *_Nonnull model, NSInteger index) {
            if ([model.associatedObject isEqualToString:SAShareChannelMore]) {
                [SASocialShareView moreFunctionDefaultClickHandlerWithShareObject:self.shareObject completion:self.completion];
            } else {
                [SAShareManager shareObject:self.shareObject inChannel:model.associatedObject completion:self.completion];
            }
        };
    }
}

// 为其他操作按钮增加点击事件
- (void)addFunctionDatasClickHandlersWithFunctionDatas:(NSArray<HDSocialShareCellModel *> *)functionDatas {
    for (HDSocialShareCellModel *model in functionDatas) {
        if ([model.associatedObject isEqualToString:SAShareFunctionlCopyLink] && !model.clickedHandler) {
            // 复制链接默认实现
            if ([self.shareObject isKindOfClass:SAShareWebpageObject.class]) {
                model.clickedHandler = ^(HDSocialShareCellModel *_Nonnull model, NSInteger index) {
                    [SASocialShareView copyLinkFunctionDefaultClickHandlerWithShareObject:self.shareObject completion:self.completion];
                };
            }
        } else if ([model.associatedObject isEqualToString:SAShareFunctionlGenerateImage] && !model.clickedHandler) {
            // 生成图片默认实现
            if ([self.shareObject isKindOfClass:SAShareWebpageObject.class]) {
                model.clickedHandler = ^(HDSocialShareCellModel *_Nonnull model, NSInteger index) {
                    SAShareWebpageObject *trueShareObject = (SAShareWebpageObject *)self.shareObject;
                    SASocialShareGenerateImageView *generateImageView = [[SASocialShareGenerateImageView alloc] initWithShareObject:trueShareObject];
                    [SASocialShareView showShareWithTopCustomView:generateImageView completion:self.completion];
                };
            }
        } else if ([model.associatedObject isEqualToString:SAShareFunctionlSaveImage] && !model.clickedHandler) {
            // 保存图片默认实现
            if ([self.shareObject isKindOfClass:SAShareImageObject.class]) {
                @HDWeakify(self);
                model.clickedHandler = ^(HDSocialShareCellModel *_Nonnull model, NSInteger index) {
                    @HDStrongify(self);
                    SAShareImageObject *trueShareObject = (SAShareImageObject *)self.shareObject;
                    UIImageWriteToSavedPhotosAlbum(trueShareObject.shareImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                    !self.completion ?: self.completion(YES, SAShareFunctionlSaveImage);
                };
            }
        }
    }
}

#pragma mark - 自定义按钮实现
// 复制链接实现
+ (void)copyLinkFunctionDefaultClickHandlerWithShareObject:(SAShareObject *)shareObject completion:(void (^_Nullable)(BOOL, NSString *_Nullable))completion {
    if (![shareObject isKindOfClass:SAShareWebpageObject.class]) {
        [NAT showToastWithTitle:nil content:SALocalizedString(@"pFpFHpps", @"仅支持复制链接") type:HDTopToastTypeInfo];
        return;
    }
    SAShareWebpageObject *trueShareObject = (SAShareWebpageObject *)shareObject;
    NSMutableString *pasteboardString = [NSMutableString string];
    [pasteboardString appendString:SALocalizedString(@"share_link_text_prefix", @"我刚在WOWNOW看到这个，快来围观：")];
    [pasteboardString appendString:@"\n"];
    [pasteboardString appendString:shareObject.title];
    [pasteboardString appendString:@"\n"];
    [pasteboardString appendString:HDIsStringNotEmpty(trueShareObject.facebookWebpageUrl) ? trueShareObject.facebookWebpageUrl : trueShareObject.webpageUrl];
    [pasteboardString appendString:@"\n"];
    [pasteboardString appendString:SALocalizedString(@"share_link_text_suffix", @"更多优惠，尽在WOWNOW。")];

    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = pasteboardString;
    [NAT showToastWithTitle:nil content:SALocalizedString(@"share_link_success", @"复制成功") type:HDTopToastTypeInfo];
    !completion ?: completion(YES, SAShareFunctionlCopyLink);
}

// 更多分享实现
+ (void)moreFunctionDefaultClickHandlerWithShareObject:(SAShareObject *)shareObject completion:(void (^_Nullable)(BOOL, NSString *_Nullable))completion {
    UIViewController *visibleViewController = [SAWindowManager visibleViewController];

    void (^socialShare)(UIImage *, NSString *, NSString *) = ^void(UIImage *image, NSString *title, NSString *url) {
        [HDSystemCapabilityUtil socialShareTitle:title image:image content:url inViewController:visibleViewController result:^(NSError *_Nonnull error) {
            HDLog(@"%@", error);
            !completion ?: completion(error ? NO : YES, SAShareChannelMore);
        }];
    };
    // 分享链接
    NSString *url;
    if ([shareObject isKindOfClass:SAShareWebpageObject.class]) {
        SAShareWebpageObject *trueShareObject = (SAShareWebpageObject *)shareObject;
        url = trueShareObject.webpageUrl;
    }
    // 分享图片
    id image = shareObject.thumbImage;
    if ([shareObject isKindOfClass:SAShareImageObject.class]) {
        image = ((SAShareImageObject *)shareObject).shareImage;
    }

    if ([image isKindOfClass:NSString.class]) {
        NSString *imageUrl = (NSString *)image;
        if (HDIsStringNotEmpty(imageUrl)) {
            [visibleViewController.view showloading];
            [HDWebImageManager setImageWithURL:imageUrl placeholderImage:nil imageView:UIImageView.new
                                     completed:^(UIImage *_Nullable shareImage, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                         [visibleViewController.view dismissLoading];
                                         if (!error) {
                                             socialShare(shareImage, shareObject.title, url);
                                         } else {
                                             socialShare(nil, shareObject.title, url);
                                         }
                                     }];
        } else {
            socialShare(nil, shareObject.title, url);
        }
    } else if ([image isKindOfClass:UIImage.class]) {
        socialShare(image, shareObject.title, url);
    } else {
        socialShare(nil, shareObject.title, url);
    }
}

#pragma mark - 保存图片回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [NAT showToastWithTitle:nil content:error.description type:HDTopToastTypeInfo];
        !self.completion ?: self.completion(false, SAShareFunctionlSaveImage);
    } else {
        [NAT showToastWithTitle:nil content:WMLocalizedString(@"0lRpcSlG", @"保存图片成功") type:HDTopToastTypeInfo];
        !self.completion ?: self.completion(true, SAShareFunctionlSaveImage);
    }
}

#pragma mark - 提供默认按钮
/// 复制链接按钮模型
+ (HDSocialShareCellModel *)copyLinkFunctionModel {
    return [HDSocialShareCellModel modelWithTitle:SALocalizedString(@"share_link_text", @"复制链接") image:[UIImage imageNamed:@"share_link_icon"] associatedObject:SAShareFunctionlCopyLink];
}
/// 生成图片按钮模型
+ (HDSocialShareCellModel *)generateImageFunctionModel {
    return [HDSocialShareCellModel modelWithTitle:SALocalizedString(@"share_image_text", @"生成图片") image:[UIImage imageNamed:@"share_image_icon"] associatedObject:SAShareFunctionlGenerateImage];
}
/// 保存图片按钮模型
+ (HDSocialShareCellModel *)saveImageFunctionModel {
    return [HDSocialShareCellModel modelWithTitle:SALocalizedString(@"share_PicShare_image", @"保存图片") image:[UIImage imageNamed:@"share_saveImage_icon"]
                                 associatedObject:SAShareFunctionlSaveImage];
}
/// 更多按钮模型
+ (HDSocialShareCellModel *)moreFunctionModel {
    return [HDSocialShareCellModel modelWithTitle:SALocalizedString(@"share_more_text", @"更多") image:[UIImage imageNamed:@"share_more_icon"] associatedObject:SAShareChannelMore];
}
/// 分享渠道按钮模型
+ (NSArray<HDSocialShareCellModel *> *)shareModelsWithChannels:(NSArray<SAShareChannel> *)channels {
    NSMutableArray<HDSocialShareCellModel *> *shareDatas = [[NSMutableArray alloc] init];
    for (SAShareChannel channel in channels) {
        NSString *name = [NSString stringWithFormat:@"share_%@_text", channel];
        HDSocialShareCellModel *model = [HDSocialShareCellModel modelWithTitle:SALocalizedString(name, channel) image:[UIImage imageNamed:[NSString stringWithFormat:@"share_%@_icon", channel]]
                                                              associatedObject:channel];
        [shareDatas addObject:model];
    }
    return shareDatas;
}

@end
