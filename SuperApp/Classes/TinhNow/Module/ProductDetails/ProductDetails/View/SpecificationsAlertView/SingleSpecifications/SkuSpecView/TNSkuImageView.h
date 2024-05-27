//
//  TNSkuImageView.h
//  SuperApp
//
//  Created by 张杰 on 2021/7/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNSkuImageView : TNView
/// 展示图
@property (nonatomic, copy) NSString *thumbnail;
/// 预览大图
@property (nonatomic, copy) NSString *largeImageUrl;
@end

NS_ASSUME_NONNULL_END
