//
//  TNProductSepcPropertieModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, TNSpecPropertyStatus) {
    TNSpecPropertyStatusNormal = 0,   //可选状态
    TNSpecPropertyStatusSelected = 1, //已经选中
    TNSpecPropertyStatusdisEnble = 2, //已经卖完 不能选择
};


@interface TNProductSpecPropertieModel : TNModel
/// 属性id
@property (nonatomic, copy) NSString *propId;
/// 属性名
@property (nonatomic, copy) NSString *propName;
/// 属性值
@property (nonatomic, copy) NSString *propValue;

/// 批发规格弹窗使用自定义字段
///  规格宽高
@property (nonatomic, assign) CGSize nameSize;

///绑定属性  是否是默认选中规格  由后台返回绑定 此值必须有库存才为true
@property (nonatomic, assign) BOOL isDefault;
///状态 是否可卖
@property (nonatomic, assign) TNSpecPropertyStatus status;
//规格宽度
@property (nonatomic, assign) CGFloat nameWidth;

///绑定属性  是否选中了这个规格  isSelected  和后端重复了
@property (nonatomic, assign) BOOL isUserSelected;
/// 选中的sku数量
@property (nonatomic, assign) NSInteger selectedSkuCount;
/// 绑定属性 数组中有一个显示了sku数量的  所有的cell都要空出位置
@property (nonatomic, assign) BOOL isNeedCountSpace;
/// 选中数量宽度
@property (nonatomic, assign) CGFloat selectedSkuCountLableWidth;
@end

NS_ASSUME_NONNULL_END
