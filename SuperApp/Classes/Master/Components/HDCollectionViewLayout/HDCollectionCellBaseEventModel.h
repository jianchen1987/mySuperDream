//
//  HDCollectionCellBaseEventModel.h
//  SuperApp
//
//  Created by VanJay on 2020/8/24.
//  Copyright © 2020 VanJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDCollectionCellBaseEventModel : NSObject
@property (nonatomic, copy) NSString *_Nullable eventName;
@property (nonatomic, strong) id _Nullable parameter;

- (instancetype)initWithEventName:(NSString *_Nullable)eventName;
- (instancetype)initWithEventName:(NSString *_Nullable)eventName parameter:(id _Nullable)parameter;
+ (instancetype)createWithEventName:(NSString *_Nullable)eventName;
+ (instancetype)createWithEventName:(NSString *_Nullable)eventName parameter:(id _Nullable)parameter;
@end

NS_ASSUME_NONNULL_END
