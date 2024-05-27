//
//  PNStepItemView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/1/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNStepItemModel : PNModel
@property (nonatomic, strong) NSString *numStr;
@property (nonatomic, strong) NSString *tipsStr;
@property (nonatomic, assign) BOOL isHighlight;
@end


@interface PNStepItemView : PNView
@property (nonatomic, strong) PNStepItemModel *model;
@end

NS_ASSUME_NONNULL_END
