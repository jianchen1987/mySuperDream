//
//  PNBindMarketingItemView.h
//  SuperApp
//
//  Created by xixi_wen on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNView.h"

@class PNMarketingListItemModel;


typedef NS_ENUM(NSInteger, PNBindMarketingItemViewType) {
    PNBindMarketingItemView_Title = 0,   ///<- 标题
    PNBindMarketingItemView_Content = 1, ///<- 列表内容
};


NS_ASSUME_NONNULL_BEGIN


@interface PNBindMarketingItemView : PNView

- (instancetype)initWithType:(PNBindMarketingItemViewType)type;

@property (nonatomic, strong) PNMarketingListItemModel *model;
@end

NS_ASSUME_NONNULL_END
