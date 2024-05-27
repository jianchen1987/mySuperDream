//
//  TNAdressChangeTipsAlertConfig.h
//  SuperApp
//
//  Created by 张杰 on 2021/9/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCheckRegionModel.h"
#import <Foundation/Foundation.h>
@class SAShoppingAddressModel;
typedef NS_ENUM(NSUInteger, TNAdressTipsAlertType) {
    //配送区域
    TNAdressTipsAlertTypeDeliveryArea,
    //显示店铺
    TNAdressTipsAlertTypeChooseStore,
    //详情用  仅展示 销售区域  只能查看
    TNAdressTipsAlertTypeConfirm,
    //选择地址
    TNAdressTipsAlertTypeChooseAdress,
    //推荐展示专题列表  2.22修改  这个类型的弹窗  大改样式  新写了一个TNRedZoneSaleAreaAlertView 弹窗
    TNAdressTipsAlertTypeActivityList,
};
NS_ASSUME_NONNULL_BEGIN


@interface TNAlertAction : NSObject
/// 按钮名字
@property (nonatomic, copy) NSString *title;
/// 按钮颜色
@property (nonatomic, strong) UIColor *textColor;
/// 背景颜色
@property (nonatomic, strong) UIColor *backgroundColor;
/// 按钮字体
@property (nonatomic, strong) UIFont *font;
/// 回调
@property (nonatomic, copy) void (^actionClickCallBack)(TNAlertAction *action);

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(TNAlertAction *action))handler;
@end


@interface TNAdressChangeTipsAlertConfig : NSObject
/// 弹窗显示类型
@property (nonatomic, assign) TNAdressTipsAlertType alertType;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 配送范围文案
@property (nonatomic, copy) NSString *deliveryArea;
/// 店铺位置
@property (nonatomic, copy) NSString *storeLocation;
/// 店铺id
@property (nonatomic, copy) NSString *storeNo;
/// 店铺名称
@property (nonatomic, copy) NSString *storeName;
/// 专题列表数据
@property (strong, nonatomic) NSArray *activityList;
/// 收货地址  查看配送区域的需要传
@property (strong, nonatomic) SAShoppingAddressModel *addressModel;
/// 按钮
@property (strong, nonatomic) NSArray<TNAlertAction *> *actions;
/// 创建config
/// @param model 酒水提示模型
/// @param isJustShow 是否只是展示提示  需要修改地址的话 就是NO
+ (instancetype)configWithCheckModel:(TNRedZoneReginTipsModel *)model isJustShow:(BOOL)isJustShow;
@end

NS_ASSUME_NONNULL_END
