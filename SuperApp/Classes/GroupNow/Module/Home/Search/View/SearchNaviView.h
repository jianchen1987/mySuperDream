//
//  SearchNaviView.h
//  SuperApp
//
//  Created by wmz on 2021/9/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SearchNaviView : GNView
/// 搜索框
@property (nonatomic, strong) HDSearchBar *searchBar;
/// back
@property (nonatomic, strong) HDUIButton *backBTN;
/// 搜索
@property (nonatomic, strong) HDUIButton *locationBTN;

@end

NS_ASSUME_NONNULL_END
