//
//  VCAnimatedTransitioningViewController.h
//  TestProject
//
//  Created by pzy on 2017/8/31.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VCConcreteTransitionType) {
    VCConcreteTransitionTypeBubble = 0,
    VCConcreteTransitionTypeDrawer,
    VCConcreteTransitionTypePresentHalf,
    VCConcreteTransitionTypePresent
};

@interface VCAnimatedTransitioningViewController : UIViewController

@property (nonatomic, assign) VCConcreteTransitionType concreteTrasitionType;

@end
