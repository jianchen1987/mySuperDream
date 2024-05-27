//
//  CMSMainEntranceCardViewCell.h
//  SuperApp
//
//  Created by seeu on 2022/4/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

@class CMSMainEntranceCardViewCellModel;


@interface CMSMainEntranceCardViewCell : SACollectionViewCell
///< moel
@property (nonatomic, strong) CMSMainEntranceCardViewCellModel *model;
@end


@interface CMSMainEntranceCardViewCellModel : SAModel
///< 图片 地址
@property (nonatomic, copy) NSString *imageUrl;
///< 跳转地址
@property (nonatomic, copy) NSString *link;
///< 大小
@property (nonatomic, assign) CGSize cellSize;
@end

NS_ASSUME_NONNULL_END
