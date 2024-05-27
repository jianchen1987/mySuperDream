//
//  TNBargainAdressView.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"
#import "SAShoppingAddressModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainAdressView : TNView
/// 选择的地址数据
@property (nonatomic, strong) SAShoppingAddressModel *addressModel;
- (CGFloat)getAdressViewHeight;
@end

NS_ASSUME_NONNULL_END
