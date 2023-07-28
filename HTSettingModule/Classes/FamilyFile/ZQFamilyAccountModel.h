//
//  ZQFamilyAccountModel.h

//
//  Created by admin on 2021/11/8.
//

#import "HTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZQFamilyAccountModel : HTBaseModel
@property (nonatomic, copy) NSString *face;
@property (nonatomic, copy) NSString *mail;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *master;
@property (nonatomic, copy) NSString *uid;

@end

NS_ASSUME_NONNULL_END
