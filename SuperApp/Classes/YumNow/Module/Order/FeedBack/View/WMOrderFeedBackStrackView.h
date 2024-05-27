//
//  WMOrderFeedBackStrackView.h
//  SuperApp
//
//  Created by wmz on 2022/11/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMOrderFeedBackDetailModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderFeedBackStrackView : SAView <HDCustomViewActionViewProtocol>
///数据源
@property (nonatomic, strong) NSArray<WMOrderFeedBackDetailTraclModel *> *dataSource;

@end


@interface WMOrderFeedBackStrackItemView : SAView
/// model
@property (nonatomic, strong) WMOrderFeedBackDetailTraclModel *model;

@end

NS_ASSUME_NONNULL_END
