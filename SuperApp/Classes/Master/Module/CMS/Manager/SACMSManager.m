//
//  SACMSManager.m
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSManager.h"
#import "SAAddressZoneModel.h"
#import "SAAppSwitchManager.h"
#import "SACMSCardViewConfig.h"
#import "SACMSTitleViewConfig.h"
#import "SACacheManager.h"
#import "SAChooseZoneDTO.h"
#import "SACacheManager.h"
#import "SAWriteDateReadableModel.h"


@interface SACMSManager ()

@property (nonatomic, strong) SAChooseZoneDTO *chooseZoneDTO;

@end


@implementation SACMSManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SACMSManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

#pragma mark - public methods
+ (void)getPageWithAddress:(SAAddressModel *)addressModel
                  identify:(CMSPageIdentify)identify
                 pageWidth:(CGFloat)pageWidth
                operatorNo:(NSString *_Nullable)operatorNo
                   success:(void (^)(SACMSPageView *_Nonnull, SACMSPageViewConfig *_Nonnull))success
                   failure:(CMNetworkFailureBlock)failure {
    void (^startCMSRequest)(NSString *, NSString *) = ^(NSString *cityCode, NSString *pageIdentify) {
        
        __block BOOL hasCallBack = NO;
        
        // 拿缓存
        HDLog(@"检查是否有缓存[%@][%@][%@]", pageIdentify, [SAMultiLanguageManager currentLanguage], cityCode);
        
        SAWriteDateReadableModel *cacheModel =
            [SACacheManager.shared objectForKey:[NSString stringWithFormat:@"%@_%@_%@", pageIdentify, [SAMultiLanguageManager currentLanguage], HDIsStringNotEmpty(cityCode) ? cityCode : @"855120000"]
                                           type:SACacheTypeDocumentPublic];
        
        SACMSPageViewConfig *cacheCfg = [SACMSPageViewConfig yy_modelWithJSON:cacheModel.storeObj];
        if (!HDIsObjectNil(cacheCfg)) {
            HDLog(@"有缓存，先用缓存渲染");
            cacheCfg.identify = pageIdentify;
            cacheCfg.addressModel = addressModel;
            
            [self sortConfig:cacheCfg success:^{
                SACMSPageView *pageView = [[SACMSPageView alloc] initWithWidth:pageWidth config:cacheCfg];
                hasCallBack = YES;
                !success ?: success(pageView, cacheCfg);
            }];
        } else {
            HDLog(@"没缓存, 直接请求");
        }

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CMNetworkRequest *request = CMNetworkRequest.new;
            request.retryCount = 1;
            request.requestURI = @"/app/config/cms/getPageHome";
            request.isNeedLogin = false;
            request.shouldAlertErrorMsgExceptSpecCode = false;
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];
            [params addEntriesFromDictionary:@{
                @"pageLable": pageIdentify,
                @"cityCode": HDIsStringNotEmpty(cityCode) ? cityCode : @"855120000", // 默认用金边
            }];
            if (HDIsStringNotEmpty(operatorNo)) {
                [params setObject:operatorNo forKey:@"operatorNo"];
            }
            request.requestParameter = params;

            [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
                SACMSPageViewConfig *config = [SACMSPageViewConfig yy_modelWithJSON:response.responseObject[@"data"]];
                if (!HDIsObjectNil(config.contentPageNo)) {
                    HDLog(@"写入缓存，并刷新");
#ifdef DEBUG
                    [SACacheManager.shared setObject:[SAWriteDateReadableModel modelWithStoreObj:config]
                                              forKey:[NSString stringWithFormat:@"%@_%@_%@", pageIdentify, [SAMultiLanguageManager currentLanguage], HDIsStringNotEmpty(cityCode) ? cityCode : @"855120000"]
                                            duration:60 * 3
                                                type:SACacheTypeDocumentPublic];
#else
                    [SACacheManager.shared setObject:[SAWriteDateReadableModel modelWithStoreObj:config]
                                              forKey:[NSString stringWithFormat:@"%@_%@_%@", pageIdentify, [SAMultiLanguageManager currentLanguage], HDIsStringNotEmpty(cityCode) ? cityCode : @"855120000"]
                                            duration:60 * 60 * 72
                                                type:SACacheTypeDocumentPublic];
#endif
                    
                    if([config isEqual:cacheCfg] && hasCallBack) {
                        HDLog(@"数据一样，且已经回调，无需再回调");
                        return;
                    }
                    
                    config.identify = pageIdentify;
                    config.addressModel = addressModel;

                    [self sortConfig:config success:^() {
                        SACMSPageView *pageView = [[SACMSPageView alloc] initWithWidth:pageWidth config:config];
                        !success ?: success(pageView, config);
                    }];
                } else {
                    // 数据异常
                    !failure ?: failure(nil, CMResponseErrorTypeBusinessDataError, nil);
                }
            } failure:^(HDNetworkResponse *_Nonnull response) {
                !failure ?: failure(response.extraData, response.errorType, response.error);
            }];
        });
    };

    NSString *pageIdentify = identify;
    NSString *pageMappingStr = [SAAppSwitchManager.shared switchForKey:SAAppSwitchCMSPageMapping];
    NSDictionary *pageMapping = [NSJSONSerialization JSONObjectWithData:[pageMappingStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if (pageMapping && pageMapping.allKeys.count > 0) {
        NSString *realPageName = [pageMapping valueForKey:identify];
        if (HDIsStringNotEmpty(realPageName)) {
            pageIdentify = realPageName;
        }
    }

    if (HDIsObjectNil(addressModel)) {
        startCMSRequest(@"", pageIdentify);
        return;
    }

    if (HDIsStringNotEmpty(addressModel.districtCode)) {
        startCMSRequest(addressModel.districtCode, pageIdentify);
        return;
    }

    // 获取城市编码
    SACMSManager *manager = SACMSManager.sharedInstance;
    [manager.chooseZoneDTO fuzzyQueryZoneListWithoutDefaultWithProvince:addressModel.city district:addressModel.subLocality commune:nil latitude:addressModel.lat longitude:addressModel.lon
        success:^(SAAddressZoneModel *_Nonnull zoneModel) {
            addressModel.provinceCode = zoneModel.parent;
            addressModel.districtCode = zoneModel.code;
            startCMSRequest(zoneModel.code, pageIdentify);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            // 失败了直接用默认数据请求，不需要抛出异常
            startCMSRequest(@"", pageIdentify);
        }];
}

+ (void)registerCMSCardTemplateWithClass:(Class)cardClass identify:(NSString *)identify {
    //
}

#pragma mark - private methods
// 对卡片节点进行排序
+ (void)sortConfig:(SACMSPageViewConfig *)config success:(void (^)(void))success {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        config.cards = [config.cards sortedArrayUsingComparator:^NSComparisonResult(SACMSCardViewConfig *_Nonnull obj1, SACMSCardViewConfig *_Nonnull obj2) {
            return obj1.location > obj2.location;
        }];
        for (SACMSCardViewConfig *cardConfig in config.cards) {
            cardConfig.nodes = [cardConfig.nodes sortedArrayUsingComparator:^NSComparisonResult(SACMSNode *_Nonnull obj1, SACMSNode *_Nonnull obj2) {
                return obj1.location > obj2.location;
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            success();
        });
    });
}

- (SAChooseZoneDTO *)chooseZoneDTO {
    if (!_chooseZoneDTO) {
        _chooseZoneDTO = SAChooseZoneDTO.new;
    }
    return _chooseZoneDTO;
}

@end
