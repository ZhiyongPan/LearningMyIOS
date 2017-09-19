//
//  CommonParentViewController.m
//  TestProject
//
//  Created by pzy on 2017/9/19.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "CommonParentViewController.h"
#import "FromViewController.h"
#import "ToViewController.h"

@interface CommonParentViewController ()

@property (nonatomic, strong) FromViewController *fromVC;
@property (nonatomic, strong) ToViewController *toVC;

@property (nonatomic, strong) UIButton *button;

@end

@implementation CommonParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTestButton];
    [self addChildVC];
}

- (void)addTestButton
{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(SCREEN_WIDTH/2 - 50, SCREEN_HEIGHT/2 - 20, 100, 40);
    [button setTitle:@"Test" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    self.button = button;
    
    [self.view addSubview:button];
}

- (void)addChildVC
{
    FromViewController *fromVC = [[FromViewController alloc] init];
    [self.view addSubview:fromVC.view];
    self.fromVC = fromVC;
    [self addChildViewController:fromVC];
    
    ToViewController *toVC = [[ToViewController alloc] init];
    self.toVC = toVC;
    [self addChildViewController:toVC];
    
    [self.view bringSubviewToFront:self.button];
}

- (void)buttonClicked:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [self transitionFromViewController:self.fromVC toViewController:self.toVC duration:5.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
//        do something
    } completion:^(BOOL finished){
        if (finished) {
            weakSelf.toVC.view.frame = CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
    }];
}

@end
