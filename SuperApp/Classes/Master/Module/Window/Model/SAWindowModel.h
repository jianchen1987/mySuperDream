//
//  SAWindowModel.h
//  SuperApp
//
//  Created by Chaos on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

typedef NS_ENUM(NSUInteger, SAWindowModelType) {
    SAWindowModelTypeUnKnow = 0,
    SAWindowModelTypeKingKong,
    SAWindowModelTypeBanner,
    SAWindowModelTypeTool,
    SAWindowModelTypeWsNew,
};

@class SAInternationalizationModel, SAWindowItemModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAWindowModel : SAModel
/// 位置
@property (nonatomic, assign) SAWindowLocation location;
/// 类型
@property (nonatomic, assign) NSUInteger advertiseType;
/// 排序
@property (nonatomic, assign) NSUInteger sort;
/// 名称
@property (nonatomic, copy) NSString *advertiseName;
/// 内容
@property (nonatomic, copy) NSArray<SAWindowItemModel *> *bannerList;
/// 更多跳转链接
@property (nonatomic, copy) NSString *moreUrl;

@property (nonatomic, assign) NSUInteger indexForRecord; ///< 埋点用序号

#pragma mark - 绑定属性
/// 新超A首页类型判断
@property (nonatomic, assign, readonly) SAWindowModelType type;

@end

NS_ASSUME_NONNULL_END
