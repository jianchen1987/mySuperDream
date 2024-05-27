//
//  SAAggregateSearchViewModel.h
//  SuperApp
//
//  Created by seeu on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"
#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAAddressModel;
@class SAAggregateSearchResultRspModel;


@interface SAAggregateSearchViewModel : SAViewModel

- (void)searchWithKeyWord:(NSString *_Nonnull)keyWord
             businessLine:(SAClientType)business
                  address:(SAAddressModel *)address
                  pageNum:(NSUInteger)pageNum
                 pageSize:(NSUInteger)pageSize
                  success:(void (^)(SAAggregateSearchResultRspModel *rspModel))successBlock
                  failure:(CMNetworkFailureBlock)failureBlock;

@end


@interface SAAggregateSearchResultRspModel : SACommonPagingRspModel

///< list
@property (nonatomic, strong) NSArray *list;

@end

NS_ASSUME_NONNULL_END
