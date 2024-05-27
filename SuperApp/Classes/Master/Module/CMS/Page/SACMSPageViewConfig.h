//
//  SACMSPageViewConfig.h
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSDefine.h"
#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SACMSCardViewConfig;
@class SACMSPluginViewConfig;
@class SAAddressModel;


@interface SACMSPageViewConfig : SACodingModel

@property (nonatomic, copy) CMSPageIdentify identify;                    ///< 页面标识
@property (nonatomic, strong) SAAddressModel *addressModel;              ///< 对应的地址数据
@property (nonatomic, copy, readonly) NSString *pageNo;                 ///< 页面编号
@property (nonatomic, copy, readonly) NSString *contentPageNo;                  ///< 页面编号
@property (nonatomic, copy, readonly) NSString *pageName;                ///< 页面名称
@property (nonatomic, copy, readonly) NSString *businessLine;            ///< 业务线
@property (nonatomic, strong) NSArray<SACMSCardViewConfig *> *cards;     ///< 卡片
@property (nonatomic, strong) NSArray<SACMSPluginViewConfig *> *plugins; ///< 插件
///< 页面模板类型
@property (nonatomic, assign) NSUInteger pageTemplateType;
///< 页面内容
@property (nonatomic, copy) NSString *pageTemplate;

- (NSDictionary *)getPageTemplateContent;

- (NSString *)getBackgroundImage;
- (UIColor *)getBackgroundColor;
- (UIEdgeInsets)getContentEdgeInsets;

@end

NS_ASSUME_NONNULL_END
