//
//  TransTypeModel.h
//  SuperApp
//
//  Created by Quin on 2021/11/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNEnum.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface PNTransTypeModel : NSObject
@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *openViewController;
@property (nonatomic, assign) PNTradeSubTradeType type;
@property (nonatomic, copy) NSString *logoPath;

@end

NS_ASSUME_NONNULL_END
