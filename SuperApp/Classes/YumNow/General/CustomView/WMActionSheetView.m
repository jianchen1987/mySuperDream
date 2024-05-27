//
//  WMActionSheetView.m
//  SuperApp
//
//  Created by wmz on 2022/3/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMActionSheetView.h"
#import "HDCommonDefines.h"
#import "UIColor+HDKitCore.h"


@implementation WMActionSheetView

- (instancetype)initWithCancelButtonTitle:(NSString *__nullable)cancelButtonTitle config:(HDActionSheetViewConfig *__nullable)config {
    if (self = [super initWithCancelButtonTitle:cancelButtonTitle config:config]) {
        NSMutableArray *buttons = [self valueForKey:@"buttons"];
        if ([buttons isKindOfClass:NSMutableArray.class]) {
            [buttons removeAllObjects];
            [self setValue:buttons forKey:@"buttons"];
        }
        UIView *bottomView = [self valueForKey:@"iphoneXSeriousSafeAreaFillView"];
        if ([bottomView isKindOfClass:UIView.class])
            bottomView.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)setupContainerSubViews {
    NSMutableArray *buttons = [self valueForKey:@"buttons"];
    NSMutableArray *lines = [self valueForKey:@"lines"];
    for (HDActionSheetViewButton *button in buttons) {
        button.titleLabel.font = HDAppTheme.font.standard2Bold;
        [self.containerView addSubview:button];
    }
    for (short i = 0; i < buttons.count; i++) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor hd_colorWithHexString:@"f2f2f2"];
        [self.containerView addSubview:line];
        [lines addObject:line];
    }

    UIView *bottomView = [self valueForKey:@"iphoneXSeriousSafeAreaFillView"];
    if (iPhoneXSeries) {
        [self.containerView addSubview:bottomView];
    }
}

///防止崩溃
- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end
