//
//  GNTopicModel.h
//  SuperApp
//
//  Created by wmz on 2022/2/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNModel.h"
#import "GNStoreCellModel.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNTopicModel : GNModel
///类型
@property (nonatomic, copy) NSString *type;
/// name
@property (nonatomic, strong) SAInternationalizationModel *name;
/// image
@property (nonatomic, strong) SAInternationalizationModel *image;
///门店列表
@property (nonatomic, copy) NSArray<GNStoreCellModel *> *stores;
///商品列表
@property (nonatomic, copy) NSArray<GNProductModel *> *products;

@end

NS_ASSUME_NONNULL_END
