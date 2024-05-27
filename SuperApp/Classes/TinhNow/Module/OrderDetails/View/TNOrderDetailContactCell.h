//
//  TNOrderDetailContactCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/9/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderDetailContactCellModel : NSObject
/// 店铺id
@property (nonatomic, copy) NSString *storeNo;
@end


@interface TNOrderDetailContactCell : SATableViewCell

@property (strong, nonatomic) TNOrderDetailContactCellModel *model;
/// 点击商家客服的回调
@property (nonatomic, copy) void (^customerServiceButtonClickedHander)(NSString *storeNo);
/// 点击联系电话的回调
@property (nonatomic, copy) void (^phoneButtonClickedHander)(void);
@end

NS_ASSUME_NONNULL_END
