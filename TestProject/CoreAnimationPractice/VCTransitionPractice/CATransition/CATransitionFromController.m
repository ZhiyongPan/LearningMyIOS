//
//  CATransitionFromController.m
//  TestProject
//
//  Created by pzy on 2017/9/20.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "CATransitionFromController.h"
#import "CATransitionToController.h"

@interface CATransitionFromController ()

@end

@implementation CATransitionFromController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self addTestButton];
}

- (void)addTestButton
{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(SCREEN_WIDTH/2 - 50, SCREEN_HEIGHT/2 + 100, 100, 50);
    [button setTitle:@"Test" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(testButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:button];
}

- (void)testButtonClicked:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 2.0;
    transition.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    switch (self.transitionType) {
        case CATransitionTypeFade:
            transition.type = kCATransitionFade;
            break;
            
        case CATransitionTypeMoveIn:
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromRight;
            break;
            
        case CATransitionTypePush:
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            break;
            
        case CATransitionTypeReveal:
            transition.type = kCATransitionReveal;
            transition.subtype = kCATransitionFromRight;
            break;
        default:
            break;
    }
    
    //注：只有将CATransition加在self.view.window.layer上转场动画才会有效果
    [self.view.window.layer addAnimation:transition forKey:@"kTransitionAnimation"];
//    [self.view.layer addAnimation:transition forKey:@"kTransitionAnimation"];
    
    CATransitionToController *transitionToController = [[CATransitionToController alloc] init];
//    [self presentViewController:transitionToController animated:YES completion:nil];
    [self.navigationController pushViewController:transitionToController animated:YES];
}

@end
