//
//  WMHomeColumnModel.m
//  SuperApp
//
//  Created by wmz on 2023/6/26.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMHomeColumnModel.h"

@implementation WMHomeColumnModel
- (NSString *)name{
    if(!_name){
        NSString *name = @"";
        if(SAMultiLanguageManager.isCurrentLanguageCN){
            name = self.nameZh;
        }
        else if(SAMultiLanguageManager.isCurrentLanguageEN){
            name = self.nameEn;
        }
        else{
            name = self.nameKm;
        }
        _name = name;
    }
    return _name;
}

///添加默认附近门店标签
+(WMHomeColumnModel*)addDefaultTag{
    WMHomeColumnModel *model = WMHomeColumnModel.new;
    model.nameZh = @"推荐门店";
    model.nameEn = @"Recommend";
    model.nameKm = @"ហាងពេញនិយម";
    model.tag = @"near";
    return model;
}
@end
