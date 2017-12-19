//
//  CATransitionFromController.h
//  TestProject
//
//  Created by pzy on 2017/9/20.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CATransitionType) {
    CATransitionTypeFade = 0,
    CATransitionTypeMoveIn,
    CATransitionTypePush,
    CATransitionTypeReveal
};

@interface CATransitionFromController : UIViewController

@property (nonatomic, assign) CATransitionType transitionType;

@end
