//
//  AnimateTypesViewController.m
//  TestProject
//
//  Created by pzy on 2017/8/31.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "AnimateTypesViewController.h"
#import "VCTransitionViewController.h"

@interface AnimateTypesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *animateTypes;

@property (nonatomic, strong) NSArray *concreteAnimateTypes;

@end

@implementation AnimateTypesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configAnimateTypes];
    [self configTableView];
    
    [self configConcreteAnimateTypes];
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

- (void)configAnimateTypes
{
    self.animateTypes = @[@"transitionFromViewController", @"CATransition", @"ViewControllerTransition协议"];
}

- (void)configConcreteAnimateTypes
{
    self.concreteAnimateTypes = @[@[@"present", @"transition"], @[@"Fade", @"Push", @"Cube"], @[@"Bubble", @"Drawer"]];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VCTransitionViewController *vcTransitionViewController = [[VCTransitionViewController alloc] init];
    vcTransitionViewController.concreteAnimateTypes = self.concreteAnimateTypes[indexPath.row];
    vcTransitionViewController.animateType = indexPath.row;
    [self.navigationController pushViewController:vcTransitionViewController animated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.animateTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    cell.textLabel.text = self.animateTypes[indexPath.row];
    
    return cell;
}


@end
