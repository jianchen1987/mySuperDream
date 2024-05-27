//
//  SAImDelegateManager.m
//  SuperApp
//
//  Created by seeu on 2021/8/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAImDelegateManager.h"
#import "HDMediator+GroupOn.h"
#import "HDMediator+PayNow.h"
#import "HDMediator+SuperApp.h"
#import "HDMediator+TinhNow.h"
#import "HDMediator+YumNow.h"
#import "NSDate+SAExtension.h"
#import "SAOrderListDTO.h"
#import "SAOrderListRspModel.h"
#import "SAWindowManager.h"
#import <HDKitCore/HDKitCore.h>
#import <KSInstantMessagingKit/KSInstantMessagingKit.h>


@implementation SAImDelegateManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static SAImDelegateManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self shared];
}

#pragma mark - im delegate
- (void)didClickedOnInfoCard:(KSChatFloatCardViewModel *)card {
    if ([card isKindOfClass:KSChatGoodsFloatCardViewModel.class]) {
        KSChatGoodsFloatCardViewModel *trueCard = (KSChatGoodsFloatCardViewModel *)card;
        if (HDIsStringNotEmpty(card.extensionJson)) {
            [self processExtensionJson:card.extensionJson];
        } else if (HDIsStringNotEmpty(trueCard.link)) {
            [SAWindowManager openUrl:trueCard.link withParameters:nil];
        }
    } else if ([card isKindOfClass:KSChatOrderFloatCardViewModel.class]) {
        KSChatOrderFloatCardViewModel *trueCard = (KSChatOrderFloatCardViewModel *)card;
        if ([trueCard.bizLine isEqualToString:SAClientTypeYumNow]) {
            [HDMediator.sharedInstance navigaveToOrderDetailViewController:@{@"orderNo": trueCard.orderNo}];
        } else if ([trueCard.bizLine isEqualToString:SAClientTypeTinhNow]) {
            [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:@{@"orderNo": trueCard.orderNo}];
        } else if ([trueCard.bizLine isEqualToString:SAClientTypePhoneTopUp]) {
            [HDMediator.sharedInstance navigaveToTopUpDetailViewController:@{@"orderNo": trueCard.orderNo}];
        } else if ([trueCard.bizLine isEqualToString:SAClientTypeGroupBuy]) {
            [HDMediator.sharedInstance navigaveToGNOrderDetailViewController:@{@"orderNo": trueCard.bizOrderNo}];
        } else if ([trueCard.bizLine isEqualToString:SAClientTypeBillPayment]) {
            [HDMediator.sharedInstance navigaveToPayNowPaymentBillOrderDetailsVC:@{@"orderNo": trueCard.orderNo}];
        } else {
            [HDMediator.sharedInstance navigaveToCommonOrderDetails:@{@"orderNo": trueCard.orderNo}];
        }
    }
}

- (void)getOrderListWithPageNo:(NSUInteger)pageNo roster:(KSRoster *)roster completion:(void (^)(NSArray<KSChatOrderFloatCardViewModel *> *data, NSUInteger curPageNo, BOOL hasNext))completion {
    [[SAOrderListDTO new] getOrderListWithBusinessType:@"" orderState:SAOrderStateAll pageNum:pageNo pageSize:10 orderTimeStart:nil orderTimeEnd:nil success:^(SAOrderListRspModel *_Nonnull rspModel) {
        NSArray<KSChatOrderFloatCardViewModel *> *orders = [rspModel.list mapObjectsUsingBlock:^id _Nonnull(SAOrderModel *_Nonnull obj, NSUInteger idx) {
            NSString *storeLogo = @"";
            if ([obj.businessLine isEqualToString:SAClientTypePhoneTopUp]) {
                storeLogo = @"https://img.tinhnow.com/wownow/files/app/M89/89/50/4E/c9051330672411ed97565796da9bd9e5.png";
            } else if ([obj.businessLine isEqualToString:SAClientTypeYumNow]) {
                storeLogo = @"https://img.tinhnow.com/wownow/files/app/M89/89/50/4E/c9053a40672411eda5c20f9cf0ff5c62.png";
            } else if ([obj.businessLine isEqualToString:SAClientTypeTinhNow]) {
                storeLogo = @"https://img.tinhnow.com/wownow/files/app/M89/89/50/4E/c9049e00672411ed97565796da9bd9e5.png";
            } else if ([obj.businessLine isEqualToString:SAClientTypeGroupBuy]) {
                storeLogo = @"https://img.tinhnow.com/wownow/files/app/M89/89/50/4E/c90428d0672411eda5c20f9cf0ff5c62.png";
            } else if ([obj.businessLine isEqualToString:SAClientTypeBillPayment]) {
                storeLogo = @"https://img.tinhnow.com/wownow/files/app/M89/89/50/4E/c90401c0672411ed97565796da9bd9e5.png";
            } else if ([obj.businessLine isEqualToString:SAClientTypeGame]) {
                storeLogo = @"https://img.tinhnow.com/wownow/files/app/M89/89/50/4E/c905fd90672411eda5c20f9cf0ff5c62.png";
            } else if ([obj.businessLine isEqualToString:SAClientTypeHotel]) {
                storeLogo = @"https://img.tinhnow.com/wownow/files/app/M89/89/50/4E/c902f050672411ed97565796da9bd9e5.png";
            } else {
                storeLogo = obj.showUrl;
            }

            return [[KSChatOrderFloatCardViewModel alloc]
                initWithStoreLogo:storeLogo
                        storeName:obj.storeName.desc
                  orderStatusDesc:obj.businessOrderState
                        goodsIcon:obj.storeLogo
                        goodsDesc:obj.remark.desc
                        orderTime:[NSString stringWithFormat:@"%@:%@",
                                                             SALocalizedString(@"orderDetails_createTime", @"下单时间"),
                                                             [[NSDate dateWithTimeIntervalSince1970:obj.orderTime / 1000.0] stringWithFormatStr:@"dd/MM/yyyy HH:mm"]]
                            total:[NSString stringWithFormat:@"%@%@", SALocalizedString(@"total_title", @"总共:"), obj.actualPayAmount.thousandSeparatorAmount]
                     businessLine:obj.businessLine
                          orderNo:obj.orderNo
                       bizOrderNo:obj.businessOrderNo];
        }];

        !completion ?: completion(orders, rspModel.pageNum, rspModel.hasNextPage);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(@[], pageNo, NO);
    }];
}

- (void)feedbackWithFromOperatorNo:(NSString *)fromOperatorNo fromOperatorType:(NSInteger)fromOperatorType toOperatorNo:(NSString *)toOperatorNo toOperatorType:(NSInteger)toOperatorType {
    [HDMediator.sharedInstance
        navigaveToImFeedBackViewController:@{@"fromOperatorNo": fromOperatorNo, @"fromOperatorType": @(fromOperatorType), @"toOperatorNo": toOperatorNo, @"toOperatorType": @(toOperatorType)}];
}

#pragma mark 解析数据构造 路由
- (void)processExtensionJson:(NSString *)json {
    NSDictionary *dict = [json hd_dictionary];
    if ([dict.allKeys containsObject:@"businessLine"]) {
        NSString *businessLineValue = [dict objectForKey:@"businessLine"];
        if ([businessLineValue isEqualToString:SAClientTypeTinhNow]) {
            //处理电商逻辑
            [self tinhnow_processExtensionJson:json];
        }
    }
}

- (void)tinhnow_processExtensionJson:(NSString *)json {
    NSDictionary *dict = [json hd_dictionary];
    NSString *typeStr = [dict objectForKey:@"type"];
    NSString *valueStr = [dict objectForKey:@"value"];
    NSDictionary *valueDict = [valueStr hd_dictionary];
    NSString *paramStr = [self splicingParameter:valueDict];
    NSString *routPath = @"SuperApp://TinhNow/";
    if ([typeStr isEqualToString:@"productDetails"]) {
        routPath = [routPath stringByAppendingFormat:@"%@?%@", typeStr, paramStr];
    } else if ([typeStr isEqualToString:@"orderDetail"]) {
    }

    HDLog(@"routPath: %@", routPath);

    [SAWindowManager openUrl:routPath withParameters:nil];
}

#pragma mark Tool
- (NSString *)splicingParameter:(NSDictionary *)dict {
    __block NSString *str = @"";
    if (dict) {
        NSArray *keys = dict.allKeys;
        [keys enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (idx == 0) {
                str = [str stringByAppendingFormat:@"%@=%@", obj, dict[obj]];
            } else {
                str = [str stringByAppendingFormat:@"&%@=%@", obj, dict[obj]];
            }
        }];
    }

    return str;
}

@end
