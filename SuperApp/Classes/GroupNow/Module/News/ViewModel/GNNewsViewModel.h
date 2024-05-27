//
//  GNNewsViewModel.h
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNNewsCellModel.h"
#import "GNNewsDTO.h"
#import "GNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNNewsViewModel : GNViewModel

///网络请求
@property (nonatomic, strong) GNNewsDTO *newsDTO;
/// dataSource
@property (nonatomic, strong) NSMutableArray *dataSource;
/// detailModel
@property (nonatomic, strong) GNNewsCellModel *detailCellModel;

/// 消息列表
/// @param pageNum  pageNum
- (void)getNewsListPageNum:(NSInteger)pageNum completion:(nullable void (^)(GNNewsPagingRspModel *rspModel, BOOL error))completion;

@end

NS_ASSUME_NONNULL_END
