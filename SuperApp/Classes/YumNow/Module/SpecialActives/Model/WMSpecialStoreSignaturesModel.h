//
//  WMSpecialStoreSignaturesModel.h
//  SuperApp
//
//  Created by wmz on 2021/6/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "SAMoneyModel.h"
#import "SAInternationalizationModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMSpecialStoreSignaturesModel : WMModel
///商品名称
@property (nonatomic, strong) SAInternationalizationModel *nameLanguage;
///商品图片
@property (nonatomic, copy) NSString *imagePath;

@property (nonatomic, assign) NSInteger discountMode;

@property (nonatomic, assign) NSInteger value;
/// code
@property (nonatomic, copy) NSString *code;
/// 售价
@property (nonatomic, strong) SAMoneyModel *salePrice;
/// 折扣价
@property (nonatomic, strong) SAMoneyModel *discountPrice;
/// 商品 id
@property (nonatomic, copy) NSString *productId;

@end

NS_ASSUME_NONNULL_END
