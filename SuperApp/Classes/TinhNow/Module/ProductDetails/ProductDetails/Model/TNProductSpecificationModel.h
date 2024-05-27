//
//  TNProductSepcificationModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "TNProductSpecPropertieModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductSpecificationModel : TNModel
/// 规格id
@property (nonatomic, copy) NSString *specId;
/// 规格名称：例如颜色
@property (nonatomic, copy) NSString *specName;
/// 规格值：黑色，红色
@property (nonatomic, strong) NSArray<TNProductSpecPropertieModel *> *specValues;

///绑定属性  是否选中了这个规格
@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
