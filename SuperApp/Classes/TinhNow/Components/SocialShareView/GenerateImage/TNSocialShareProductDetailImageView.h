//
//  TNSocialShareGenerateImageView.h
//  SuperApp
//
//  Created by 张杰 on 2022/4/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "SASocialShareBaseGenerateImageView.h"
#import "TNShareWebpageObject.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNSocialShareProductDetailModel : NSObject
/// 销售价
@property (nonatomic, strong) SAMoneyModel *price;
/// 市场价
@property (nonatomic, strong) SAMoneyModel *marketPrice;
/// 折扣文本
@property (nonatomic, copy) NSString *showDiscount;
@end


@interface TNSocialShareProductDetailImageView : SASocialShareBaseGenerateImageView
- (instancetype)initWithShareObject:(TNShareWebpageObject *)shareObject;
@end

NS_ASSUME_NONNULL_END
