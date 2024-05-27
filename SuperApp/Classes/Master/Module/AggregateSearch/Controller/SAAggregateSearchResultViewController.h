//
//  SAAggregateSearchResultViewController.h
//  SuperApp
//
//  Created by seeu on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class SAAddressModel;


@interface SAAggregateSearchResultViewController : SALoginlessViewController <HDCategoryListContentViewDelegate>
///< 业务线
@property (nonatomic, copy) SAClientType businessLine;
///< currentlyAddress
@property (nonatomic, strong) SAAddressModel *currentlyAddress;

- (void)getNewDataWithKeyWord:(NSString *_Nullable)keyWord;

@end

NS_ASSUME_NONNULL_END
