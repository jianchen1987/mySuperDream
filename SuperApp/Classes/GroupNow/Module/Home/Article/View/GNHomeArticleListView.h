//
//  GNHomeArticleListView.h
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNEnum.h"
#import "GNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNHomeArticleListView : GNView
/// columnCode
@property (nonatomic, copy) NSString *columnCode;
/// classCode
@property (nonatomic, strong) GNHomeColumnType columnType;
/// 可以更新了
@property (nonatomic, assign) BOOL updateMenuList;

@end

NS_ASSUME_NONNULL_END
