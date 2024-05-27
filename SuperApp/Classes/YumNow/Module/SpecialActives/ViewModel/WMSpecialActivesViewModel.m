//
//  WMSpecialActivesViewModel.m
//  SuperApp
//
//  Created by seeu on 2020/8/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMSpecialActivesViewModel.h"
#import "HDWebImageManager.h"
#import "SAAddressModel.h"
#import "SACacheManager.h"
#import "WMSearchStoreRspModel.h"
#import "WMSpecialActivesProductModel.h"
#import "WMSpecialActivesProductRspModel.h"
#import "WMSpecialBrandPagingModel.h"
#import "WMSpecialPromotionRspModel.h"
#import <HDKitCore/HDKitCore.h>
#import <HDLocationManager.h>
#import <HDLocationUtils.h>
#import "SAAddressCacheAdaptor.h"

@interface WMSpecialActivesViewModel () <HDLocationManagerProtocol>
/// DTO
@property (nonatomic, strong) WMCustomizationDTO *cusDTO;

@end


@implementation WMSpecialActivesViewModel

- (void)getNewData {
    @HDWeakify(self);
    [self getSpecialActivesWithPageNo:1 pageSize:10 success:^(WMSpecialPromotionRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if ([rspModel isKindOfClass:WMSpecialPromotionRspModel.class]) {
            self.proModel = rspModel;
            ///预先下载图片
            [SDWebImagePrefetcher.sharedImagePrefetcher prefetchURLs:@[[NSURL URLWithString:rspModel.image ?: @""]] progress:^(NSUInteger noOfFinishedUrls, NSUInteger noOfTotalUrls) {
            } completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
                self.type = rspModel.type;
                self.backgroundImageUrl = rspModel.image;

                if ([WMSpecialActiveTypeStore isEqualToString:rspModel.type]) {
                    /// 门店专题
                    self.showBusiness = rspModel.showBusiness;
                    self.storeList = [NSArray arrayWithArray:rspModel.storesV2.list];
//                    self.storeList = [NSArray arrayWithArray:rspModel.stores.list];
                } else if ([WMSpecialActiveTypeProduct isEqualToString:rspModel.type]) {
                    /// 商品专题
                    self.showCategoryBar = rspModel.showCategoryBar;
                    self.categoryList = [NSArray yy_modelArrayWithClass:WMSpecialPromotionCategoryModel.class json:rspModel.categoryList];
                    self.productList = [NSArray arrayWithArray:rspModel.products.list];
                } else if ([WMSpecialActiveTypeBrand isEqualToString:rspModel.type]) {
                    /// 品牌专题
                    self.brandList = [NSArray arrayWithArray:rspModel.brands.list];
                }
            }];
            self.activeName = rspModel.name;
        } else {
            self.type = @"noData";
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.type = @"error";
    }];
}

///按时吃饭
- (void)getEatOnTimeWithId:(NSString *)ID pageNo:(NSUInteger)pageNo success:(void (^_Nullable)(WMMoreEatOnTimeRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    if (!addressModel) {
        addressModel = SAAddressModel.new;
        addressModel.lat = [NSNumber numberWithDouble:11.568231];
        addressModel.lon = [NSNumber numberWithDouble:104.909059];
    }
    [self.cusDTO queryYumNowEatOnTimeWithId:ID pageNo:pageNo location:CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue)
        success:^(WMMoreEatOnTimeRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            if ([rspModel isKindOfClass:WMMoreEatOnTimeRspModel.class]) {
                if (!self.onTimeModel) {
                    [SDWebImagePrefetcher.sharedImagePrefetcher prefetchURLs:@[[NSURL URLWithString:rspModel.images ?: @""]] progress:^(NSUInteger noOfFinishedUrls, NSUInteger noOfTotalUrls) {
                    } completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
                        self.onTimeModel = rspModel;
                        self.backgroundImageUrl = rspModel.images;
                    }];
                }
            } else {
                self.type = @"noData";
            }
            !successBlock ?: successBlock(rspModel);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            self.type = @"error";
        }];
}

- (void)getSpecialActivesWithPageNo:(NSUInteger)pageNo
                           pageSize:(NSUInteger)pageSize
                            success:(void (^_Nullable)(WMSpecialPromotionRspModel *rspModel))successBlock
                            failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    [self getSpecialActivesWithPageNo:pageNo pageSize:pageSize categoryNo:nil success:successBlock failure:failureBlock];
}

- (void)getSpecialActivesWithPageNo:(NSUInteger)pageNo
                           pageSize:(NSUInteger)pageSize
                         categoryNo:(NSString *)categoryNo
                            success:(void (^_Nullable)(WMSpecialPromotionRspModel *rspModel))successBlock
                            failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    if (!addressModel) {
        // 默认金边
        addressModel = SAAddressModel.new;
        addressModel.lat = [NSNumber numberWithDouble:11.568231];
        addressModel.lon = [NSNumber numberWithDouble:104.909059];
        addressModel.address = @"Choose address";
    }
    [self.cusDTO queryYumNowSpecialPromotionWithPromotionNo:self.activeNo categoryNo:categoryNo pageNo:pageNo pageSize:pageSize
                                                   location:CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue)
                                                    success:^(WMSpecialPromotionRspModel *_Nonnull rspModel) {
                                                        !successBlock ?: successBlock(rspModel);
                                                    }
                                                    failure:failureBlock];
}

- (void)getSpecialActivesWithPageNo:(NSUInteger)pageNo
                           pageSize:(NSUInteger)pageSize
                           sortType:(NSString *)sortType
                     marketingTypes:(NSArray<NSString *> *)marketingTypes
                       storeFeature:(NSArray<NSString *> *)storeFeature
                       businessCode:(NSString *)businessCode
                            success:(void (^_Nullable)(WMSpecialPromotionRspModel *rspModel))successBlock
                            failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    if (!addressModel) {
        // 默认金边
        addressModel = SAAddressModel.new;
        addressModel.lat = [NSNumber numberWithDouble:11.568231];
        addressModel.lon = [NSNumber numberWithDouble:104.909059];
        addressModel.address = @"Choose address";
    }
    
    [self.cusDTO queryYumNowSpecialPromotionWithPromotionNo:self.activeNo categoryNo:nil pageNo:pageNo pageSize:pageSize
                                                   location:CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue) sortType:sortType marketingTypes:marketingTypes storeFeature:storeFeature businessCode:businessCode success:^(WMSpecialPromotionRspModel * _Nonnull rspModel) {
        !successBlock ?: successBlock(rspModel);
    } failure:failureBlock];
}

/** @lazy dto */
- (WMCustomizationDTO *)cusDTO {
    if (!_cusDTO) {
        _cusDTO = [[WMCustomizationDTO alloc] init];
    }
    return _cusDTO;
}

@end
