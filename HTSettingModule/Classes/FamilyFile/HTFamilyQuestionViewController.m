//
//  HTFamilyQuestionViewController.m
//  Merriciya
//
//  Created by 昊天 on 2023/5/30.
//

#import "HTFamilyQuestionViewController.h"
#import "ZQFamilyManager.h"

@interface HTFamilyQuestionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *var_tableView;

@end

@implementation HTFamilyQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = AsciiString(@"FAQ");
    [self ht_loadData];
    [self ht_setupUI];
}

- (void)ht_loadData {
    NSArray *array = [ZQFamilyManager lgjeropj_questionViewTitleArray:self.var_total];
    self.dataArray = [NSMutableArray arrayWithArray:array];
}

- (void)ht_setupUI {
    self.var_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:self.var_tableView];
    self.var_tableView.delegate = self;
    self.var_tableView.dataSource = self;
    self.var_tableView.backgroundColor = [UIColor clearColor];
    self.var_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.var_tableView.rowHeight = UITableViewAutomaticDimension;
    self.var_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.var_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELLString_FamilyQuestionTableViewCell"];
}
#pragma mark - table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLString_FamilyQuestionTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    [self lgjeropj_cellAction:cell andIndexPath:indexPath];
    return cell;
}

- (void)lgjeropj_cellAction:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        cell.textLabel.text = self.dataArray[indexPath.section*2 + indexPath.row];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        if (indexPath.row == 0) {
            cell.textLabel.textColor = [UIColor whiteColor];
        }else {
            cell.textLabel.textColor = [UIColor grayColor];
        }
    }
}

@end
