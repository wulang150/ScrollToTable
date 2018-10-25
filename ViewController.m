//
//  ViewController.m
//  ScrollToTable
//
//  Created by  Tmac on 2017/11/8.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "ViewController.h"
#import "MyTableView.h"

@interface ViewController ()
<MyTableViewDelegate>
{
    NSArray *titleArr;
}

@property(nonatomic) MyTableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initData];
    [self createView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    titleArr = @[@"name1",@"name2",@"name3",@"name4",@"name5",@"name6",@"name7",@"name8",@"name9",@"name10",@"name11",@"name12",@"name13",@"name14",@"name15",@"name16"];
}

- (void)createView
{
    _tableView = [[MyTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64*2)];
    _tableView.myDelegate = self;
    [self.view addSubview:_tableView];
}

#pragma -mark MyTableViewDelegate

- (NSInteger)numOfTableView:(MyTableView *)tableView
{
    return titleArr.count;
}

- (void)MyTableView:(MyTableView *)tableView willDisplayCell:(MyTableViewCell *)cell forIndex:(NSInteger)index
{
    cell.titleLab.text = titleArr[index];
}

- (void)MyTableView:(MyTableView *)tableView didSelectedCell:(MyTableViewCell *)cell forIndex:(NSInteger)index
{
    NSLog(@"name = %@",titleArr[index]);
}

@end
