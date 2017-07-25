//
//  TableLinkageViewController.m
//  TableViewLinkageDemo
//
//  Created by 思 彭 on 2017/7/25.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "TableLinkageViewController.h"
#import "DataModel.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface TableLinkageViewController (){
    
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}

@end

@implementation TableLinkageViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择科室";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(jump:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _selectIndex = 0;
    _isScrollDown = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 加载数据
    [self loadData];

    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - 加载数据

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *dic in dict[@"data"]) {
        CategoryModel *model = [[CategoryModel alloc]init];
        model.categoryName = dic[@"categoryName"];
        NSMutableArray *listArr = [NSMutableArray array];
        for (NSDictionary *listDic in dic[@"list"]) {
            DataModel *dataModel = [[DataModel alloc]init];
            dataModel.id = listDic[@"id"];
            dataModel.name = listDic[@"name"];
            [listArr addObject:dataModel];
        }
        model.list = [listArr copy];
        [self.categoryData addObject:model];
    }
}

- (void)jump: (UIBarButtonItem *)item {
    NSLog(@"跳过");
    [self.navigationController pushViewController:[TableLinkageViewController new] animated:YES];
}

#pragma mark - Getters

- (NSMutableArray *)categoryData
{
    if (!_categoryData)
    {
        _categoryData = [NSMutableArray array];
    }
    return _categoryData;
}

//- (NSMutableArray *)foodData
//{
//    if (!_foodData)
//    {
//        _foodData = [NSMutableArray array];
//    }
//    return _foodData;
//}

- (UITableView *)leftTableView
{
    if (!_leftTableView)
    {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLeftTableViewWidth, SCREEN_HEIGHT)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = 44;
        _leftTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.backgroundColor = [UIColor clearColor];
        [_leftTableView registerClass:[TableViewCell class] forCellReuseIdentifier:kCellIdentifier_Left];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView
{
    if (!_rightTableView)
    {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kLeftTableViewWidth, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.rowHeight = 44;
        _rightTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _rightTableView.tableFooterView = [UIView new];
        _rightTableView.separatorColor = [UIColor clearColor];
        _rightTableView.showsVerticalScrollIndicator = NO;
        [_rightTableView registerClass:[TableViewCell class] forCellReuseIdentifier:kCellIdentifier_Right];
    }
    return _rightTableView;
}

#pragma mark - TableView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (_leftTableView == tableView) {
//        return 1;
//    } else {
//        return self.categoryData.count;
//    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_leftTableView == tableView) {
        return self.categoryData.count;
    } else {
        CategoryModel *model = self.categoryData[_selectIndex];
        NSArray *listArr = model.list;
        return listArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Left forIndexPath:indexPath];
        CategoryModel *model = self.categoryData[indexPath.row];
        cell.nameLabel.text = model.categoryName;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else {
        TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Right forIndexPath:indexPath];
        CategoryModel *model = self.categoryData[_selectIndex];
        DataModel *dataModel = model.list[indexPath.row];
        cell.nameLabel.text = dataModel.name;
        return cell;
    }
}

// TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向上，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView)
        && !_isScrollDown
        && (_rightTableView.dragging || _rightTableView.decelerating))
    {
        [self selectRowAtIndexPath:section];
    }
}

// TableView分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向下，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView)
        && _isScrollDown
        && (_rightTableView.dragging || _rightTableView.decelerating))
    {
        [self selectRowAtIndexPath:section + 1];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        _selectIndex = indexPath.row;
//        [self scrollToTopOfSection:_selectIndex animated:YES];
//        [_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]
//                              atScrollPosition:UITableViewScrollPositionTop
//                                      animated:YES];
        [_rightTableView reloadData];
    }
}

- (void)scrollToTopOfSection:(NSInteger)section animated:(BOOL)animated
{
    CGRect headerRect = [self.rightTableView rectForSection:section];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _rightTableView.contentInset.top);
    [self.rightTableView setContentOffset:topOfHeader animated:animated];
}

// 当拖动右边TableView的时候，处理左边TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - UISrcollViewDelegate

// 标记一下RightTableView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffsetY = 0;
    
    UITableView *tableView = (UITableView *) scrollView;
    if (_rightTableView == tableView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}


@end
