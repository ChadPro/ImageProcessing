//
//  MainViewController.m
//  QSCWImageProcessing
//
//  Created by candela on 2017/10/19.
//  Copyright © 2017年 Qscw. All rights reserved.
//

#import "MainViewController.h"

#import "ImgToMatViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *myTableView;
@property(nonatomic,strong) NSArray *vcListArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcListArray = @[@"图片转点阵"];
    [self createUI];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.vcListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.vcListArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if(row == 0){
        ImgToMatViewController *vc = [[ImgToMatViewController alloc] init];
        vc.title = [self.vcListArray objectAtIndex:row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.myTableView = [[UITableView alloc] init];
    self.myTableView.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64);
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    [self.view addSubview:self.myTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

@end
