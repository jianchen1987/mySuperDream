//
//  TNRefundDetailsViewModel.h
//  SuperApp
//
//  Created by xixi on 2021/1/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNRefundDetailsViewModel : TNViewModel

/// 刷新标记
@property (nonatomic, assign) BOOL refreshFlag;
/// 申请退款页面
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;


- (void)getData:(NSString *)orderNo;
@end

NS_ASSUME_NONNULL_END
