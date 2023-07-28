//
//  ZQFamilyManager.h
//  Moshfocus
//
//  Created by dn on 2023/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZQFamilyManager : NSObject

+ (NSDictionary *)lgjeropj_familyText;

+ (void)lgjeropj_showUpdataResult:(NSDictionary *)dict andText:(NSString *)text andBlock:(void(^)(bool code, NSString *title, NSString *msg))block;

+ (NSArray *)lgjeropj_questionViewTitleArray:(NSInteger)var_total;

@end

NS_ASSUME_NONNULL_END
