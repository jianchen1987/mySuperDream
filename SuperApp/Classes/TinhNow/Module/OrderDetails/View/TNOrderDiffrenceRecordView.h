//
//  TNOrderDiffrenceRecordView.h
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderDetailsBizPartModel.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNOrderDiffrenceRecordView : TNView <HDCustomViewActionViewProtocol>
@property (nonatomic, strong) TNOrderDetailsBizPartModel *model;
/// 点击了关闭
@property (nonatomic, copy) void (^closeClickedCallBack)(void);
@end

NS_ASSUME_NONNULL_END
