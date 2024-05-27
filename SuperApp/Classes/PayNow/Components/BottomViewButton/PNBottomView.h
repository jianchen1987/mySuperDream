//
//  PNBottomView.h
//  SuperApp
//
//  Created by xixi_wen on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^BtnClickBlock)(void);


@interface PNBottomView : PNView
@property (nonatomic, copy) BtnClickBlock btnClickBlock;

- (instancetype)initWithTitle:(NSString *)title;

- (void)setBtnEnable:(BOOL)enable;
@end

NS_ASSUME_NONNULL_END
