//
//  TNIMManger.m
//  SuperApp
//
//  Created by xixi on 2021/1/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIMManger.h"
#import "TNIMDTO.h"
#import "HDMediator+SuperApp.h"
#import "UIView+NAT.h"
#import "SAWindowManager.h"
static const NSString *kIMArray = @"array";
static const NSString *kIMTimeStamp = @"timeStamp";


@interface TNIMManger ()
/// IM DTO
@property (nonatomic, strong) TNIMDTO *imDTO;
/// 缓存数据
@property (nonatomic, strong) NSMutableDictionary *cacheDict;
@end


@implementation TNIMManger

+ (TNIMManger *)shared {
    static dispatch_once_t onceToken;
    static TNIMManger *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shared];
}

#pragma mark -
- (void)getCustomerServerList:(NSString *)storeNo success:(void (^_Nullable)(NSArray<TNIMRspModel *> *rspModelArray))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    void (^getCustomerList)(void) = ^(void) {
        [self.imDTO queryCustomerList:storeNo success:^(NSArray<TNIMRspModel *> *_Nonnull rspModelArray) {
            @HDStrongify(self);
            if (rspModelArray.count > 0) {
                //如果有数据则缓存一下
                TNIMCacheModel *saveModel = TNIMCacheModel.new;
                saveModel.dataArray = rspModelArray;
                saveModel.storeNo = storeNo;
                saveModel.timeInterval = NSDate.date.timeIntervalSince1970;
                [self.cacheDict setObject:saveModel forKey:storeNo];
            }
            !successBlock ?: successBlock(rspModelArray);
        } failure:failureBlock];
    };

    //如果不存在缓存则直接请求接口
    if (![self.cacheDict.allKeys containsObject:storeNo]) {
        getCustomerList();
    } else {
        //如果存在key 对比时间策略
        //取出时间对比
        TNIMCacheModel *model = [self.cacheDict objectForKey:storeNo];
        NSTimeInterval nowVal = NSDate.date.timeIntervalSince1970;
        NSTimeInterval res = nowVal - model.timeInterval;
        //时间 不到一个小时就读取缓存数据
        if (res < 3600) {
            NSArray *arr = model.dataArray;
            if (arr.count > 0) {
                !successBlock ?: successBlock(arr);
            } else {
                //如果缓存没有数据 还是走一次请求
                getCustomerList();
            }
        } else {
            getCustomerList();
        }
    }
}
- (void)openCustomerServiceChatWithStoreNo:(NSString *)storeNo title:(nonnull NSString *)title content:(nonnull NSString *)content image:(nonnull NSString *)image {
    UIViewController *visibleVC = [SAWindowManager visibleViewController];
    [visibleVC.view showloading];
    @HDWeakify(self);
    [self getCustomerServerList:storeNo success:^(NSArray<TNIMRspModel *> *_Nonnull rspModelArray) {
        @HDStrongify(self);
        [visibleVC.view dismissLoading];
        if (rspModelArray.count > 0) {
            TNIMRspModel *imModel = rspModelArray.firstObject;
            HDLog(@"%@", imModel);
            [self openIMViewControllerAutoSendCardWithOperatorNo:imModel.operatorNo storeNo:storeNo title:title content:content image:image];
        } else {
            HDLog(@"没获取到数据");
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [visibleVC.view dismissLoading];
        HDLog(@"%@", error.domain);
    }];
}
- (void)openCustomerServiceChatWithStoreNo:(NSString *)storeNo orderNo:(NSString *)orderNo {
    @HDWeakify(self);
    UIViewController *visibleVC = [SAWindowManager visibleViewController];
    [visibleVC.view showloading];
    [self getCustomerServerList:storeNo success:^(NSArray<TNIMRspModel *> *_Nonnull rspModelArray) {
        @HDStrongify(self);
        [visibleVC.view dismissLoading];
        if (rspModelArray.count > 0) {
            TNIMRspModel *imModel = rspModelArray.firstObject;
            HDLog(@"%@", imModel);
            [self openIMViewControllerWithOperatorNo:imModel.operatorNo storeNo:storeNo orderNo:orderNo];
        } else {
            HDLog(@"没获取到数据");
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [visibleVC.view dismissLoading];
        HDLog(@"%@", error.domain);
    }];
}
/// 打开IM 有订单就自动发送订单消息
- (void)openIMViewControllerWithOperatorNo:(NSString *)operatorNo storeNo:(NSString *)storeNo orderNo:(NSString *)orderNo {
    NSMutableDictionary *params =
        [NSMutableDictionary dictionaryWithDictionary:@{@"operatorType": @(8), @"operatorNo": operatorNo ?: @"", @"storeNo": storeNo ?: @"", @"scene": SAChatSceneTypeTinhNowConsult}];
    if (HDIsStringNotEmpty(orderNo)) {
        params[@"prepareSendTxt"] = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"tn_im_orderNo", @"咨询订单，编号"), orderNo];
    }
    [[HDMediator sharedInstance] navigaveToIMViewController:params];
}

/// 打开IM  自动发送商品卡片
- (void)openIMViewControllerAutoSendCardWithOperatorNo:(NSString *)operatorNo
                                               storeNo:(NSString *)storeNo
                                                 title:(nonnull NSString *)title
                                               content:(nonnull NSString *)content
                                                 image:(nonnull NSString *)image {
    NSDictionary *cardDict = @{
        @"title": title ?: @"",
        @"content": content ?: @"",
        @"imageUrl": image,
        @"link": @"", //暂时用不上
    };
    NSString *cardJsonStr = [cardDict yy_modelToJSONString];
    NSDictionary *dict = @{
        @"operatorType": @(8),
        @"operatorNo": operatorNo ?: @"",
        @"storeNo": storeNo ?: @"",
        @"card": cardJsonStr,
    };
    [[HDMediator sharedInstance] navigaveToIMViewController:dict];
}
#pragma mark -
- (TNIMDTO *)imDTO {
    if (!_imDTO) {
        _imDTO = [[TNIMDTO alloc] init];
    }
    return _imDTO;
}

- (NSMutableDictionary *)cacheDict {
    if (!_cacheDict) {
        _cacheDict = [NSMutableDictionary dictionary];
    }
    return _cacheDict;
}
@end


@implementation TNIMCacheModel

@end
