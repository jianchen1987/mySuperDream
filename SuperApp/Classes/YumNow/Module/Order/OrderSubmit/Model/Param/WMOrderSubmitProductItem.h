//
//  WMOrderSubmitProductItem.h
//  SuperApp
//
//  Created by VanJay on 2020/6/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitProductPropertyItem : NSObject
/// 属性选项ID
@property (nonatomic, copy) NSString *propertySelectionId;
/// 属性ID
@property (nonatomic, copy) NSString *propertyId;
@end


@interface WMOrderSubmitProductItem : WMModel
/// 商品 id
@property (nonatomic, copy) NSString *commodityId;
/// 快照 id
@property (nonatomic, copy) NSString *commoditySnapshootId;
/// 规格 id
@property (nonatomic, copy) NSString *commoditySpecificationId;
/// 属性 id 数组
@property (nonatomic, copy) NSArray<WMOrderSubmitProductPropertyItem *> *propertyList;
/// sku 的购买数量
@property (nonatomic, assign) NSUInteger count;
@end

NS_ASSUME_NONNULL_END
