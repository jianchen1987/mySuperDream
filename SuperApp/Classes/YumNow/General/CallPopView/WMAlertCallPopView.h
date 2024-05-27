//
//  WMAlertCallPopView.h
//  SuperApp
//
//  Created by wmz on 2022/4/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMAlertCallPopModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMAlertCallPopView : SAView <HDCustomViewActionViewProtocol>
///弹出的层等级
@property (nonatomic, assign) NSInteger popLevel;
///携带的数据
@property (nonatomic, copy) NSArray<WMAlertCallPopModel *> *datasource;
///对应event
@property (nonatomic, copy) void (^clickedEventBlock)(WMAlertCallPopModel *model);

@end

NS_ASSUME_NONNULL_END
