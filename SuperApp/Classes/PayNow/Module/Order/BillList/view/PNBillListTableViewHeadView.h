//
//  HDBillListTableViewHeadView.h
//  ViPay
//
//  Created by seeu on 2019/7/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^clickOnBillListTableViewHeader)(UIButton *button);


@interface PNBillListTableViewHeadView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *title;                            ///< 名称
@property (nonatomic, copy) clickOnBillListTableViewHeader clickHandle; ///< 点击回调

+ (instancetype)viewWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
