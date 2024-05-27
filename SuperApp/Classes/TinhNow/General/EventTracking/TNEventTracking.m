//
//  TNEventTracking.m
//  SuperApp
//
//  Created by 张杰 on 2023/3/17.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "TNEventTracking.h"
#import "Mixpanel.h"
#import "SAAppEnvManager.h"
#import "SAUser.h"
#import <HDKitCore/HDKitCore.h>


@interface TNEventTracking ()
/// 来源
@property (nonatomic, copy) NSString *source;
/// 页面ID 页面埋点后记录最新的页面id
@property (nonatomic, copy) NSString *pageId;
/// 页面通用的参数  有的话  在页面埋点的时候 就会带过来 可以在当前的事件埋点中记录
@property (strong, nonatomic) NSDictionary *pageCommonProperties;
@end


@implementation TNEventTracking
- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameChangeAppEnvSuccess object:self];
}
+ (instancetype)instance {
    static dispatch_once_t onceToken;
    static TNEventTracking *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [Mixpanel sharedInstanceWithToken:@"" trackAutomaticEvents:YES];
        //使用people之前要先调用这个方法
        [[Mixpanel sharedInstance] identify:[[Mixpanel sharedInstance] distinctId]];
        if ([SAUser hasSignedIn]) {
            [self trackPeople];
        }
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(loginSuccessHandler) name:kNotificationNameLoginSuccess object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(changeAppEnvSuccess) name:kNotificationNameChangeAppEnvSuccess object:nil];
    }
    return self;
}
+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self instance];
}

- (void)parseOpenRouter:(NSString *)router {
    if (HDIsStringNotEmpty(router)) {
        NSArray *itemArr = [router componentsSeparatedByString:@"&"];
        [itemArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSArray *elts = [obj componentsSeparatedByString:@"="];
            if (elts.count == 2) {
                NSString *key = elts.firstObject;
                NSString *value = elts.lastObject;
                if ([key isEqualToString:@"source"] && HDIsStringNotEmpty(value)) {
                    self.source = value;
                    *stop = YES;
                }
            }
        }];
    }
}
#pragma mark - UserLoginStateChanged
- (void)loginSuccessHandler {
    [self trackPeople];
}

#pragma mark - Notification
- (void)changeAppEnvSuccess {
    MixpanelInstance.serverURL = SAAppEnvManager.sharedInstance.appEnvConfig.tinhNowLog;
}
- (void)trackPeople {
    if (HDIsStringNotEmpty(SAUser.shared.loginName)) {
        [MixpanelInstance.people set:@{@"loginName": SAUser.shared.loginName}];
    }
}
- (void)trackPage:(NSString *)pageName properties:(NSDictionary *)properties {
    self.pageId = pageName; //记录
    self.pageCommonProperties = properties;
    [self trackEvent:pageName properties:properties];
}

- (void)trackEvent:(NSString *)eventName properties:(NSDictionary *)properties {
    [self trackEvent:eventName properties:properties isNeedAppendPageId:YES];
}

- (void)trackEvent:(NSString *)eventName properties:(NSDictionary *)properties isNeedAppendPageId:(BOOL)isNeedAppendPageId {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!HDIsObjectNil(properties)) {
        [params addEntriesFromDictionary:properties];
    }
    NSString *source = self.source;
    if (HDIsStringNotEmpty(source)) {
        [params setObject:source forKey:@"source"];
    }
    // 拼接用户参数
    if ([SAUser hasSignedIn]) {
        [params setObject:SAUser.shared.loginName forKey:@"loginName"];
    }
    NSString *pageId = self.pageId;
    if (HDIsStringNotEmpty(pageId) && isNeedAppendPageId) {
        [params setObject:pageId forKey:@"pageId"];
        if (!HDIsObjectNil(self.pageCommonProperties)) { //拼接通用页面参数
            [params addEntriesFromDictionary:self.pageCommonProperties];
        }
    }
    [MixpanelInstance track:eventName properties:params];
}

- (void)startRecordingExposureIndexWithProductId:(NSString *)productId {
    [self.exposureTool startRecordingExposureIndexWithProductId:productId];
}
- (void)trackExposureScollProductsEventWithProperties:(NSDictionary *)properties {
    NSString *currentPageId = self.pageId;
    NSDictionary *currentProperties = self.pageCommonProperties;
    if (!HDIsArrayEmpty(self.exposureTool.productIds)) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (!HDIsObjectNil(properties)) {
            [dict addEntriesFromDictionary:properties];
        }
        NSArray *productIds = [self.exposureTool.productIds copy];
        [dict setObject:productIds forKey:@"productIds"];
        BOOL isNeedAppendPageId = YES;
        if (HDIsStringNotEmpty(currentPageId)) {
            isNeedAppendPageId = NO;
            [dict setObject:currentPageId forKey:@"pageId"];
            if (!HDIsObjectNil(currentProperties)) {
                [dict addEntriesFromDictionary:currentProperties];
            }
        }
        [self trackEvent:@"scroll_product" properties:dict isNeedAppendPageId:isNeedAppendPageId];
    }
    //清空
    [self.exposureTool clean];
}
//- (void)trackExposureScollProductsEventWithProductsListDict:(NSDictionary *)productsListDict properties:(NSDictionary *)properties{
//    NSString *currentPageId = self.pageId;
//    NSDictionary *currentProperties = self.pageCommonProperties;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
////        [self.exposureTool processExposureProductsIdByProductsListDict:productsListDict];
//        if (!HDIsArrayEmpty(self.exposureTool.productIds)) {
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            if (!HDIsObjectNil(properties)) {
//                [dict addEntriesFromDictionary:properties];
//            }
//            NSArray *productIds = [self.exposureTool.productIds copy];
//            [dict setObject:productIds forKey:@"productIds"];
//            BOOL isNeedAppendPageId = YES;
//            if(HDIsStringNotEmpty(currentPageId)){
//                isNeedAppendPageId = NO;
//                [dict setObject:currentPageId forKey:@"pageId"];
//                if(!HDIsObjectNil(currentProperties))
//                [dict addEntriesFromDictionary:currentProperties];
//            }
//            [self trackEvent:@"scroll_product" properties:dict isNeedAppendPageId:isNeedAppendPageId];
//        }
//        //清空
//        [self.exposureTool clean];
//    });
//}

/** @lazy exposureTool */
- (TNProductsExposureTool *)exposureTool {
    if (!_exposureTool) {
        _exposureTool = [[TNProductsExposureTool alloc] init];
    }
    return _exposureTool;
}
@end
