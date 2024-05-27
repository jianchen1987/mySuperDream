//
//  HDAuxiliaryToolShowLogWindow.m
//  SuperApp
//
//  Created by VanJay on 2019/11/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAuxiliaryToolShowLogWindow.h"


@interface HDAuxiliaryToolShowLogWindow ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter; ///< 日期格式化器
@end


@implementation HDAuxiliaryToolShowLogWindow
+ (instancetype)shared {
    static dispatch_once_t once;
    static HDAuxiliaryToolShowLogWindow *instance;
    dispatch_once(&once, ^{
        CGRect screenBounds = UIScreen.mainScreen.bounds;
        const CGFloat height = screenBounds.size.height * 0.78;
        instance = [[HDAuxiliaryToolShowLogWindow alloc] initWithFrame:CGRectMake(0, screenBounds.size.height - height, screenBounds.size.width, height)];
    });
    return instance;
}

- (void)addRootVc {
    HDAuxiliaryToolShowLogViewController *vc = [[HDAuxiliaryToolShowLogViewController alloc] init];
    vc.preferredContentSize = self.bounds.size;
    self.rootViewController = vc;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UITextView *textView = ((HDAuxiliaryToolShowLogViewController *)self.rootViewController).textView;

    if (textView.userInteractionEnabled && CGRectContainsPoint(textView.frame, point)) {
        return [super pointInside:point withEvent:event];
    }
    return NO;
}

- (HDAuxiliaryToolShowLogViewController *)vc {
    return (HDAuxiliaryToolShowLogViewController *)self.rootViewController;
}

#pragma mark - HDLoggerDelegate
- (NSString *)printLogWithFile:(NSString *)file line:(int)line func:(NSString *)func logItem:(HDLogItem *)logItem defaultString:(NSString *)defaultString {
    NSString *timeStr = [self.dateFormatter stringFromDate:[NSDate date]];
    NSString *fileName = [file lastPathComponent];
    NSString *str = [NSString stringWithFormat:@"%@:%d | %@ | %@ | %@\n", fileName, line, timeStr, logItem.levelDisplayString, logItem.logString];

    fprintf(stderr, "%s", str.UTF8String);

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.vc logStr:str];
    });
    return str;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_dateFormatter setDateFormat:@"HH:mm:ss"];
    }
    return _dateFormatter;
}
@end
