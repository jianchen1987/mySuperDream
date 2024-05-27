//
//  WMProductThemeModel.h
//  SuperApp
//
//  Created by wmz on 2022/3/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMProductThemeModel : WMModel
/// images
@property (nonatomic, copy) NSString *images;
/// name
@property (nonatomic, copy) NSString *name;
/// productId
@property (nonatomic, copy) NSString *productId;
/// originalPrice
@property (nonatomic, strong) NSDecimalNumber *originalPrice;
/// price
@property (nonatomic, strong) NSDecimalNumber *price;
/// logo
@property (nonatomic, copy) NSString *logo;
/// storeNo
@property (nonatomic, copy) NSString *storeNo;

@end

NS_ASSUME_NONNULL_END
