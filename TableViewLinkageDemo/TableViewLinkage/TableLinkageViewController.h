//
//  TableLinkageViewController.h
//  TableViewLinkageDemo
//
//  Created by 思 彭 on 2017/7/25.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"

static float kLeftTableViewWidth = 80.f;
#define kCellIdentifier_Left @"LeftTableViewCell"
#define kCellIdentifier_Right @"RightTableViewCell"

@interface TableLinkageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *categoryData;
@property (nonatomic, strong) NSMutableArray *foodData;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@end
