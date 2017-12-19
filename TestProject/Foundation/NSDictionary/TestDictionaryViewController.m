//
//  TestDictionaryViewController.m
//  TestProject
//
//  Created by pzy on 2017/7/27.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "TestDictionaryViewController.h"

@interface TestDictionaryViewController ()

@end

@implementation TestDictionaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dictionary = @{@"key1":@"value1", @"key2":@"value2", @"key3":@"value3", @"key4":@"value4"};
    NSEnumerator<NSString *> *enumerator = [dictionary keyEnumerator];
    NSString *str = nil;
    while (str = [enumerator nextObject]) {
        NSLog(@"%@",str);
    }
    
    NSLog(@"hihihihihi");
}


@end
