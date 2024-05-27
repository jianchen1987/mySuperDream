//
//  SACouponFilterView.h
//  SuperApp
//
//  Created by seeu on 2021/8/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACouponFilterViewConfig : SACodingModel

@property (nonatomic, strong) SAInternationalizationModel *name; ///<
@property (nonatomic, strong) id value;                          ///< 关联的值

@end


@interface SACouponFilterView : SAView
@property (nonatomic, strong) NSArray<SACouponFilterViewConfig *> *configs;             ///<
@property (nonatomic, copy) void (^clickOnFilterItemBlock)(SACouponFilterViewConfig *); ///< 点击选项回调
@property (nonatomic, assign) NSInteger selectedIndex;                                  ///< 当前选中的序号
@property (nonatomic, copy) dispatch_block_t filterBlock;                               ///<点击筛选

@property (nonatomic) BOOL isHiddenFilterBtn;

@end

NS_ASSUME_NONNULL_END
