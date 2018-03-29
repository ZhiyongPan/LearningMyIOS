//
//  TestViewAndLayerController.m
//  TestProject
//
//  Created by 潘志勇 on 2018/3/29.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import "TestViewAndLayerController.h"

@interface TestViewAndLayerController ()

@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIView *redView;

@end

@implementation TestViewAndLayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addDefaultViews];
    
    AddButton(YES, 1, @"ChangeBoundsOrigin");
    AddButton(NO, 1, @"ChangeBoundsSize");
}

- (void)addDefaultViews
{
    UIView *blueView = [[UIView alloc] init];
    blueView.frame = CGRectMake(30, SCREEN_HEIGHT - 80, 100, 60);
    blueView.backgroundColor = [UIColor blueColor];
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    subView.backgroundColor = [UIColor yellowColor];
    [blueView addSubview:subView];
    self.blueView = blueView;
    [self.view addSubview:blueView];
    
    UIView *redView = [[UIView alloc] init];
    redView.frame = CGRectMake(30, SCREEN_HEIGHT - 160, 100, 60);
    redView.backgroundColor = [UIColor redColor];
    self.redView = redView;
    [self.view addSubview:redView];
}

- (void)onChangeBoundsOriginButtonClicked
{
    self.blueView.bounds = CGRectMake(10, 10, 100, 60);
}

- (void)onChangeBoundsSizeButtonClicked
{
    self.redView.bounds = CGRectMake(30, SCREEN_HEIGHT - 160, 70, 40);
}

@end
