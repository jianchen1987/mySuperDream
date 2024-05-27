//
//  TNSellerSearchResultView.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerSearchViewModel.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNSellerSearchResultView : TNView <HDCategoryListContentViewDelegate>
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel resultType:(TNSellerSearchResultType)resultType;

@end

NS_ASSUME_NONNULL_END
