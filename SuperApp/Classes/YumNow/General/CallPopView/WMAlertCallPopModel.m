//
//  WMAlertCallPopModel.m
//  SuperApp
//
//  Created by wmz on 2022/4/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMAlertCallPopModel.h"
#import "SAApolloManager.h"


@implementation WMAlertCallPopModel
- (instancetype)initName:(id)name image:(id)image data:(nullable id)data type:(WMCallPhoneType)type {
    if (self = [super init]) {
        if ([name isKindOfClass:NSMutableAttributedString.class]) {
            self.atName = name;
        } else if ([name isKindOfClass:NSString.class]) {
            self.name = name;
        }
        self.image = image;
        self.dataSource = data;
        self.type = type;
    }
    return self;
}

+ (instancetype)initName:(id)name image:(id)image data:(nullable id)data type:(WMCallPhoneType)type {
    return [[self alloc] initName:name image:image data:data type:type];
}

///客服model
+ (WMAlertCallPopModel *)hotServerModel {
    NSMutableArray *marr = NSMutableArray.new;
    NSArray<SAContactPhoneModel *> *callCenter = [NSArray yy_modelArrayWithClass:SAContactPhoneModel.class json:[SAApolloManager getApolloConfigForKey:ApolloConfigKeyCallCenter]];
    [callCenter enumerateObjectsUsingBlock:^(SAContactPhoneModel *_Nonnull model, NSUInteger idx, BOOL *_Nonnull stop) {
        WMAlertCallPopModel *popModel = nil;
        if (idx == 0) {
            popModel = [WMAlertCallPopModel initName:@"Cellcard" image:@"yn_order_cellcard" data:model.num type:WMCallPhoneTypeCall];
        } else if (idx == 1) {
            popModel = [WMAlertCallPopModel initName:@"Metfone" image:@"yn_order_metfone" data:model.num type:WMCallPhoneTypeCall];
        } else if (idx == 2) {
            popModel = [WMAlertCallPopModel initName:@"Smart" image:@"yn_order_smart" data:model.num type:WMCallPhoneTypeCall];
        }
        if (popModel) {
            [marr addObject:popModel];
        }
    }];
    return [WMAlertCallPopModel initName:WMLocalizedString(@"suvJBCPM", @"联系客服") image:@"yn_order_callServer" data:marr type:WMCallPhoneTypeServer];
}

@end
