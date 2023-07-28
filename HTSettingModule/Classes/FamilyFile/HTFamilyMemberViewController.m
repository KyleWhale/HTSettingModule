//
//  HTFamilyMemberViewController.m
//  Merriciya
//
//  Created by 昊天 on 2023/5/29.
//

#import "HTFamilyMemberViewController.h"
#import "HTFamilyMemberTableViewCell.h"
#import "ZQFamilyManager.h"
#import "HTHttpRequest.h"
#import "ZQAccountTools.h"

@interface HTFamilyMemberViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@end

@implementation HTFamilyMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LocalString(@"Add Member", nil);
    [self ht_loadData];
    [self ht_setupUI];
}
- (void)ht_loadData {
    self.dataArray = [NSMutableArray arrayWithCapacity:5];
    [self.dataArray addObject:LocalString(@"Email, phone or account ID", nil)];
    [self.dataArray addObject:LocalString(@"Phone number example: +19097165187", nil)];
    [self.dataArray addObject:LocalString(@"*You can only add users registered in this app\n*You can add up to four additional family members\n*You cannot add users with family plan accounts", nil)];
}
- (void)ht_setupUI {
    self.var_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:self.var_tableView];
    self.var_tableView.delegate = self;
    self.var_tableView.dataSource = self;
    self.var_tableView.backgroundColor = [UIColor clearColor];
    self.var_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.var_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.var_tableView registerClass:[HTFamilyMemberTableViewCell class] forCellReuseIdentifier:@"CELLString_FamilyMemberTableViewCell"];
}
#pragma mark - table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2 - section;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 40;
        }else {
            return 30;
        }
    }
    return 130;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTFamilyMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLString_FamilyMemberTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    if (self.dataArray.count > 0) {
        NSInteger index = (indexPath.section == 0) ?indexPath.row : 2;
        [cell ht_updateInfo:self.dataArray[index] andIndex:index];
        if (index == 0) {
            cell.var_textField.delegate = self;
            [cell.var_questionButton addTarget:self action:@selector(ht_showHowAddMember) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 1) ? 150:60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    
    return [self lgjeropj_sectionHeaderUi:section];
}

- (UIView *)lgjeropj_sectionHeaderUi:(NSInteger)section
{
    UIView *var_sectionView = [[UIView alloc] init];
    if (section == 1) {
        UIButton *var_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [var_sectionView addSubview:var_button];
        [var_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(var_sectionView);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(kScreenWidth *0.75);
        }];
        var_button.backgroundColor = [UIColor whiteColor];
        [var_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [var_button setTitle:AsciiString(@"Add") forState:UIControlStateNormal];
        var_button.layer.masksToBounds = YES;
        var_button.layer.cornerRadius = 10.0;
        [var_button addTarget:self action:@selector(ht_addMemberAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return var_sectionView;
}

- (void)ht_addMemberAction {
    [self.view endEditing:YES];
    
    if (self.var_inputText.length == 0) {
        [SVProgressHUD showInfoWithStatus:LocalString(@"Email, phone or account ID", nil)];
    }else {
        [SVProgressHUD show];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.var_inputText forKey:AsciiString(@"mail")];
        ZQAccountModel *result = [[ZQAccountTools sharedInstance] lgjeropj_getAccountData];
        [dict setObject:result.var_fid forKey:AsciiString(@"fid")];

        __weak __typeof(self)weakSelf = self;
        [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 282] andParameters:dict andTrans:NO  andCompletion:^(id model, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            if (error == nil) {
                [weakSelf lgjeropj_showUpdataResult:model];
            } else {
                [SVProgressHUD showInfoWithStatus:LocalString(@"Time out, server is not responding.", nil)];
            }
        }];
    }
}
- (void)lgjeropj_showUpdataResult:(NSDictionary *)dict {
    __weak __typeof(self)weakSelf = self;
    [ZQFamilyManager lgjeropj_showUpdataResult:dict andText:self.var_inputText andBlock:^(bool code, NSString *title, NSString *msg) {
        [weakSelf ht_shareMemberThisApp:title andMsg:msg];
        weakSelf.var_inputText = @"";
    }];
}

- (void)ht_shareMemberThisApp:(NSString *)title andMsg:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LocalString(@"Share the app with my family", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NTFCTString_shareApp" object:nil];
        });
    }];
    [alertController addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover){
        popover.sourceView = self.view;
        popover.sourceRect = CGRectMake(kScreenWidth *0.5 - 100, kScreenHeight, 200, 250);
        popover.permittedArrowDirections = UIPopoverArrowDirectionDown;
    }
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)ht_showHowAddMember {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[ZQFamilyManager lgjeropj_familyText][AsciiString(@"title")] message:[ZQFamilyManager lgjeropj_familyText][AsciiString(@"msg")] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover){
        popover.sourceView = self.view;
        popover.sourceRect = CGRectMake(kScreenWidth *0.5 - 100, kScreenHeight, 200, 250);
        popover.permittedArrowDirections = UIPopoverArrowDirectionDown;
    }
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.var_inputText = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
