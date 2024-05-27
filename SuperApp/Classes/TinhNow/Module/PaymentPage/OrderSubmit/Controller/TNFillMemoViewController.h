//
//  TNFillMemoViewController.h
//  SuperApp
//
//  Created by seeu on 2020/8/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TNFillMemoProtocol <NSObject>
@optional
- (void)memoDidChanged:(NSString *)memo;
@end


@interface TNFillMemoViewController : TNViewController
///  delegate
@property (nonatomic, weak) id<TNFillMemoProtocol> delegate;
/// memo
@property (nonatomic, copy) NSString *memo;
@end

NS_ASSUME_NONNULL_END
