//
//  HDCountrySliderChooseView.h
//  ViPay
//
//  Created by VanJay on 2019/7/20.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNView.h"
@class CountryModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^SelectCountryUnitViewHandler)(CountryModel *model);


@interface HDCountrySliderChooseView : PNView

@property (nonatomic, copy) SelectCountryUnitViewHandler selectCountryUnitViewHandler;
@property (nonatomic, copy) NSArray<CountryModel *> *dataSource; ///< 数据源
@property (nonatomic, strong) CountryModel *selectModel;

@end

NS_ASSUME_NONNULL_END
