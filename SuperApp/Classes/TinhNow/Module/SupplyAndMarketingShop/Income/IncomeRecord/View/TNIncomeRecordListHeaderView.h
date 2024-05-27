//
//  TNIncomeRecordListHeaderView.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNIncomeRecordListHeaderView : UITableViewHeaderFooterView
/// 默认展示 1已结算 2预估
@property (nonatomic, assign) NSInteger queryMode;
+ (instancetype)viewWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
