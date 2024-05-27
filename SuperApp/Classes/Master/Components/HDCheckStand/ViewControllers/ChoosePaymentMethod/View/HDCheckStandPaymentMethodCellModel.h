//
//  HDCheckStandPaymentMethodCellModel.h
//  SuperApp
//
//  Created by VanJay on 2020/9/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HDOnlinePaymentToolsModel;
@class SAWalletBalanceModel;
@class SAMoneyModel;
@class SAPaymentToolModel;
@class HDPaymentMethodType;
@class SAPaymentToolsActivityModel;
@class SAPaymentActivityModel;


@interface HDCheckStandPaymentMethodCellModel : SAModel
/// 图片
@property (nonatomic, strong, nullable) UIImage *image;
/// 图片大小
@property (nonatomic, assign) CGSize imageSize;

/// 文字
@property (nonatomic, copy) NSString *text;
/// 文字
@property (nonatomic, copy) NSAttributedString *attrText;
/// 文字颜色
@property (nonatomic, strong) UIColor *textColor;
/// 文字字体
@property (nonatomic, strong) UIFont *textFont;

/// 选择图片
@property (nonatomic, strong, nullable) UIImage *selectedImage;
///< 没选中图片
@property (nonatomic, strong, nullable) UIImage *unselectedImage;
/// content
@property (nonatomic, strong, nullable) NSString *subTitle;
/// 子content
@property (nonatomic, strong, nullable) NSString *subSubTitle;
/// 文字颜色
@property (nonatomic, strong) UIColor *subTitleColor;
/// 文字字体
@property (nonatomic, strong) UIFont *subTitleFont;
/// 描述图片，优先级高于 subTitle
@property (nonatomic, copy) NSArray<NSString *> *subImageNames;
///< 营销标签
@property (nonatomic, strong) NSArray<NSString *> *marketing;
///< 支付活动
@property (nonatomic, strong) SAPaymentToolsActivityModel *paymentActivitys;
///< 当前选中的支付活动
@property (nonatomic, strong) SAPaymentActivityModel *currentActivity;

///< 是否选中
@property (nonatomic, assign) BOOL isSelected;
/// 是否为上次选择
@property (nonatomic, assign) BOOL isRecentlyUsed;
/// 是否可用
@property (nonatomic, assign) BOOL isUsable;
///< 支付方式
@property (nonatomic, assign) SAOrderPaymentType paymentMethod;
///< 支付工具编码
@property (nonatomic, copy) HDCheckStandPaymentTools toolCode;
/// 关联对象
@property (nonatomic, strong) id associatedObject;
/// 副标题
@property (nonatomic, copy) NSString *subToolName;
/// 副图标路径
@property (nonatomic, copy) NSString *subIcon;
/// 图标路径
@property (nonatomic, copy) NSString *icon;
/// 是否可用，不可用置灰
@property (nonatomic, assign) BOOL isShow;

/// 数据转换
/// @param model 模型
/// @param balanceRspModel 查账户余额结果
/// @param payAmount 支付金额
//+ (HDCheckStandPaymentMethodCellModel *)modelWithPaymentToolModel:(SAPaymentToolModel *)model balance:(SAWalletBalanceModel *)balanceRspModel payAmount:(SAMoneyModel *_Nullable)payAmount;

+ (HDCheckStandPaymentMethodCellModel *)modelWithPaymentMethodModel:(HDPaymentMethodType *)model;

+ (HDCheckStandPaymentMethodCellModel *_Nullable)modelWithPaymentMethodModel:(HDPaymentMethodType *)model
                                                                     balance:(SAWalletBalanceModel *_Nullable)balanceRspModel
                                                                   payAmount:(SAMoneyModel *_Nullable)payAmount;

@end

NS_ASSUME_NONNULL_END
