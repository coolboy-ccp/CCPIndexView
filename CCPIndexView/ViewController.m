//
//  ViewController.m
//  CCPIndexView
//
//  Created by chuchengpeng on 2017/12/21.
//  Copyright © 2017年 chuchengpeng. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+CCPIndexView.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

//
@property (nonatomic, copy) NSDictionary *dataDic;
//
@property (nonatomic, copy) NSArray *sectionArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self arrayFromPlist];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    [tableView ccpIndexView];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)arrayFromPlist {
    NSString *filePth = [[NSBundle mainBundle] pathForResource:@"DemoPlist" ofType:@"plist"];
    NSAssert(filePth, @"没有找到此文件名所指向的文件路径");
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePth];
    _dataDic = dic;
    _sectionArray = [_dataDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult cr = [obj1 compare:obj2];
        return cr != NSOrderedAscending;
    }];
}

#pragma mark -- UITableViewDatasource --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [_dataDic objectForKey:_sectionArray[section]];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.userInteractionEnabled = NO;
    NSArray *arr = [_dataDic objectForKey:_sectionArray[indexPath.section]];
    cell.textLabel.text = arr[indexPath.row];
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionArray[section];
}


- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView __TVOS_PROHIBITED {
    return _sectionArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

@end
