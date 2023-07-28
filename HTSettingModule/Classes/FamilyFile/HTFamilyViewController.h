//
//  HTFamilyViewController.h
//  Merriciya
//
//  Created by 昊天 on 2023/5/29.
//

#import "BaseViewController.h"
#import "HTFamilyTableViewCell.h"
#import "HTFamilyMemberViewController.h"
#import "HTFamilyQuestionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTFamilyViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *var_tableView;
@property (nonatomic, strong) UIView *var_bottomView;
@property (nonatomic, assign) NSInteger var_remainNum;
@property (nonatomic, assign) NSInteger var_currentNum;


@end

NS_ASSUME_NONNULL_END
