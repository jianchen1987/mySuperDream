//
//  SAMissionCountDownView.h
//  SuperApp
//
//  Created by seeu on 2023/6/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMissionCountDownView : SAView

- (instancetype)initWithSeconds:(NSInteger)seconds browseType:(NSString *)browseType taskNo:(NSString *)taskNo;

- (void)start;
- (void)pause;

@end

NS_ASSUME_NONNULL_END
