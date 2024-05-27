//
//  GNEvent.m
//  SuperApp
//
//  Created by wGN on 2021/5/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNEvent.h"


@implementation GNEvent
@synthesize indexPath = _indexPath;
@synthesize target = _target;
@synthesize key = _key;
@synthesize info = _info;
+ (GNEvent *)eventKey:(nullable NSString *)key {
    return [GNEvent eventResponder:nil target:nil key:key indexPath:nil info:nil];
}
+ (GNEvent *)eventKey:(nullable NSString *)key info:(nullable NSDictionary *)info {
    return [GNEvent eventResponder:nil target:nil key:key indexPath:nil info:info];
}
+ (GNEvent *)eventKey:(nullable NSString *)key indexPath:(nullable NSIndexPath *)indexPath {
    return [GNEvent eventResponder:nil target:nil key:key indexPath:indexPath info:nil];
}
+ (GNEvent *)eventResponder:(nullable UIResponder *)responder {
    return [GNEvent eventResponder:responder target:nil key:nil indexPath:nil info:nil];
}
+ (GNEvent *)eventResponder:(nullable UIResponder *)responder target:(nullable UIResponder *)target {
    return [GNEvent eventResponder:responder target:target key:nil indexPath:nil info:nil];
}
+ (GNEvent *)eventResponder:(nullable UIResponder *)responder target:(nullable UIResponder *)target key:(nullable NSString *)key {
    return [GNEvent eventResponder:responder target:target key:key indexPath:nil info:nil];
}
+ (GNEvent *)eventResponder:(nullable UIResponder *)responder target:(nullable UIResponder *)target key:(nullable NSString *)key indexPath:(nullable NSIndexPath *)indexPath {
    return [GNEvent eventResponder:responder target:target key:key indexPath:indexPath info:nil];
}
+ (GNEvent *)eventResponder:(nullable UIResponder *)responder
                     target:(nullable UIResponder *)target
                        key:(nullable NSString *)key
                  indexPath:(nullable NSIndexPath *)indexPath
                       info:(nullable NSDictionary *)info {
    GNEvent *event = GNEvent.new;
    event.target = target;
    event.key = key;
    event.indexPath = indexPath;
    event.info = info;
    if (responder) {
        [responder.nextResponder respondEvent:event];
    }
    return event;
}

@end


@implementation UIResponder (GNEvent)
- (void)respondEvent:(NSObject<GNEvent> *)event {
    [self.nextResponder respondEvent:event];
}
@end


@implementation UIView (GNData)
- (void)setGNModel:(id)data {
}

- (void)setGNCellModel:(id)data {
}
@end
