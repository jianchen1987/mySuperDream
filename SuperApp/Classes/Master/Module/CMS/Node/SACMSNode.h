//
//  SACMSNode.h
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACMSNode : SACodingModel

@property (nonatomic, copy) NSString *nodeNo;     ///< 编号
@property (nonatomic, assign) NSInteger location; ///< 位置
///< 发布号
@property (nonatomic, copy) NSString *nodePublishNo;
@property (nonatomic, copy) NSString *nodeContent; ///<

- (NSDictionary *)getNodeContent;

- (NSString *)name;

@end

NS_ASSUME_NONNULL_END
