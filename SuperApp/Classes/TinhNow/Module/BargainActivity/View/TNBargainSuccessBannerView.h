//
//  TNBargainSuccessBannerView.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"
#import "TNBargainSuccessModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainSuccessBannerView : TNView
@property (strong, nonatomic) TNBargainSuccessModel *model;
- (void)setBackgroundColorAlpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
