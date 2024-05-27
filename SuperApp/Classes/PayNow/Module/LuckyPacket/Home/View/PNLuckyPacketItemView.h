//
//  PNLuckyPacketItemView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^BtnClickBlock)(void);


@interface PNLuckyPacketItemModel : PNModel
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, strong) UIColor *bgColor;
@end


@interface PNLuckyPacketItemView : PNView
@property (nonatomic, strong) PNLuckyPacketItemModel *model;

@property (nonatomic, copy) BtnClickBlock btnClickBlock;
@end

NS_ASSUME_NONNULL_END
