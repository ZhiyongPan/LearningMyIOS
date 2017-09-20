//
//  BezierPathPracticeController.m
//  TestProject
//
//  Created by pzy on 2017/9/13.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "BezierPathPracticeController.h"
#import "PZYUIViewAnimationState.h"

@interface BezierPathPracticeController ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) UIBezierPath * fromPath;

@end

@implementation BezierPathPracticeController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addCALayer];
    [self beginAnimation];
}

- (void)addCALayer
{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor orangeColor].CGColor;
    [self.view.layer addSublayer:shapeLayer];
    
    // 构造fromPath
    UIBezierPath * fromPath = [UIBezierPath bezierPath];
    // 从左上角开始画
    [fromPath moveToPoint:CGPointZero];
    
    // 因为我的模拟器是6plus，所以屏幕宽度是414
    
    // 向下拉一条直线
    [fromPath addLineToPoint:CGPointMake(0, 400)];
    // 向右拉一条曲线，因为是向下弯的并且是从中间开始弯的，所以控制点的x是宽度的一半，y比起始点和结束点的y要大
    [fromPath addQuadCurveToPoint:CGPointMake(414, 400) controlPoint:CGPointMake(207, 500)];
    
    // 向上拉一条直线
    [fromPath addLineToPoint:CGPointMake(414, 0)];
    // 封闭路径，会从当前点向整个路径的起始点连一条线
    [fromPath closePath];
    
    shapeLayer.path = fromPath.CGPath;
    
    self.fromPath = fromPath;
    self.shapeLayer = shapeLayer;
}

- (void)beginAnimation
{
    // 构造toPath
    UIBezierPath * toPath = [UIBezierPath bezierPath];
    
    // 同样从左上角开始画
    [toPath moveToPoint:CGPointZero];
    // 向下拉一条线，要拉到屏幕外
    [toPath addLineToPoint:CGPointMake(0, 836)];
    // 向右拉一条曲线，同样因为弯的地方在正中间并且是向上弯，所以控制点的x是宽的一半，y比起始点和结束点的y要小
    [toPath addQuadCurveToPoint:CGPointMake(414, 836) controlPoint:CGPointMake(207, 736)];
    // 再向上拉一条线
    [toPath addLineToPoint:CGPointMake(414, 0)];
    // 封闭路径
    [toPath closePath];
    
    // 构造动画
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"path";
    animation.duration = 5;
    
    // fromValue应该是一个CGPathRef（因为path属性就是一个CGPathRef），它是一个结构体指针，使用桥接把结构体指针转换成OC的对象类型
    animation.fromValue = (__bridge id)self.fromPath.CGPath;
    
    // 同样添加一个延迟来方便我们查看效果
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 直接修改modelLayer的值来代替toValue
        self.shapeLayer.path = toPath.CGPath;
        animation.delegate = [PZYUIViewAnimationState animationStateWithBeginning:nil completion:^(BOOL complete){
            if (complete) {
                self.shapeLayer.fillColor = [UIColor blueColor].CGColor;
            }
        }];
        [self.shapeLayer addAnimation:animation forKey:nil];
    });
}

@end
