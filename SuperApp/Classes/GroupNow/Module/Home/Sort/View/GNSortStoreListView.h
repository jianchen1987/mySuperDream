//
//  GNSortStoreListView.h
//  SuperApp
//
//  Created by wmz on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNHomeStoreListView.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNSortStoreListView : GNHomeStoreListView
/// 分类code
@property (nonatomic, copy) NSString *classificationCode;
/// 一级code
@property (nonatomic, copy) NSString *parentCode;
@end

NS_ASSUME_NONNULL_END
