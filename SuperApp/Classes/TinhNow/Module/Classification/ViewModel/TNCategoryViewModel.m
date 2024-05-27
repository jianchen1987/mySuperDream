//
//  TNCategoryViewModel.m
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategoryViewModel.h"
#import "TNCategoryDTO.h"
#import "TNCategoryModel.h"
#import "TNQueryGoodsCategoryRspModel.h"


@interface TNCategoryViewModel ()
/// TNCategoryDTO
@property (nonatomic, strong) TNCategoryDTO *categoryDTO;
@end


@implementation TNCategoryViewModel

- (void)queryCategory {
    [self.view showloading];
    @HDWeakify(self);
    [self.categoryDTO queryCategorySuccess:^(NSArray<TNFirstLevelCategoryModel *> *_Nonnull list) {
        @HDStrongify(self);
        [self.view dismissLoading];
        HDTableViewSectionModel *section = HDTableViewSectionModel.new;
        section.list = [NSArray arrayWithArray:list];
        self.firstLevel = @[section];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark - lazy load
/** @lazy tncategoryModel */
- (TNCategoryDTO *)categoryDTO {
    if (!_categoryDTO) {
        _categoryDTO = [[TNCategoryDTO alloc] init];
    }
    return _categoryDTO;
}
- (NSArray *)secondLevel {
    if (!_secondLevel) {
        _secondLevel = @[];
    }
    return _secondLevel;
}

- (NSArray *)firstLevel {
    if (!_firstLevel) {
        _firstLevel = @[];
    }
    return _firstLevel;
}

@end
