//
//  GNTopicViewModel.h
//  SuperApp
//
//  Created by wmz on 2022/2/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNHomeDTO.h"
#import "GNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNTopicViewModel : GNViewModel
/// rspModel
@property (nonatomic, strong, nullable) GNTopicModel *rspModel;
///获取专题页信息
- (void)getStoreTopicWithTopicCode:(nullable NSString *)topicPageNo pageNum:(NSInteger)pageNum completion:(nullable void (^)(GNTopicModel *rspModel, BOOL error))completion;
@end

NS_ASSUME_NONNULL_END
