//
//  HDCommonPagingRspModel.h
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDJsonRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDCommonPagingRspModel : HDJsonRspModel
@property (nonatomic, assign) BOOL isFrstPage;      ///< 是否最后一行
@property (nonatomic, assign) BOOL hasNextPage;     ///< 是否还有下一页
@property (nonatomic, assign) BOOL hasPreviousPage; ///< 是否存在上一页
@property (nonatomic, assign) BOOL isLastPage;      ///< 是否最后一页
@property (nonatomic, assign) NSInteger pageSize;   ///< 单页条数
@property (nonatomic, assign) NSInteger prePage;    ///< 上一页页码
@property (nonatomic, assign) NSInteger nextPage;   ///< 下一页页码
@property (nonatomic, assign) NSInteger startRow;   ///< 开始行
@property (nonatomic, assign) NSInteger endRow;     ///< 结束行
@property (nonatomic, assign) NSInteger total;      ///< 总数
@property (nonatomic, assign) NSInteger pageNum;    ///< 当前页
///<

@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) BOOL pn_hasNetPage;
@end

NS_ASSUME_NONNULL_END
