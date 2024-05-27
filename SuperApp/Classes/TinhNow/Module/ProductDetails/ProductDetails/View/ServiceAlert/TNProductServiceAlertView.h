//
//  TNProductServiceAlertView.h
//  SuperApp
//
//  Created by seeu on 2020/8/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductServiceModel.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNProductServiceAlertView : HDActionAlertView
- (instancetype)initWithDataArr:(NSArray<TNProductServiceModel *> *)dataArr;
@end

NS_ASSUME_NONNULL_END
