//
//  NationalityOptionSearchController.h
//  customer
//
//  Created by 谢 on 2019/1/4.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "CountryModel.h"
#import "PNViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^ChoosedCountryHandler)(CountryModel *model);


@interface NationalityOptionSearchController : PNViewController

@property (nonatomic, copy) ChoosedCountryHandler choosedCountryHandler;

@end

NS_ASSUME_NONNULL_END
