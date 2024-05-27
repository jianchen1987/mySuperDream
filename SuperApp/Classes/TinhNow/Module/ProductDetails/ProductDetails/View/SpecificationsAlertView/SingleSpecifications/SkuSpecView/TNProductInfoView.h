//
//  TNProductInfoView.h
//  SuperApp
//
//  Created by 张杰 on 2021/7/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductInfoView : TNView
/// 关闭
@property (nonatomic, copy) void (^closeClickCallBack)(void);

/// 更新商品视图数据
/// @param thumbImageUrl sku缩略图片
/// @param largeImageUrl sku预览大图
/// @param price 价格
/// @param stock 库存
/// @param selectedSpec 选中的sku
/// @param weight 重量
- (void)updateProductInfoByThumbImageUrl:(NSString *)thumbImageUrl
                           largeImageUrl:(NSString *)largeImageUrl
                                   price:(NSString *)price
                                   stock:(nullable NSNumber *)stock
                            selectedSpec:(nullable NSString *)selectedSpec
                                  weight:(nullable NSString *)weight;

- (void)updateProductInfoByStock:(nullable NSNumber *)stock selectedSpec:(nullable NSString *)selectedSpec;
@end

NS_ASSUME_NONNULL_END
