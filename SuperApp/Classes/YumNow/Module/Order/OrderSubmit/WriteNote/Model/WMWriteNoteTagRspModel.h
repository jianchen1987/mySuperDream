//
//  WMWriteNoteTagRspModel.h
//  SuperApp
//
//  Created by wmz on 2023/2/16.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMWriteNoteTagRspModel : WMRspModel
///实际
@property (nonatomic, copy) NSString *infactStr;
/// code
@property (nonatomic, copy) NSString *codeStr;
/// name
@property (nonatomic, strong) SAInternationalizationModel *name;
@end

NS_ASSUME_NONNULL_END
