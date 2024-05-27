//
//  TNSearchFindSubItemView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/10/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSearchRankAndDiscoveryModel.h"
#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^BtnClickBlock)(TNSearchRankAndDiscoveryItemModel *model);


@interface TNSearchFindSubItemView : TNView
@property (nonatomic, strong) TNSearchRankAndDiscoveryItemModel *model;

@property (nonatomic, copy) BtnClickBlock btnClickBlock;
- (CGSize)getSizeFits;
@end

NS_ASSUME_NONNULL_END
