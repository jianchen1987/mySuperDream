//
//  SAChatMessageViewController.h
//  SuperApp
//
//  Created by seeu on 2021/7/27.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAChatMessageViewController : SAViewController <HDCategoryListContentViewDelegate>
/// 业务线
@property (nonatomic, copy) SAClientType clientType;

@end

NS_ASSUME_NONNULL_END
