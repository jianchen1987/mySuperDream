//
//  WMStoreSearchViewController.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreSearchViewController : SALoginlessViewController <WMViewControllerProtocol>
/// 搜索关键词
@property (nonatomic, copy) NSString *keyWord;
@end

NS_ASSUME_NONNULL_END
