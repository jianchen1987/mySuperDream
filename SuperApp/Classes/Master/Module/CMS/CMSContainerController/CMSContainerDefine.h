//
//  CMSContainerDefine.h
//  SuperApp
//
//  Created by seeu on 2022/4/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#ifndef CMSContainerDefine_h
#define CMSContainerDefine_h
#import <Foundation/Foundation.h>

/// CMS容器自定义区域
typedef NSString *CMSContainerCustomSection NS_STRING_ENUM;
FOUNDATION_EXPORT CMSContainerCustomSection const CMSContainerCustomSectionTop;    ///< 顶部自定义section, 所有卡片之前
FOUNDATION_EXPORT CMSContainerCustomSection const CMSContainerCustomSectionBottom; ///< 底部自定义section，卡片之后，瀑布流之前
FOUNDATION_EXPORT CMSContainerCustomSection const CMSContainerCustomSectionCard;   ///< CMS卡组secion
#endif                                                                             
