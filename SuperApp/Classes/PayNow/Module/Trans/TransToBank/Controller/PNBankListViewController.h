//
//  bankListVC.h
//  ViPay
//
//  Created by Quin on 2021/8/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNBankListViewController : PNViewController
@property (nonatomic, assign) BOOL onlyRead;
@property (nonatomic, copy) NSString *navTitle;
@end

NS_ASSUME_NONNULL_END
