//
//  HTFamilyTableViewCell.h
//  Merriciya
//
//  Created by 昊天 on 2023/5/29.
//

#import <UIKit/UIKit.h>
#import "ZQFamilyAccountModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HTFamilyTableCellClickDelegate <NSObject>

@optional

/// 点击代理
- (void)ht_familyMemberCellClick:(NSInteger)index;

@end

@interface HTFamilyTableViewCell : UITableViewCell
@property (nonatomic, assign) id <HTFamilyTableCellClickDelegate> delegate;


- (void)lgjeropj_updateCellWithData:(ZQFamilyAccountModel*)model andIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
