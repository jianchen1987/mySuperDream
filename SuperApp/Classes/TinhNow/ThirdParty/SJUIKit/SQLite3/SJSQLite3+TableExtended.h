//
//  SJSQLite3+TableExtended.h
//  AFNetworking
//
//  Created by BlueDancer on 2020/5/16.
//

#import "SJSQLite3.h"
#import "SJSQLiteObjectInfo.h"
#import "SJSQLiteTableInfo.h"

NS_ASSUME_NONNULL_BEGIN


@interface SJSQLite3 (TableExtended)
- (BOOL)containsColumn:(NSString *)column inTableForClass:(Class)cls;
@end

NS_ASSUME_NONNULL_END
