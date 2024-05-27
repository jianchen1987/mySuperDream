//
//  FunctionCellModel.h
//  SuperApp
//
//  Created by Quin on 2021/11/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNModel.h"
@class PNWalletListConfigModel;
NS_ASSUME_NONNULL_BEGIN


@interface PNFunctionCellModel : PNModel
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *actionName;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSInteger count;

+ (PNFunctionCellModel *)getModel:(NSString *)imageName title:(NSString *)title actionName:(NSString *)actionName;

+ (PNFunctionCellModel *)getModel:(NSString *)imageName title:(NSString *)title actionName:(NSString *)actionName tag:(NSInteger)tag;

/// 通过配置文件转换
+ (PNFunctionCellModel *)getModelWithWalletConfigModel:(PNWalletListConfigModel *)config;
@end

NS_ASSUME_NONNULL_END
