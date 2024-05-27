//
//  TypeView.h
//  SuperApp
//
//  Created by Quin on 2021/11/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "HDGridView.h"
#import "PNTypeModel.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNTypeView : PNView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) HDGridView *gridView;
@end

NS_ASSUME_NONNULL_END
