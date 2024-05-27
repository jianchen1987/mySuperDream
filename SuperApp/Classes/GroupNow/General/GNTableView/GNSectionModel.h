//
//  GNSectionModel.h
//  SuperApp
//
//  Created by wGN on 2021/5/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNRowModelProtocol.h"
#import "GNTableHeaderFootView.h"

NS_ASSUME_NONNULL_BEGIN
@class GNSectionModel;
typedef void (^GNSectionModelBlock)(GNSectionModel *_Nonnull sectionModel);


@interface GNSectionModel : NSObject

@property (nonatomic, strong) NSMutableArray<id<GNRowModelProtocol>> *rows;
/// headerClass
@property (nonatomic, strong) Class headerClass;
/// header行高
@property (nonatomic, assign) CGFloat headerHeight;
/// headerData
@property (nonatomic, strong) id headerData;
/// head是否是xib
@property (nonatomic, assign) BOOL headerXib;
/// FooterClass
@property (nonatomic, strong) Class footerClass;
/// Footer行高
@property (nonatomic, assign) CGFloat footerHeight;
/// FooterData
@property (nonatomic, strong) id footerData;
/// foot是否是xib
@property (nonatomic, assign) BOOL footerXib;
/// cellHeight
@property (nonatomic, assign) CGFloat cellHeight;
/// footerModel
@property (nonatomic, strong) GNTableHeaderFootViewModel *footerModel; ///< 表头数据模型
/// data
@property (nonatomic, strong) id data;
/// headerModel
@property (nonatomic, strong) GNTableHeaderFootViewModel *headerModel;
///使用卡片式section圆角
@property (nonatomic, assign) CGFloat cornerRadios;
/*!
 * @brief 快速init 类方法
 */
+ (GNSectionModel *)addSection:(nullable GNSectionModelBlock)block;
GNSectionModel *addSection(GNSectionModelBlock block);
@end
NS_ASSUME_NONNULL_END
