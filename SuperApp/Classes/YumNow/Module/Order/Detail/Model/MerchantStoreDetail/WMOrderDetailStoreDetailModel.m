//
//  WMOrderDetailStoreDetailModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailStoreDetailModel.h"


@implementation WMOrderDetailStoreDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"merchantNameEn": @"merchantName", @"storeNameEn": @"storeName", @"announcementEn": @"announceme", @"requiredPriceCent": @"requiredPrice"};
}

#pragma mark - setter
- (void)setMerchantNameEn:(NSString *)merchantNameEn {
    _merchantNameEn = merchantNameEn;
    self.merchantName.en_US = merchantNameEn;
}

- (void)setMerchantNameKm:(NSString *)merchantNameKm {
    _merchantNameKm = merchantNameKm;
    self.merchantName.km_KH = merchantNameKm;
}

- (void)setMerchantNameZh:(NSString *)merchantNameZh {
    _merchantNameZh = merchantNameZh;
    self.merchantName.zh_CN = merchantNameZh;
}

- (void)setStoreNameEn:(NSString *)storeNameEn {
    _storeNameEn = storeNameEn;
    self.storeName.en_US = storeNameEn;
}

- (void)setStoreNameKm:(NSString *)storeNameKm {
    _storeNameKm = storeNameKm;
    self.storeName.km_KH = storeNameKm;
}

- (void)setStoreNameZh:(NSString *)storeNameZh {
    _storeNameZh = storeNameZh;
    self.storeName.zh_CN = storeNameZh;
}

- (void)setAnnouncementEn:(NSString *)announcementEn {
    _announcementEn = announcementEn;
    self.announcement.en_US = announcementEn;
}

- (void)setAnnouncementKm:(NSString *)announcementKm {
    _announcementKm = announcementKm;
    self.announcement.km_KH = announcementKm;
}

- (void)setAnnouncementZh:(NSString *)announcementZh {
    _announcementZh = announcementZh;
    self.announcement.zh_CN = announcementZh;
}

- (void)setRequiredPriceCent:(NSString *)requiredPriceCent {
    _requiredPriceCent = requiredPriceCent;
    self.requiredPrice.cent = [NSString stringWithFormat:@"%f", requiredPriceCent.doubleValue * 100];
}

#pragma mark - lazy load
- (SAInternationalizationModel *)merchantName {
    if (!_merchantName) {
        _merchantName = SAInternationalizationModel.new;
    }
    return _merchantName;
}

- (SAInternationalizationModel *)storeName {
    if (!_storeName) {
        _storeName = SAInternationalizationModel.new;
    }
    return _storeName;
}

- (SAInternationalizationModel *)announcement {
    if (!_announcement) {
        _announcement = SAInternationalizationModel.new;
    }
    return _announcement;
}

- (SAMoneyModel *)requiredPrice {
    if (!_requiredPrice) {
        _requiredPrice = SAMoneyModel.new;
    }
    return _requiredPrice;
}
@end
