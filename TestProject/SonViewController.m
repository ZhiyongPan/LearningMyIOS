//
//  SonViewController.m
//  TestProject
//
//  Created by pzy on 2017/6/28.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "SonViewController.h"
#import <Foundation/Foundation.h>

@interface SonViewController ()
@property (nonatomic, strong) NSString *str;
@end

@implementation SonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*-------------------self和super----------------------*/
//    self.str = @"Son";
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    button.frame = CGRectMake(100, 100, 50, 20);
//    button.backgroundColor = [UIColor redColor];
//    [self.view addSubview:button];
    
    /*------------------view的bounds-----------------------*/
//    UIView *view1 = [[UIView alloc] init];
//    view1.frame = CGRectMake(10, 50, 250, 250);
//    view1.backgroundColor = [UIColor redColor];
//    view1.bounds = CGRectMake(20, 20, 150, 150);
//    [self.view addSubview:view1];
//    
//    UIView *view2 = [[UIView alloc] init];
//    view2.frame = CGRectMake(0, 00, 50, 50);
//    view2.backgroundColor = [UIColor yellowColor];
//    [view1 addSubview:view2];
    
    
    /*-------------------layer的anchorPoint和position----------------------*/
//    CALayer *layer1 = [[CALayer alloc] init];
//    layer1.frame = CGRectMake(10, 30, 100, 200);
//    layer1.backgroundColor = [UIColor yellowColor].CGColor;
//    [self.view.layer addSublayer:layer1];
//    
//    CALayer *layer2 = [[CALayer alloc] init];
//    layer2.frame = CGRectMake(49, 99, 2, 2);
//    layer2.backgroundColor = [UIColor blackColor].CGColor;
//    [layer1 addSublayer:layer2];
//    
//    CALayer *layer = [[CALayer alloc] init];
//    layer.frame = CGRectMake(10, 30, 100, 200);
//    layer.backgroundColor = [UIColor redColor].CGColor;
//    layer.anchorPoint = CGPointMake(0.5, 0);
//    [self.view.layer addSublayer:layer];
//    
//    NSLog(@"%f %f",layer.position.x,layer.position.y);
}

- (void)printStr{
    
    NSLog(@"Son printStr");
    NSLog(@"%@",self.str);
}

- (void)buttonClicked:(UIButton *)button{
    
    [super printStr];
}

@end
