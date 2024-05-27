//
//  TNRefundCustomerServerCell.h
//  SuperApp
//
//  Created by xixi on 2021/1/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"


NS_ASSUME_NONNULL_BEGIN


@interface TNRefundCustomerServerCellModel : NSObject
/// 商家电话
@property (nonatomic, strong) NSString *customerPhone;
@end


@interface TNRefundCustomerServerCell : SATableViewCell

///
@property (nonatomic, strong) NSString *customerPhone;

/// 点击商家客服的回调
@property (nonatomic, copy) void (^customerServiceButtonClickedHander)(void);
/// 平台客服
@property (nonatomic, copy) void (^platformButtonClickedHander)(void);

@end

NS_ASSUME_NONNULL_END
