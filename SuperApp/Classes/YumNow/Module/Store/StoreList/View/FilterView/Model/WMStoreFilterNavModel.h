//
//  WMStoreFilterNavModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMStoreFilterTableViewCellModel.h"

typedef NSString *WMStoreFilterNavType NS_STRING_ENUM;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT WMStoreFilterNavType const WMStoreFilterNavTypeSortType;
FOUNDATION_EXPORT WMStoreFilterNavType const WMStoreFilterNavTypeCategory;


@interface WMStoreFilterNavModel : WMModel
@property (nonatomic, copy) WMStoreFilterNavType type; ///< 类型
@property (nonatomic, copy) NSString *title;           ///< 名称
@property (nonatomic, strong) UIImage *image;          ///< 图片
/// 列表数据
@property (nonatomic, copy) NSArray<WMStoreFilterTableViewCellModel *> *dataSource;

+ (instancetype)merchantFilterNavModelWithType:(WMStoreFilterNavType)type title:(NSString *__nullable)title image:(UIImage *)image;
- (instancetype)initWithType:(WMStoreFilterNavType)type title:(NSString *)title image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
