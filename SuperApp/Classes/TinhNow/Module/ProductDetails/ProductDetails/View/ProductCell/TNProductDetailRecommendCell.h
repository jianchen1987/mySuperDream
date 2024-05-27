//
//  TNProductDetailRecommendCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/8/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductDetailRecommendCellModel : NSObject
///
@property (strong, nonatomic) NSArray *goodsArray;
/// 卖家sp
@property (nonatomic, copy) NSString *sp;
@end


@interface TNProductDetailRecommendCell : SATableViewCell
///
@property (strong, nonatomic) TNProductDetailRecommendCellModel *model;
/// 刷新
@property (nonatomic, copy) void (^reloadSectionCallBack)(void);
@end

NS_ASSUME_NONNULL_END
