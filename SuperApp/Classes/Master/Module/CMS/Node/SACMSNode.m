//
//  SACMSNode.m
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSNode.h"


@interface SACMSNode ()

@property (nonatomic, copy) NSString *nodeParent;              ///< 父级编号
@property (nonatomic, copy) NSString *nodeName;                ///< 名称
@property (nonatomic, strong) NSArray<SACMSNode *> *childNode; ///< 子Node
@property (nonatomic, strong) NSDictionary *theme;             ///< 主题

@end


@implementation SACMSNode

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"location": @"nodeLocation"};
}

- (NSDictionary *)getNodeContent {
    if (HDIsStringEmpty(_nodeContent)) {
        return [NSDictionary dictionary];
    }
    NSData *data = [_nodeContent dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (NSString *)name {
    return self.nodeName;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:SACMSNode.class]) {
        //        HDLog(@"节点类型不一致");
        return NO;
    }
    SACMSNode *node = (SACMSNode *)object;

    if (![self.nodeNo isEqualToString:node.nodeNo]) {
        //        HDLog(@"节点编号不一致");
        return NO;
    }

    if (HDIsStringNotEmpty(self.nodeName) && HDIsStringNotEmpty(node.nodeName) && ![self.nodeName isEqualToString:node.nodeName]) {
        HDLog(@"节点名称不一致");
        return NO;
    }

    if (self.location != node.location) {
        HDLog(@"节点位置不一致");
        return NO;
    }

    if (![self.nodeContent isEqualToString:node.nodeContent]) {
        HDLog(@"节点内容不一致");
        return NO;
    }

    return YES;
}

@end
