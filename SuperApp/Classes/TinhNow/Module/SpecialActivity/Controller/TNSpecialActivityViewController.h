//
//  TNSpecialActivityViewController.h
//  SuperApp
//
//  Created by luyan on 2020/9/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNViewController.h"

NS_ASSUME_NONNULL_BEGIN
///专题类型
typedef NS_ENUM(NSUInteger, TNSpecialActivityType) {
    //普通专题
    TNSpecialActivityTypeDefault = 0,
    //红区专题
    TNSpecialActivityTypeRedZone = 1,
};


@interface TNSpecialActivityViewController : TNLoginlessViewController

@end

NS_ASSUME_NONNULL_END
