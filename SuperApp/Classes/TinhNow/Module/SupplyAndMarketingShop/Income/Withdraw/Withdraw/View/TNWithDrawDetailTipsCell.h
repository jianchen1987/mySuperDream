//
//  TNWithDrawDetailTipsCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNWithdrawModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNWithDrawDetailTipsCellModel : NSObject
@property (nonatomic, copy) TNWithDrawApplyStatus status;

@property (nonatomic, copy) NSString *memo;
@end


@interface TNWithDrawDetailTipsCell : SATableViewCell
@property (strong, nonatomic) TNWithDrawDetailTipsCellModel *model;
@end

NS_ASSUME_NONNULL_END
