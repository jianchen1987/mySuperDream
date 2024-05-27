//
//  TNOrderOperatorModel.h
//  SuperApp
//
//  Created by seeu on 2020/8/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderOperatorModel : TNModel
/// 操作
@property (nonatomic, copy) NSString *orderOperation;
@end

NS_ASSUME_NONNULL_END
