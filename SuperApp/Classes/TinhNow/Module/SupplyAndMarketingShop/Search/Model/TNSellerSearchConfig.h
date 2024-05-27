//
//  TNSellerSearchConfig.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerSearchViewModel.h"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNSellerSearchConfig : NSObject
@property (nonatomic, copy) NSString *title;                 ///< 标题
@property (assign, nonatomic) TNSellerSearchResultType type; ///<类型
/// 是否需要更新数据
@property (nonatomic, assign) BOOL isNeedRefresh;
+ (instancetype)configWithTitle:(NSString *)title resultType:(TNSellerSearchResultType)resultType;
@end

NS_ASSUME_NONNULL_END
