//
//  PNMSStoreOperatorRoleView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SelectBlock)(PNMSRoleType roleType);


@interface PNMSStoreOperatorRoleView : PNView
@property (nonatomic, copy) SelectBlock selectBlock;

@property (nonatomic, assign) PNMSRoleType role;

/// 是否需要显示店员
@property (nonatomic, strong) NSArray<NSNumber *> *showDataArray;

@end

NS_ASSUME_NONNULL_END
