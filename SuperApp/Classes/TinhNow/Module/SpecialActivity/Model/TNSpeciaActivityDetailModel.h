//
//  TNSpeciaActivityDetailModel.h
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"
typedef NS_ENUM(NSInteger, TNSpecialStyleType) {
    //横向样式1
    TNSpecialStyleTypeHorizontal = 1,
    //垂直样式2
    TNSpecialStyleTypeVertical = 2,
};
typedef NS_ENUM(NSInteger, TNSpeciaActivityBusinessLine) {
    ///海外购专题
    TNSpeciaActivityBusinessLineOverseas = 0,
    ///快消品专题
    TNSpeciaActivityBusinessLineFastConsume = 1
};

typedef NS_ENUM(NSInteger, TNSpeciaActivityShowGrade) {
    ///一级分类
    TNSpeciaActivityShowGradeOne = 0,
    ///二级分类
    TNSpeciaActivityShowGradeTwo = 1,
    ///三级分类
    TNSpeciaActivityShowGradeThree = 2,
};

NS_ASSUME_NONNULL_BEGIN


@interface TNSpeciaActivityAdModel : TNModel
/// 广告id
@property (nonatomic, copy) NSString *adId;
/// 广告图片
@property (nonatomic, copy) NSString *adv;
/// 跳转链接
@property (nonatomic, copy) NSString *appLink;
@end


@interface TNSpeciaActivityDetailModel : TNModel
/// 专题id
@property (nonatomic, copy) NSString *activityId;
/// 活动规则内容
@property (nonatomic, copy) NSString *content;
/// 商品专题名称
@property (nonatomic, copy) NSString *name;
/// 商品专题活动图
@property (nonatomic, strong) NSArray<NSString *> *advList;
/// 分享字段
@property (nonatomic, copy) NSString *shareUrl;
/// 专题图片数组  带点击参数
@property (strong, nonatomic) NSArray<TNSpeciaActivityAdModel *> *productSpecialAdvs;
/// 是否打开加购按钮
@property (nonatomic, assign) BOOL isQuicklyAddToCart;
/// 店铺id
@property (nonatomic, copy) NSString *storeId;
/// businessLine = 0 海外购专题   businessLine = 1 快消品专题
@property (nonatomic, assign) TNSpeciaActivityBusinessLine businessLine;
/// 专题展示样式（1：样式1, 2：样式2）
@property (nonatomic, assign) TNSpecialStyleType styleType;
/// 展示几级分类
@property (nonatomic, assign) TNSpeciaActivityShowGrade showGrade;
@end

NS_ASSUME_NONNULL_END
