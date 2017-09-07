//
//  PZYView.m
//  TestProject
//
//  Created by pzy on 2017/9/4.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "PZYView.h"
#import "PZYLayer.h"

@interface PZYView ()

@end

@implementation PZYView

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        
//    }
//    return self;
//}
//
//- (CGPoint)center
//{
//    return [super center];
//}
//
//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//}
//- (void)setCenter:(CGPoint)center
//{
//    [super setCenter:center];
//}
//- (void)setBounds:(CGRect)bounds
//{
//    [super setBounds:bounds];
//}

#pragma mark 类方法

+ (Class)layerClass
{
    return [PZYLayer class];
}

#pragma mark CALayerDelegate

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    return [super actionForLayer:layer forKey:event];
}

@end
