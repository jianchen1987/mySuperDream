//
//  TNGoodsTagModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/11/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNCodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNGoodsTagModel : TNCodingModel
/// 标签名字
@property (nonatomic, copy) NSString *tagName;
/// 标签id
@property (nonatomic, copy) NSString *tagId;
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;
/// 标签宽高
@property (nonatomic, assign) CGSize itemSize;
@end

NS_ASSUME_NONNULL_END
