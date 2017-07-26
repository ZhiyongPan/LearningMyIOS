//
//  FatherViewController.m
//  TestProject
//
//  Created by pzy on 2017/6/28.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "FatherViewController.h"

@interface FatherViewController ()
@property (nonatomic, strong) NSString *str;
@end

@implementation FatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.str = @"Father";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)printStr{
    
    NSLog(@"Father printStr");
    NSLog(@"%@", self.str);
}

- (BOOL)isEqual:(id)object{
    
    return YES;
}

- (NSUInteger)hash{
    
    return 0;
}

@end
