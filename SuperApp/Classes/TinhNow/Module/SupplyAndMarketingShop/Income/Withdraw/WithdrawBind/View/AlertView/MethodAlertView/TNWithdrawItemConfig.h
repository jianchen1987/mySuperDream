//
//  TNWithdrawItemConfig.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, TNWithdrawItemAlertType) {
    TNWithdrawItemAlertTypeMethed = 0,     //提现方式
    TNWithdrawItemAlertTypeBank = 1,       //银行
    TNWithdrawItemAlertTypePayCompany = 2, //公司
};
NS_ASSUME_NONNULL_BEGIN


@interface TNWithdrawItemModel : NSObject
@property (nonatomic, copy) NSString *ID;             ///<
@property (nonatomic, copy) NSString *name;           ///<
@property (nonatomic, copy) NSString *localImageName; ///<
@property (nonatomic, assign) BOOL isSelected;        ///<
@end


@interface TNWithdrawItemConfig : NSObject
@property (nonatomic, copy) NSString *title;                           ///<
@property (nonatomic, assign) TNWithdrawItemAlertType type;            ///<
@property (strong, nonatomic) NSArray<TNWithdrawItemModel *> *dataArr; ///<  提现方式数据源
@end

NS_ASSUME_NONNULL_END
