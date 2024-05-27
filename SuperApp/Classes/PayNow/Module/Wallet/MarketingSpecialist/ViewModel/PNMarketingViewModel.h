//
//  PNMarketingViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMarketingViewModel : PNViewModel
@property (nonatomic, assign) BOOL refreshFlag;
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, copy) NSString *accountPhoneNumber;
@property (nonatomic, copy) NSString *accountName;

@property (nonatomic, copy) NSString *promoterLoginName;

- (void)getCoolCashAccountName;

- (void)bindMarketing;
@end

NS_ASSUME_NONNULL_END
