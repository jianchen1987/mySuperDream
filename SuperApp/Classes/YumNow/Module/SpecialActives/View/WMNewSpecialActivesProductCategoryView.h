//
//  WMNewSpecialActivesProductCategoryView.h
//  SuperApp
//
//  Created by Tia on 2023/7/31.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMSpecialPromotionRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMNewSpecialActivesProductCategoryView : SAView
/// 是否展开
@property (nonatomic, assign) BOOL showing;

@property (nonatomic, strong) NSArray<WMSpecialPromotionCategoryModel *> *categoryList;

@property (nonatomic, copy) dispatch_block_t dismissBlock;

@property (nonatomic, copy) void (^selectedBlock)(WMSpecialPromotionCategoryModel *m);

- (instancetype)initWithStartOffsetY:(CGFloat)offset;
- (void)showInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
