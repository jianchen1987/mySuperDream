//
//  GNOrderDetailHeadView.h
//  SuperApp
//
//  Created by wmz on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNOrderDetailHeadView : GNView
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// back
@property (nonatomic, strong) HDUIButton *backBTN;
/// 客服
@property (nonatomic, strong) HDUIButton *serverBTN;

@end

NS_ASSUME_NONNULL_END
