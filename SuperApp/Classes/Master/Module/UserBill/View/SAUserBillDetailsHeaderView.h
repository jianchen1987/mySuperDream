//
//  SAUserBillDetailsHeaderView.h
//  SuperApp
//
//  Created by seeu on 2022/4/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAUserBillDetailsHeaderView : SAView

- (void)updateWithBusinessLine:(NSString *)businessLine merchantName:(NSString *_Nullable)merName paymentAmount:(NSString *_Nullable)amount;

@end

NS_ASSUME_NONNULL_END
