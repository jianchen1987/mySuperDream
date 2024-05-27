//
//  GNEvent.h
//  SuperApp
//
//  Created by wGN on 2021/5/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol GNEvent <NSObject>
@property (nonatomic, strong) UIResponder *target;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) NSString *key;
@end


@interface GNEvent : NSObject <GNEvent>
+ (GNEvent *)eventKey:(nullable NSString *)key;
+ (GNEvent *)eventKey:(nullable NSString *)key info:(nullable NSDictionary *)info;
+ (GNEvent *)eventKey:(nullable NSString *)key indexPath:(nullable NSIndexPath *)indexPath;
+ (GNEvent *)eventResponder:(nullable UIResponder *)responder;
+ (GNEvent *)eventResponder:(nullable UIResponder *)responder target:(nullable UIResponder *)target;
+ (GNEvent *)eventResponder:(nullable UIResponder *)responder target:(nullable UIResponder *)target key:(nullable NSString *)key;
+ (GNEvent *)eventResponder:(nullable UIResponder *)responder target:(nullable UIResponder *)target key:(nullable NSString *)key indexPath:(nullable NSIndexPath *)indexPath;
+ (GNEvent *)eventResponder:(nullable UIResponder *)responder
                     target:(nullable UIResponder *)target
                        key:(nullable NSString *)key
                  indexPath:(nullable NSIndexPath *)indexPath
                       info:(nullable NSDictionary *)info;
@end


@interface UIResponder (GNEvent)
- (void)respondEvent:(NSObject<GNEvent> *)event;
@end


@interface UIView (GNData)
- (void)setGNModel:(id)data;
- (void)setGNCellModel:(id)data;
@end
NS_ASSUME_NONNULL_END
