//
//  SAMessageCenterListTableViewHeaderView.h
//  SuperApp
//
//  Created by seeu on 2021/8/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAMessageCenterListTableViewHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *text; ///< 文本
@property (nonatomic, copy) void (^viewClickedHandler)(void);

+ (instancetype)headerWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
