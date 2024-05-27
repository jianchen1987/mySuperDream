//
//  PNMSStepItemModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSStepItemModel : PNModel

@property (nonatomic, strong) UIImage *iconImage;

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;

@property (nonatomic, copy) NSString *subTitleStr;
@property (nonatomic, strong) UIColor *subTitleColor;
@property (nonatomic, strong) UIFont *subTitleFont;
@property (nonatomic, assign) UIEdgeInsets subTitleEdgeInsets;
@end

NS_ASSUME_NONNULL_END
