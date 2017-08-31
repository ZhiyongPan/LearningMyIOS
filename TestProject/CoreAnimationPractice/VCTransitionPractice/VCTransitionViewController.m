//
//  VCTransitionViewController.m
//  TestProject
//
//  Created by pzy on 2017/8/31.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "VCTransitionViewController.h"
#import "VCAnimatedTransitioningViewController.h"

@interface VCTransitionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation VCTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configTableView];
}

- (void)configTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.frame;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    self.tableView = tableView;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    
    [self.view addSubview:tableView];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.animteType == AnimateTypeVCAnimatedTransitioning) {
        VCAnimatedTransitioningViewController *vcAnimatedTransitioningViewController = [[VCAnimatedTransitioningViewController alloc] init];
        vcAnimatedTransitioningViewController.concreteTrasitionType = indexPath.row;
        [self.navigationController pushViewController:vcAnimatedTransitioningViewController animated:YES];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.concreteAnimateTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    cell.textLabel.text = self.concreteAnimateTypes[indexPath.row];
    
    return cell;
}

@end
