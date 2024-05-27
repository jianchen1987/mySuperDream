//
//  NationalityOptionController.h
//  customer
//
//  Created by 谢 on 2019/1/3.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "CountryModel.h"
#import "PNViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ChoosedCountryHandler)(CountryModel *model);


@interface NationalityOptionController : PNViewController
@property (nonatomic, copy) ChoosedCountryHandler choosedCountryHandler;
@property (nonatomic, strong) CountryModel *selectModel;
@end

NS_ASSUME_NONNULL_END
