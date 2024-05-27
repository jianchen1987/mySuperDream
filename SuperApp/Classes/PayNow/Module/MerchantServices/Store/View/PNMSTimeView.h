//
//  PNMSTimeView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SelectBlock)(NSString *start, NSString *end);


@interface PNMSTimeView : PNView
@property (nonatomic, copy) NSString *startHour;
@property (nonatomic, copy) NSString *startMinute;
@property (nonatomic, copy) NSString *endHour;
@property (nonatomic, copy) NSString *endMinute;

@property (nonatomic, copy) SelectBlock selectBlock;

- (void)setStart:(NSString *)start end:(NSString *)end;

@end

NS_ASSUME_NONNULL_END
