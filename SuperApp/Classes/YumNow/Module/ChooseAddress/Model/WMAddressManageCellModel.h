//
//  WMAddressManageCellModel.h
//  SuperApp
//
//  Created by wmz on 2021/4/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface WMAddressManageCellModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) BOOL change;
@end

NS_ASSUME_NONNULL_END
