//
//  SASearchThematicModel.h
//  SuperApp
//
//  Created by Tia on 2022/12/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASearchThematicListModel : NSObject
/// 内容
@property (nonatomic, copy) NSString *content;
/// icon
@property (nonatomic, copy) NSString *icon;
/// 跳转地址
@property (nonatomic, copy) NSString *url;

@end


@interface SASearchThematicModel : NSObject

@property (nonatomic, assign) NSInteger sort;

@property (nonatomic, strong) NSArray<SASearchThematicListModel *> *thematicContentList;

/// 主题icon
@property (nonatomic, copy) NSString *thematicIcon;

/// 主题名称
@property (nonatomic, copy) NSString *thematicName;

@end

NS_ASSUME_NONNULL_END
