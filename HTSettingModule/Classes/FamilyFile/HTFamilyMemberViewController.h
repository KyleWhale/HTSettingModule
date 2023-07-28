//
//  HTFamilyMemberViewController.h
//  Merriciya
//
//  Created by 昊天 on 2023/5/29.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTFamilyMemberViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *var_tableView;
@property (nonatomic, strong) NSString *var_inputText;

@end

NS_ASSUME_NONNULL_END
