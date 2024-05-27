//
//  TNProductNavTitleModel.h
//  SuperApp
//
//  Created by xixi on 2021/2/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductNavTitleModel : TNModel
/// title
@property (nonatomic, strong) NSString *title;
/// 关联的section
@property (nonatomic, assign) NSInteger section;

/// 关联的section 是否有header  有显示yes   没有no
@property (nonatomic, assign) BOOL isSectionHeader;
@end

NS_ASSUME_NONNULL_END
