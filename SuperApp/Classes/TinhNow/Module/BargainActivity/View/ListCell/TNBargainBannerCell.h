//
//  TNBargainBannerCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/2/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNBargainBannerCellModel : NSObject
/// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
@end


@interface TNBargainBannerCell : TNCollectionViewCell
/// 广告图
@property (nonatomic, copy) NSString *banner;
@end

NS_ASSUME_NONNULL_END
