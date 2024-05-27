//
//  SACommonPagingRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACommonPagingRspModel : SARspModel
/// 是否还有下一页
@property (nonatomic, assign) BOOL isFrstPage;
/// 是否还有下一页
@property (nonatomic, assign) BOOL hasNextPage;
/// 是否存在上一页
@property (nonatomic, assign) BOOL hasPreviousPage;
/// 是否最后一页
@property (nonatomic, assign) BOOL isLastPage;
/// 单页条数
@property (nonatomic, assign) NSInteger pageSize;
/// 上一页页码
@property (nonatomic, assign) NSInteger prePage;
/// 下一页页码
@property (nonatomic, assign) NSInteger nextPage;
/// 开始行
@property (nonatomic, assign) NSInteger startRow;
/// 结束行
@property (nonatomic, assign) NSInteger endRow;
/// 总数
@property (nonatomic, assign) NSInteger total;
/// 当前页
@property (nonatomic, assign) NSInteger pageNum;
/// 总页数
@property (nonatomic, assign) NSUInteger pages;
/// 页码
@property (nonatomic, copy) NSArray<NSNumber *> *navigatepageNums;
@end

NS_ASSUME_NONNULL_END
