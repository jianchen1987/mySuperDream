//
//  HDCollectionCellBaseEventModel.m
//  SuperApp
//
//  Created by VanJay on 2020/8/24.
//  Copyright © 2020 VanJay. All rights reserved.
//

#import "HDCollectionCellBaseEventModel.h"


@implementation HDCollectionCellBaseEventModel

- (instancetype)initWithEventName:(NSString *_Nullable)eventName {
    return [self initWithEventName:eventName parameter:nil];
}

- (instancetype)initWithEventName:(NSString *_Nullable)eventName parameter:(id _Nullable)parameter {
    if (self = [super init]) {
        self.eventName = eventName;
        self.parameter = parameter;
    }
    return self;
}

+ (instancetype)createWithEventName:(NSString *_Nullable)eventName {
    HDCollectionCellBaseEventModel *eventModel = [[HDCollectionCellBaseEventModel alloc] initWithEventName:eventName parameter:nil];
    return eventModel;
}

+ (instancetype)createWithEventName:(NSString *_Nullable)eventName parameter:(id _Nullable)parameter {
    HDCollectionCellBaseEventModel *eventModel = [[HDCollectionCellBaseEventModel alloc] initWithEventName:eventName parameter:parameter];
    return eventModel;
}

@end
