//
//  SABatchUploadFileRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SABatchUploadFileSingleRspModel : NSObject
@property (nonatomic, copy) NSString *fileId;    ///< 文件在文件服务器中的fileId
@property (nonatomic, copy) NSString *groupId;   ///< 文件在文件服务器中的组名
@property (nonatomic, copy) NSString *url;       ///< 文件完整url路径
@property (nonatomic, copy) NSString *visitHost; ///< 文件服务器在当前环境下的路由前缀
@end


@interface SABatchUploadFileRspModel : SARspModel
@property (nonatomic, copy) NSArray<NSString *> *uploadFailFileList;                         ///< 上传失败的文件名列表
@property (nonatomic, copy) NSArray<SABatchUploadFileSingleRspModel *> *uploadResultDTOList; ///< 上传成功的列表
@end

NS_ASSUME_NONNULL_END
