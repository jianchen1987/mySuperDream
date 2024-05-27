//
//  PNInterTransferBaseViewController.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTableView.h"
#import "PNTransferStepView.h"
#import "PNViewController.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferBaseViewController : PNViewController <UITableViewDelegate, UITableViewDataSource>
/// 步骤视图
@property (strong, nonatomic) PNTransferStepView *stepView;
/// 列表视图
@property (strong, nonatomic) PNTableView *tableView;
/// 操作按钮
@property (strong, nonatomic) PNOperationButton *oprateBtn;
@end

NS_ASSUME_NONNULL_END
