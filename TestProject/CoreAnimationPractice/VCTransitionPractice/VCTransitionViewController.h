//
//  VCTransitionViewController.h
//  TestProject
//
//  Created by pzy on 2017/8/31.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AnimateType){
    AnimateTypeTransionFromViewController = 0,
    AnimateTypeCATransition,
    AnimateTypeVCAnimatedTransitioning
};

@interface VCTransitionViewController : UIViewController

@property (nonatomic, strong) NSArray *concreteAnimateTypes;

@property (nonatomic, assign) AnimateType animteType;

@end
