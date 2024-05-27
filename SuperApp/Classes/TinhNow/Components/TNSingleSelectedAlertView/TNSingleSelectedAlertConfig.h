//
//  TNSingleSelectedAlertConfig.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNSingleSelectedItem : NSObject
/// 名字
@property (nonatomic, copy) NSString *name;
/// id
@property (nonatomic, copy) NSString *itemId;
///
@property (nonatomic, assign) BOOL selected;
@end


@interface TNSingleSelectedAlertConfig : NSObject
/// 标题
@property (nonatomic, copy) NSString *title;
/// 数据源
@property (strong, nonatomic) NSArray<TNSingleSelectedItem *> *dataArr;
@end

NS_ASSUME_NONNULL_END
