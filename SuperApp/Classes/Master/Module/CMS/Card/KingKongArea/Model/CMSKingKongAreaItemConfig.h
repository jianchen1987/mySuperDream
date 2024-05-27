//
//  CMSKingKongAreaItemConfig.h
//  SuperApp
//
//  Created by Chaos on 2021/6/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SACMSDefine.h"

NS_ASSUME_NONNULL_BEGIN

@class SACMSNode;

typedef NS_ENUM(NSUInteger, CMSHomeDynamicShowType) {
    CMSHomeDynamicShowTypeOne = 11, ///< 占两列
    CMSHomeDynamicShowTypeTwo = 10, ///< 占一列
};


@interface CMSKingKongAreaItemConfig : SAModel

@property (nonatomic, copy, readonly) NSString *identifier; ///< 唯一标识
@property (nonatomic, copy) NSString *imageUrl;             ///< 图标url
@property (nonatomic, copy) NSString *title;                ///< 功能名称
@property (nonatomic, copy) NSString *titleColor;
@property (nonatomic, assign) NSUInteger titleFont;
@property (nonatomic, copy) NSString *link;                          ///< 跳转url
@property (nonatomic, assign) CMSAppCornerIconStyle cornerMarkStyle; ///< 角标样式
@property (nonatomic, copy) NSString *cornerMarkText;                ///< 角标文本
@property (nonatomic, assign) NSInteger funcGuideVersion;            ///< 功能引导版本号
@property (nonatomic, copy) NSString *funcGuideDesc;                 ///< 功能引导

@property (nonatomic, assign) BOOL hasUpdated;                   ///< 是否更新了
@property (nonatomic, assign) BOOL hasDisplayedNewFunctionGuide; ///< 是否已经显示过新功能
/// 显示类型
@property (nonatomic, assign) CMSHomeDynamicShowType type;

/// 绑定的Node
@property (nonatomic, strong) SACMSNode *node;

@end

NS_ASSUME_NONNULL_END
