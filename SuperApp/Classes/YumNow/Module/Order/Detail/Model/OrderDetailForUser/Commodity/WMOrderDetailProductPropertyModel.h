//
//  WMOrderDetailProductPropertyModel.h
//  SuperApp
//
//  Created by VanJay on 2020/7/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailProductPropertyModel : WMModel
/// 属性id
@property (nonatomic, copy) NSString *propertyId;
/// 属性项id
@property (nonatomic, copy) NSString *propertySelectionId;
/// 属性名称
@property (nonatomic, copy) NSString *propertyName;
/// 属性项名称
@property (nonatomic, copy) NSString *propertySelectionName;
@end

NS_ASSUME_NONNULL_END
