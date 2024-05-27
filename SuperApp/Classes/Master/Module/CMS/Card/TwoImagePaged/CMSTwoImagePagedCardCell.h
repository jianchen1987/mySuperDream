//
//  CMSTwoImageScrolledCardCell.h
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class CMSTwoImagePagedCardCellConfig;
@class SACMSNode;


@interface CMSTwoImagePagedCardCell : SACollectionViewCell
/// 配置
@property (nonatomic, strong) CMSTwoImagePagedCardCellConfig *config;

@property (nonatomic, copy) void (^clickedBlock)(SACMSNode *node, NSString *link);

@end

NS_ASSUME_NONNULL_END
