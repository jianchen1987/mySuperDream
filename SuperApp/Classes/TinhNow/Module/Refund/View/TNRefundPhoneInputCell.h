//
//  TNRefundPhoneInputCell.h
//  SuperApp
//
//  Created by xixi on 2021/1/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

@class TNApplyRefundModel;

NS_ASSUME_NONNULL_BEGIN


@interface TNRefundPhoneInputCellModel : NSObject

@end


@interface TNRefundPhoneInputCell : SATableViewCell

///
@property (nonatomic, strong) NSString *userPhone;

///
@property (nonatomic, copy) void (^endEidtHandler)(NSString *inputPhone);

@end

NS_ASSUME_NONNULL_END
