//
//  TestDynamicController.h
//  TestProject
//
//  Created by pzy on 2017/9/14.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PaneState) {
    PaneStateOpen,
    PaneStateClosed
};

@interface TestDynamicController : UIViewController

@property (nonatomic, assign) PaneState paneState;

@end
