//
//  SAViewProtocol.h
//  SuperApp
//
//  Created by VanJay on 2020/3/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewModelProtocol.h"
#import <Foundation/Foundation.h>

@protocol SAViewProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel;

- (void)hd_bindViewModel;
- (void)hd_setupViews;
- (void)hd_clickedViewHandler;

@end
