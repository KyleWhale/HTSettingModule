//
//  HTFamilyMemberTableViewCell.m
//  Merriciya
//
//  Created by 昊天 on 2023/5/30.
//

#import "HTFamilyMemberTableViewCell.h"

@interface HTFamilyMemberTableViewCell ()
@property (nonatomic, strong) UILabel *var_detailLabel;
@property (nonatomic, strong) UIView *var_lineView;

@end

@implementation HTFamilyMemberTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self ht_setupUI];
    }
    return self;
}

- (void)ht_setupUI {
    self.var_textField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.var_textField];
    [self.var_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).mas_equalTo(15);
        make.right.mas_equalTo(self.contentView).mas_equalTo(-15);
    }];
    self.var_textField.textColor = [UIColor whiteColor];
    self.var_textField.font = [UIFont systemFontOfSize:18];
    self.var_textField.returnKeyType = UIReturnKeyDone;
    
    self.var_lineView = [[UIView alloc] init];
    [self.contentView addSubview:self.var_lineView];
    [self.var_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).mas_equalTo(15);
        make.right.mas_equalTo(self.contentView).mas_equalTo(-15);
        make.height.mas_equalTo(1);
    }];
    self.var_lineView.backgroundColor = [UIColor grayColor];
    self.var_lineView.hidden = YES;
    
    [self lgjeropj_continuUi];
}

- (void)lgjeropj_continuUi
{
    self.var_questionButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.var_questionButton];
    [self.var_questionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.right.mas_equalTo(self.var_textField.mas_right).mas_equalTo(15);
        make.centerY.mas_equalTo(self.var_textField);
    }];
    [self.var_questionButton sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:13] forState:UIControlStateNormal];
    self.var_questionButton.hidden = YES;
    
    self.var_detailLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.var_detailLabel];
    [self.var_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).mas_equalTo(15);
        make.right.mas_equalTo(self.contentView).mas_equalTo(-15);
    }];
    self.var_detailLabel.numberOfLines = 0;
    self.var_detailLabel.textColor = [UIColor lightGrayColor];
    self.var_detailLabel.font = [UIFont systemFontOfSize:16];
    self.var_detailLabel.hidden = YES;
}

- (void)ht_updateInfo:(NSString *)var_placeholder andIndex:(NSInteger)var_index {
    if (var_index == 0)
    {
        self.var_textField.hidden = NO;
        self.var_lineView.hidden = NO;
        self.var_questionButton.hidden = NO;
        self.var_detailLabel.hidden = YES;
        
        NSDictionary *var_attributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName:[UIFont systemFontOfSize:16]};
        self.var_textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:var_placeholder attributes:var_attributes];
    } else
    {
        self.var_textField.hidden = YES;
        self.var_lineView.hidden = YES;
        self.var_questionButton.hidden = YES;
        self.var_detailLabel.hidden = NO;
        
        self.var_detailLabel.text = var_placeholder;
    }
}
@end
