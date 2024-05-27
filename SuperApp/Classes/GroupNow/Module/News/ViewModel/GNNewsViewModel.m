//
//  GNNewsViewModel.m
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNNewsViewModel.h"


@interface GNNewsViewModel ()

@end


@implementation GNNewsViewModel

/// 消息列表
- (void)getNewsListPageNum:(NSInteger)pageNum completion:(nullable void (^)(GNNewsPagingRspModel *rspModel, BOOL error))completion {
    [self.newsDTO getMessageListWithPage:pageNum success:^(GNNewsPagingRspModel *_Nonnull rspModel) {
        NSMutableArray *list = NSMutableArray.new;
        for (GNNewsCellModel *newModel in rspModel.list) {
            GNCellModel *model = [GNCellModel createClass:@"GNNewsTableViewCell"];
            model.businessData = newModel;
            [list addObject:model];
        }
        if (pageNum > 1) {
            [self.dataSource addObjectsFromArray:list];
        } else {
            self.dataSource = [NSMutableArray arrayWithArray:list];
        }
        !completion ?: completion(rspModel, NO);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(nil, YES);
    }];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (GNNewsDTO *)newsDTO {
    if (!_newsDTO) {
        _newsDTO = GNNewsDTO.new;
    }
    return _newsDTO;
}

@end
