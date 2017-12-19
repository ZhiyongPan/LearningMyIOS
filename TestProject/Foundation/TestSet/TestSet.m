//
//  TestSet.m
//  TestProject
//
//  Created by pzy on 2017/7/4.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "TestSet.h"

@interface TestSet()

@end
@implementation TestSet

- (BOOL)isEqual:(id)object{
    
    return self.sid == ((TestSet *)object).sid;
}

- (NSUInteger)hash{
    
    NSInteger strHash = [self.str hash];
    return strHash;
}

@end
