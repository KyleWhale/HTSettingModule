//
//  HTFamilyMemberTableViewCell.h
//  Merriciya
//
//  Created by 昊天 on 2023/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTFamilyMemberTableViewCell : UITableViewCell
@property (nonatomic, strong) UITextField *var_textField;
@property (nonatomic, strong) UIButton *var_questionButton;


- (void)ht_updateInfo:(NSString *)var_placeholder andIndex:(NSInteger)var_index;
@end

NS_ASSUME_NONNULL_END
