//
//  HDWebFeatureShare.m
//  customer
//
//  Created by 谢泽锋 on 2019/3/25.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDWebFeatureShare.h"
#import "HDCodeGenerator.h"
#import "HDSocialShareAlertView.h"
#import "SAShareManager.h"
//#import <UMCommon/UMCommon.h>
//#import <UMShare/UMShare.h>

@interface HDWebFeatureShare ()
@property (nonatomic, strong) NSMutableArray<HDSocialShareCellModel *> *shareArray;
@end

@interface HDWebFeatureShareChannelModel : NSObject
@property (nonatomic, copy) NSString *type;   ///< 类型
@property (nonatomic, copy) NSString *value;  ///< 值
@end

@implementation HDWebFeatureShareChannelModel

@end

@implementation HDWebFeatureShare
//- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {
//    // 监听返回事件
//    webFeatureResponse(self, [self responseSuccess]);
//
//    NSArray<HDWebFeatureShareChannelModel *> *modelArray = [NSArray yy_modelArrayWithClass:HDWebFeatureShareChannelModel.class
//                                                                                      json:self.parameter.param[@"params"][@"contents"]];
//
//    __block HDWebFeatureShareChannelModel *urlModel;
//    __block HDWebFeatureShareChannelModel *judgeNeedQRCodeShareModel;
//    [modelArray enumerateObjectsUsingBlock:^(HDWebFeatureShareChannelModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
//        if ([obj.type isEqualToString:@"channel"]) {
//            judgeNeedQRCodeShareModel = obj;
//        } else if ([obj.type isEqualToString:@"url"]) {
//            urlModel = obj;
//        }
//    }];
//    NSString *value = judgeNeedQRCodeShareModel.value;
//    if (judgeNeedQRCodeShareModel && [value isEqualToString:@"1"]) {
//        ClickedHandler copyHandler = ^void(HDSocialShareCellModel *model, NSInteger index) {
//            [UIPasteboard generalPasteboard].string = urlModel.value;
//            [HDTips showWithText:PNLocalizedString(@"hint_link_copied", @"链接已复制，快去分享吧", nil) inView:self.viewController.view hideAfterDelay:2].toastPosition = HDToastViewPositionBottom;
//            [HDTalkingData trackEvent:@"分享_点击"
//                                label:@"复制链接"
//                           parameters:@{@"链接": urlModel.value,
//                                        @"来源页面": @"内部浏览器"}];
//        };
//
//        // 添加复制链接和扫码分享
//        HDSocialShareCellModel *model = [HDSocialShareCellModel modelWithTitle:PNLocalizedString(@"copy_link", @"复制链接", nil)
//                                                                         image:[UIImage imageNamed:@"share_link_icon"]
//                                                                clickedHandler:copyHandler];
//        [self.shareArray addObject:model];
//
//        UIImage *qrCodeImage = [HDCodeGenerator qrCodeImageForStr:urlModel.value size:CGSizeMake(300, 300) logoImage:[UIImage imageNamed:@"logo_qrcode"]];
//        ClickedHandler scanHandler = ^void(HDSocialShareCellModel *model, NSInteger index) {
//            HDShareImageAlertView *qrCodeAlertView = [HDShareImageAlertView alertViewWithTitle:PNLocalizedString(@"invite_friends_to_vipay", @"邀请好友加入ViPay", nil)
//            subTitle:PNLocalizedString(@"scan_to_register", @"用手机扫二维码，马上完成注册", nil) tipStr:PNLocalizedString(@"tips_for_iphone_user", @"（iPhone用户建议用手机自带相机打开）", nil)
//            cancelTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消", @"") image:qrCodeImage config:nil]; [qrCodeAlertView show]; [HDTalkingData trackEvent:@"分享_点击"
//                                label:@"扫码分享"
//                           parameters:@{@"链接": urlModel.value,
//                                        @"来源页面": @"内部浏览器"}];
//        };
//        model = [HDSocialShareCellModel modelWithTitle:PNLocalizedString(@"scan_to_share", @"扫码分享", nil)
//                                                 image:[UIImage imageNamed:@"share_Scan_icon"]
//                                        clickedHandler:scanHandler];
//        [self.shareArray addObject:model];
//    }
//
//    HDSocialShareAlertView *shareAlertView = [HDSocialShareAlertView alertViewWithTitle:PNLocalizedString(@"BUTTON_TITLE_SHARE", @"分享", @"")
//                                                                            cancelTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消", @"")
//                                                                             dataSource:self.shareArray
//                                                                                 config:nil];
//    __weak __typeof(self) weakSelf = self;
//    shareAlertView.clickedShareItemHandler = ^(HDSocialShareAlertView *alertView, HDSocialShareCellModel *model, NSInteger index) {
//        __strong __typeof(weakSelf) strongSelf = weakSelf;
//        HDShareChannel channel = (HDShareChannel)model.associatedObject;
//        [strongSelf shareAppToChannel:channel shareConfigArray:modelArray];
//
//        [HDTalkingData trackEvent:@"分享_点击"
//                            label:channel
//                       parameters:@{@"链接": urlModel.value,
//                                    @"来源页面": @"内部浏览器"}];
//    };
//    [shareAlertView show];
//}
//
//- (void)shareAppToChannel:(HDShareChannel)channel shareConfigArray:(NSArray<HDWebFeatureShareChannelModel *> *)configArray {
//
//    __block HDWebFeatureShareChannelModel *titleModel;
//    __block HDWebFeatureShareChannelModel *descModel;
//    __block HDWebFeatureShareChannelModel *urlModel;
//    __block HDWebFeatureShareChannelModel *thumbImageModel;
//    [configArray enumerateObjectsUsingBlock:^(HDWebFeatureShareChannelModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
//        if ([obj.type isEqualToString:@"title"]) {
//            titleModel = obj;
//        } else if ([obj.type isEqualToString:@"description"]) {
//            descModel = obj;
//        } else if ([obj.type isEqualToString:@"url"]) {
//            urlModel = obj;
//        } else if ([obj.type isEqualToString:@"image"]) {
//            thumbImageModel = obj;
//        }
//    }];
//
//    [SAShareManager shareUrlString:urlModel.value
//                         withTitle:titleModel.value
//                          describe:descModel.value
//                  thumPicUrlString:thumbImageModel.value
//                         toChannel:channel
//             currentViewController:self.viewController
//                            finish:^(id _Nonnull data, NSError *_Nonnull error) {
//                                if (error) {
//                                    [NAT showAlertWithMessage:PNLocalizedString(@"share_fail", @"分享失败", nil)
//                                                  buttonTitle:PNLocalizedString(@"BUTTON_TITLE_CONFIRM", @"确定", @"")
//                                                      handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
//                                                          [alertView dismiss];
//                                                      }];
//                                    [HDTalkingData trackEvent:@"分享_失败"
//                                                        label:channel
//                                                   parameters:@{@"链接": urlModel.value,
//                                                                @"来源页面": @"内部浏览器"}];
//                                    HDLog(@"************Share fail with error %@*********", error);
//                                } else {
//                                    [NAT showAlertWithMessage:PNLocalizedString(@"share_succ", @"分享成功", nil)
//                                                  buttonTitle:PNLocalizedString(@"BUTTON_TITLE_CONFIRM", @"确定", @"")
//                                                      handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
//                                                          [alertView dismiss];
//                                                      }];
//                                    [HDTalkingData trackEvent:@"分享_成功"
//                                                        label:channel
//                                                   parameters:@{@"链接": urlModel.value,
//                                                                @"来源页面": @"内部浏览器"}];
//
//                                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                                        UMSocialShareResponse *resp = data;
//                                        // 分享结果消息
//                                        HDLog(@"response message is %@", resp.message);
//                                        // 第三方原始返回的数据
//                                        HDLog(@"response originalResponse data is %@", resp.originalResponse);
//                                    } else {
//                                        HDLog(@"response data is %@", data);
//                                    }
//                                }
//                            }];
//}
//
//- (NSMutableArray<HDSocialShareCellModel *> *)shareArray {
//    if (!_shareArray) {
//        _shareArray = [NSMutableArray new];
//        NSArray<HDShareChannel> *usefulChannels = [SAShareManager supporShareChannel];
//
//        for (HDShareChannel channel in usefulChannels) {
//            NSString *name = [NSString stringWithFormat:@"share_%@_txt", channel];
//            HDSocialShareCellModel *model = [HDSocialShareCellModel modelWithTitle:PNLocalizedString(name, channel, nil)
//                                                                             image:[UIImage imageNamed:[NSString stringWithFormat:@"share_%@_icon", channel]]
//                                                                  associatedObject:channel];
//
//            [_shareArray addObject:model];
//        }
//    }
//    return _shareArray;
//}
//
//- (NSString *)URLDecode:(NSString *)string {
//    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//}
@end
