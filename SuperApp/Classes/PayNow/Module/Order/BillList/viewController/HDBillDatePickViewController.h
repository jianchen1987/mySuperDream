//
//  HDBillDatePickViewController.h
//  customer
//
//  Created by 帅呆 on 2018/10/31.
//  Copyright © 2018 chaos network technology. All rights reserved.
//

#import "PNViewController.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HD_SEARCH_DATE_TYPE) { HD_SEARCH_DATE_TYPE_MONTH = 0, HD_SEARCH_DATE_TYPE_INTERVAL = 1 };

@protocol billDatePickDelegate <NSObject>

@required
- (void)DatePickDateType:(HD_SEARCH_DATE_TYPE)dateType Start:(NSString *)start End:(NSString *)end;
- (void)DatePickCancel;

@end


@interface HDBillDatePickViewController : PNViewController

@property (nonatomic, weak) id<billDatePickDelegate> delegate;

@end
