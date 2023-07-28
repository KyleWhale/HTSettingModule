//
//  ZQSetupListCell.m
 
//
//  Created by admin on 2022/3/3.
//

#import "ZQSetupListCell.h"

@interface ZQSetupListCell()

@property (nonatomic, strong) UIView *var_setupContentView;
@property (nonatomic, strong) UIImageView *var_iconView;
@property (nonatomic, strong) UILabel *var_titleLabel;
@property (nonatomic, strong) UILabel *var_reddView;
@property (nonatomic, strong) UIView *var_lineView;

@end

@implementation ZQSetupListCell

- (void)ht_addCellSubViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.var_setupContentView];
    [self.var_setupContentView addSubview:self.var_iconView];
    [self.var_setupContentView addSubview:self.var_titleLabel];
    [self.var_setupContentView addSubview:self.var_reddView];
    [self.contentView addSubview:self.var_lineView];
    
    [self.var_setupContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, kWidthScale(15), 0, kWidthScale(15)));
    }];
    
    [self.var_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(kWidthScale(20));
        make.size.mas_equalTo(kWidthScale(22));
    }];
    
    [self.var_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.equalTo(self.var_iconView.mas_right).offset(kWidthScale(10));
    }];
    
    [self.var_reddView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.var_titleLabel.mas_right);
        make.centerY.equalTo(self.var_titleLabel.mas_top);
        make.size.mas_equalTo(8);
    }];
    
    [self.var_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(kWidthScale(15)+20);
        make.right.mas_equalTo(-kWidthScale(15));
    }];
}

- (void)ht_updateCellWithData:(id)data {
    if ( data ) {
        NSDictionary *dictionary = (NSDictionary *)data;
        [self.var_iconView sd_setImageWithURL:dictionary.allValues.firstObject];
        self.var_titleLabel.text = dictionary.allKeys.firstObject;
        self.var_reddView.hidden = YES;
        self.var_lineView.hidden = YES;
    }
}

- (UIView *)var_setupContentView {
    if (!_var_setupContentView) {
        _var_setupContentView = [[UIView alloc] init];
        _var_setupContentView.backgroundColor = [UIColor colorWithHexString:@"#2F2F43"];
        _var_setupContentView.layer.masksToBounds = YES;
        _var_setupContentView.layer.cornerRadius = 12;
    }
    return _var_setupContentView;
}

- (UIView *)var_iconView {
    if (!_var_iconView) {
        _var_iconView = [[UIImageView alloc] init];
    }
    return _var_iconView;
}

- (UILabel *)var_titleLabel {
    if (!_var_titleLabel) {
        _var_titleLabel = [[UILabel alloc] init];
        _var_titleLabel.textColor = [UIColor whiteColor];
        _var_titleLabel.font = [UIFont boldSystemFontOfSize:kWidthScale(16)];
    }
    return _var_titleLabel;
}

- (UILabel *)var_reddView {
    if (!_var_reddView) {
        _var_reddView = [[UILabel alloc] init];
        _var_reddView.backgroundColor = [UIColor redColor];
        _var_reddView.layer.cornerRadius = 4;
        _var_reddView.layer.masksToBounds = YES;
    }
    return _var_reddView;
}

- (UIView *)var_lineView {
    if (!_var_lineView) {
        _var_lineView = [[UIImageView alloc] init];
        _var_lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    }
    return _var_lineView;
}

@end
