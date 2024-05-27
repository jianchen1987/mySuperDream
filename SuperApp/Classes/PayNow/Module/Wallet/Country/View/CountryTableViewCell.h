//
//  CountryTableViewCell.h
//  customer
//
//  Created by 谢 on 2019/1/9.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface CountryTableViewCell : PNTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, assign) BOOL showTickView; ///< 隐藏打勾 View
@end

NS_ASSUME_NONNULL_END
