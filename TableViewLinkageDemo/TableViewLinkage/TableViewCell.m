//
//  TableViewCell.m
//  TableViewLinkageDemo
//
//  Created by 思 彭 on 2017/7/25.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "TableViewCell.h"
#import "UIView+AdjustFrame.h"

#define kCellIdentifier_Left @"LeftTableViewCell"
#define kCellIdentifier_Right @"RightTableViewCell"

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([reuseIdentifier isEqualToString:kCellIdentifier_Left]) {
            self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 40)];
        } else {
            self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.contentView.width, 40)];
        }
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor = [UIColor grayColor];
        self.nameLabel.highlightedTextColor = [UIColor blueColor];
        [self.contentView addSubview:self.nameLabel];
        
        UIImageView *indicatorImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"public_ic_more"]];
        indicatorImgView.hidden = YES;
        indicatorImgView.frame = CGRectMake(self.nameLabel.width - 5, self.nameLabel.centerY - 5, 8, 10);
        [self.contentView addSubview:indicatorImgView];
        // 两种cell的判断
        if ([reuseIdentifier isEqualToString:kCellIdentifier_Left]) {
            indicatorImgView.hidden = NO;
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.contentView.backgroundColor = !selected ? [UIColor whiteColor] : [UIColor colorWithWhite:0 alpha:0.1];
    self.highlighted = selected;
    self.nameLabel.highlighted = selected;
}

@end
