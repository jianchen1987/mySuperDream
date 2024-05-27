//
//  TNWithdrawViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNViewModel.h"
#import "TNWithdrawModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNWithdrawDetailViewModel : TNViewModel
@property (nonatomic, copy) NSString *objId; ///<业务id
@property (strong, nonatomic) TNWithdrawModel *model;
@property (strong, nonatomic) NSMutableArray *dataArr;                ///<
@property (nonatomic, assign) BOOL refreshFlag;                       ///< 刷新标记
@property (nonatomic, copy) void (^withDrawDetailGetDataFaild)(void); ///<  收益详情获取数据失败回调
- (void)getDetailData;
@end

NS_ASSUME_NONNULL_END
