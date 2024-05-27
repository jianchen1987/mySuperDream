//
//  WMThemeModel.h
//  SuperApp
//
//  Created by wmz on 2022/3/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMBrandThemeModel.h"
#import "WMMessageCode.h"
#import "WMModel.h"
#import "WMProductThemeModel.h"
#import "WMStoreThemeModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMThemeModel : WMModel
/// name
@property (nonatomic, copy) NSString *title;
/// themeNo
@property (nonatomic, copy) NSString *themeNo;
/// name
@property (nonatomic, copy) NSString *link;
///品牌
@property (nonatomic, copy) NSArray<WMBrandThemeModel *> *brand;
///门店
@property (nonatomic, copy) NSArray<WMStoreThemeModel *> *store;
///商品
@property (nonatomic, copy) NSArray<WMProductThemeModel *> *product;
///类型
@property (nonatomic, strong) WMMessageCode *type;
/// 创建时间
@property (nonatomic, assign) NSInteger createTime;

@end

NS_ASSUME_NONNULL_END
