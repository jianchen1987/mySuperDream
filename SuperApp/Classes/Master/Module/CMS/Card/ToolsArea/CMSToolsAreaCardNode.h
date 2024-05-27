//
//  CMSToolsAreaCardNode.h
//  SuperApp
//
//  Created by Chaos on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN
@class CMSToolsAreaItemConfig;


@interface CMSToolsAreaCardNode : SAView

@property (nonatomic, copy) void (^clickHandler)(CMSToolsAreaItemConfig *model);
@property (nonatomic, strong) CMSToolsAreaItemConfig *model;

@end

NS_ASSUME_NONNULL_END
