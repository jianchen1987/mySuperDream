//
//  WMCategoryItem.h
//  SuperApp
//
//  Created by VanJay on 2020/4/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMCategoryItem : WMModel
@property (nonatomic, copy) NSString *scopeCode;                           ///< 品类 code
@property (nonatomic, copy) NSString *imagesUrl;                           /// imageURL
@property (nonatomic, strong) SAInternationalizationModel *message;        ///< 国际化名称对象
@property (nonatomic, copy) NSArray<WMCategoryItem *> *subClassifications; /// 二级经营范围

/// custom
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, assign) BOOL all;
@property (nonatomic, assign, getter=isLocalImage) BOOL localImage;
/// 级别
@property (nonatomic, assign) NSInteger level;
/// 父类品类code
@property (nonatomic, copy) NSString *parentScopeCode;

@end

NS_ASSUME_NONNULL_END
