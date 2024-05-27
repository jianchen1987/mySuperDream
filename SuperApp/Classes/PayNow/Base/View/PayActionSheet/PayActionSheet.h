//
//  PayActionSheet.h
//  SuperApp
//
//  Created by Quin on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaySelectableTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^PayActionSheetViewChoosedItemHandler)(PaySelectableTableViewCellModel *_Nullable model);


@interface PayActionSheet : NSObject
- (void)showPayActionSheetView:(NSArray *)dataArr CallBack:(PayActionSheetViewChoosedItemHandler)choosedItemHandler;
@property (nonatomic, copy) NSString *title;       //标题
@property (nonatomic, copy) NSString *buttonTitle; //按钮
@property (nonatomic, copy) NSString *DefaultStr;  //默认选中
@end

NS_ASSUME_NONNULL_END
