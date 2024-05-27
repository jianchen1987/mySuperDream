//
//  GNArticleViewModel.h
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNArticleDTO.h"
#import "GNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNArticleViewModel : GNViewModel
///详情数据源
@property (nonatomic, strong) NSMutableArray<GNSectionModel *> *detailDataSource;
///获取文章详情
- (void)getAritcleDetailWithCode:(NSString *)code completion:(nullable void (^)(GNArticleModel *rspModel, BOOL error))completion;
@end

NS_ASSUME_NONNULL_END
