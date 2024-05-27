//
//  TNSearchRankCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/10/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"
#import "TNSearchRankAndDiscoveryModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ClickItemBlock)(NSString *itemStr);


@interface TNSearchRankCell : TNCollectionViewCell

@property (nonatomic, strong) NSArray<TNSearchRankAndDiscoveryItemModel *> *dataArray;

@property (nonatomic, copy) ClickItemBlock clickItemBlock;

@end

NS_ASSUME_NONNULL_END
