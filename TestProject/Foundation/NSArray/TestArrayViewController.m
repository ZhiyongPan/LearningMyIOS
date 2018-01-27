//
//  TestArrayViewController.m
//  TestProject
//
//  Created by pzy on 2017/7/7.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "TestArrayViewController.h"
#import "SubArray.h"
#import "TestArrayModel.h"

@interface TestArrayViewController ()

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *array2;
@property (nonatomic, strong) NSMutableArray *mutableArray;
@property (nonatomic, strong) NSMutableArray *mutableArray2;
@property (nonatomic, strong) NSString *testString;
@property (nonatomic, strong) NSPointerArray *pointerArray;
@end

@implementation TestArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *stringArray = @[@"1", @"2", @"3", @"4", @"5"];
    NSArray *numberArray = @[@(1), @(2), @(3), @(4), @(5)];
    NSArray *dicArray = @[@{@"myID":@"1"}, @{@"myID":@"2"}, @{@"myID":@"3"}, @{@"myID":@"4"}, @{@"myID":@"5"}];
    TestArrayModel *model1 = [[TestArrayModel alloc] initWithMyID:@"1" name:@"haha"];
    TestArrayModel *model2 = [[TestArrayModel alloc] initWithMyID:@"2" name:@"hihi"];
    TestArrayModel *model3 = [[TestArrayModel alloc] initWithMyID:@"3" name:@"hoho"];
    NSArray *modelArray = @[model1, model2, model3];
    
    TestArrayModel *model4 = [[TestArrayModel alloc] initWithMyID:@"4" name:@"heihei"];
    TestArrayModel *model5 = [[TestArrayModel alloc] initWithMyID:@"5" name:@"xixi"];
    NSArray *modelArray2 = @[model4, model2, model5];
    
    TestArrayModel *model6 = [[TestArrayModel alloc] initWithMyID:@"ca" name:@"heihei" age:10];
    TestArrayModel *model7 = [[TestArrayModel alloc] initWithMyID:@"aa" name:@"hihi" age:12];
    TestArrayModel *model8 = [[TestArrayModel alloc] initWithMyID:@"aa" name:@"hihi" age:11];
    NSArray *modelArray3 = @[model6, model7, model8];
    
//    self.array = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
    
    //测试NSArray的继承
//    SubArray *subArray = [SubArray arrayWithObjects:@"1", @"2", nil];//crash ?
//    SubArray *subArray = [[SubArray alloc] init];//won't crash
//    NSLog(@"%@",[subArray objectAtIndex:0]);
    
    //测试NSPointerArray
//    self.pointerArray = [NSPointerArray strongObjectsPointerArray];
//    [self.pointerArray addPointer:(__bridge void *)(self.testString)];
//    [self.pointerArray addPointer:NULL];
//    [self printPointerArray];
    
    //测试NSArray的API
    //- (NSString *)componentsJoinedByString:(NSString *)separator;
    //把NSArray中的内容用separator来接起来,先把array中的各个内容转为NSString，然后再连接。这里把array中的各个内容转为NSString其实就是取各个内容的description
//    NSString *str = [modelArray componentsJoinedByString:@"->"];
    
    //- (nullable ObjectType)firstObjectCommonWithArray:(NSArray<ObjectType> *)otherArray;
    //返回两个array中第一个相同项
//    id obj = [modelArray firstObjectCommonWithArray:modelArray2];
    
    //- (NSUInteger)indexOfObjectIdenticalTo:(ObjectType)anObject;和
    //- (NSUInteger)indexOfObjectIdenticalTo:(ObjectType)anObject inRange:(NSRange)range;
    //返回第一个与指定object相同的index，下面那个在指定范围内查找。注意：返回的index与range无关
//    NSInteger index = [modelArray indexOfObjectIdenticalTo:model2 inRange:NSMakeRange(1, 2)];
    
    //- (NSEnumerator<ObjectType> *)objectEnumerator;
    //- (NSEnumerator<ObjectType> *)reverseObjectEnumerator;
    //返回一个迭代器，能从第一个元素一个一个获取到最后一个（下面的是反转迭代器，从最后一个元素到第一个）
//    NSEnumerator *enumerator = [stringArray objectEnumerator];
//    id anObject;
//    
//    while (anObject = [enumerator nextObject]) {
//        /* code to act on each element as it is returned */
//    }
    
    //--------------------------------------数组排序------------------------------------------------//
    //1.用方法排序。自定义一个C++排序方法，然后调用进行排序
    //- (NSArray<ObjectType> *)sortedArrayUsingFunction:(NSInteger (NS_NOESCAPE *)(ObjectType, ObjectType, void * _Nullable))comparator context:(nullable void *)context;
    //- (NSArray<ObjectType> *)sortedArrayUsingFunction:(NSInteger (NS_NOESCAPE *)(ObjectType, ObjectType, void * _Nullable))comparator context:(nullable void *)context hint:(nullable NSData *)hint;
    //注：下面这个方法适用于这种场景：当一个Array很大且已经有序了，这个时候做了一个很小的变动，如果重新排序的话使用下面这个能比较快。其中第三个参数hint可以通过@property (readonly, copy) NSData *sortedArrayHint;获得,这个应该是通过一个已经排好序的数组获得。而如果变动较大时，用上面的方法排序。
    //注2：虽然文档中说下面的方法排序较快，但是不可迷信，其实也不是最优解
//    NSArray *funcitonSortedArray = [numberArray sortedArrayUsingFunction:sortedFunction context:NULL];
    
    //2.用Descriptor排序。
    //- (NSArray<ObjectType> *)sortedArrayUsingDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;
    //NSSortDescriptor是根据key来对Array进行排序
    //使用步骤：1.先创建NSSortDescriptor.(这里可创建多个，当创建多个时，排序是先根据第一个NSSortDescriptor的key排序，当几个元素的这个key一样时，再根据第二个NSSortDescriptor指定的key进行排序......。例如下面这个例子，首先根据myID排序，当myID一样时就根据age排序)。2.将创建的几个NSSortDescriptor放入数组。3.使用第二部创建的数组对所需排序的数据进行排序
//    NSSortDescriptor *sortDescriptor        = [[NSSortDescriptor alloc] initWithKey:@"myID" ascending:YES];
//    NSSortDescriptor *sortDescriptor2        = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
//    NSArray          *sortDescriptors       = [NSArray arrayWithObjects:sortDescriptor, sortDescriptor2, nil];
//    NSArray          *descriptorSortedArray = [modelArray3 sortedArrayUsingDescriptors:sortDescriptors];
    
    //3.用Selector排序。
    //- (NSArray<ObjectType> *)sortedArrayUsingSelector:(SEL)comparator;
    //如果Array中存的是基本数据类型，那么就已经有许多比较的方法可以直接用了，比如说NSString的- (NSComparisonResult)compare:(NSString *)string;方法。如果是自定义类型，那么可以自己写比较方法
//    NSArray *sortedArray = [stringArray sortedArrayUsingSelector:@selector(compare:)];//NSString自带的compare
//    NSArray *sortedArray = [modelArray3 sortedArrayUsingSelector:@selector(compareModel:)];//自定义类型要自己写compare
    
    //4.用Comparator排序
    //- (NSArray<ObjectType> *)sortedArrayUsingComparator:(NSComparator NS_NOESCAPE)cmptr NS_AVAILABLE(10_6, 4_0);
    //简单易用，其实与用Selector差不多
//    NSArray *comparatorSortedArray = [modelArray3 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//
//        TestArrayModel *model1 = obj1;
//        TestArrayModel *model2 = obj2;
//        NSComparisonResult result = [model1.myID compare:model2.myID];
//        if (result == NSOrderedSame) {
//            result = [[NSNumber numberWithInteger:model1.age] compare:[NSNumber numberWithInteger:model2.age]];
//        }
//        return result;
//    }];
    
    
    //--------------------------------------其他------------------------------------------------//
    //- (NSArray<ObjectType> *)subarrayWithRange:(NSRange)range;
    //获取Array中的指定范围
    
    //- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;
    //- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically;
    //写入本地
    
    //- (void)makeObjectsPerformSelector:(SEL)aSelector;
    //- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(nullable id)argument;
    //让Array中的元素挨个执行slector
    //在selector中不能改变数组。上面的方法selector不能有参数，下面的方法selector只能有一个参数。这两个方法中的selector都需要写在Array中的元素中，比如下面示例中的selector就是写在TestArrayModel中
//    [modelArray3 makeObjectsPerformSelector:@selector(makePerformSelectorWithArr:) withObject:@"ss"];
    
    //- (ObjectType)objectAtIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0);
    //重写这个方法可以让让定义的model可以用下标的形式访问。
//    NSString *str = model1[1];
    
    //--------------------------------------数组遍历------------------------------------------------//
    //遍历的目的是为了获取某个元素，所以符合这个条件的方法都可以说是遍历
    //主要有以下几种：
    //1、for循环
    //2、forin（快速枚举）
    //3、makeObjectsPerformSelector
    //4、kvc集合运算符
    //5、enumerateObjectsUsingBlock
    //6、enumerateObjectsWithOptions(NSEnumerationConcurrent)
    //7、display_apply
    
    //结论
    //1、在数组数量很少的时候，各种方法效率差不多(kvc耗时约是其他方法耗时的两倍，但是依然很少)
    //2、在数组数量较多（以10万记）的时候差距就显示出来了，kvc非常慢，forin最少makeObjectsPerformSelector也比较少，enumerateObjectsUsingBlock、enumerateUsingOptions(NSEnumerationConcurrent)、display_apply差不多，约是forin和makeObjectsPerformSelector的十几倍，而for循环比这三个又要差上一些（约是他们的两倍）。要注意的是enumerateObjectsWithOptions(NSEnumerationConcurrent)和display_apply是和CPU有关的，CPU核数越多效果越好。===数据：当数组数量10万的时候：
    //------
           // 经典for循环 - 1.246721
           // for in (NSFastEnumeration) - 0.025955
           // makeObjectsPerformSelector - 0.068234
           // kvc集合运算符(@sum.number) - 21.677246
           // enumerateObjectsUsingBlock - 0.586034
           // enumerateObjectsWithOptions(NSEnumerationConcurrent) - 0.722548
           // dispatch_apply(Concurrent) - 0.607100
    //------
    //3、在遍历的同时执行耗时操作，以数组数量为100来看，后两种最好，其他的约是他们的两三倍。同样，后两种和CPU核数有关
    
    //kvc集合运算符即valueForKeyPath
//    NSArray<NSString *> *nameArray = [modelArray3 valueForKeyPath:@"@unionOfObjects.name"];
//    NSArray<NSString *> *nameArray2 = [modelArray3 valueForKeyPath:@"@distinctUnionOfObjects.name"];
//    NSArray *kvcArray = [@[modelArray, modelArray2] valueForKeyPath:@"@unionOfArrays.name"];
//    NSArray *kvcArray2 = [@[modelArray, modelArray2] valueForKeyPath:@"@distinctUnionOfArrays.name"];
    
    //-------------------------------判断一个数组是否包含另一个数组-------------------------//
    NSArray *array = @[@"1", @"2", @"3", @"4", @"5", @"6"];
    NSArray *array2 = @[@"3", @"5", @"6"];
    
    NSSet *set = [NSSet setWithArray:array];
    NSSet *set2 = [NSSet setWithArray:array2];
    BOOL ifContain = [set2 isSubsetOfSet:set];
    //因为NSSet底层是Hash表，所以查找快速，比较起来也就快一点
    
    NSLog(@"hahahahha");
}

- (void)printPointerArray
{
    NSLog(@"pointerArray-----%@---%@",[self.pointerArray pointerAtIndex:0],[self.pointerArray pointerAtIndex:1]);
    //结果是pointerArray-----(null)---(null)，因为NSPointerArray不引用添加的对象
}

NSInteger sortedFunction(id num1, id num2, void *context)
{
    int v1 = [num1 intValue];
    int v2 = [num2 intValue];
    
    if (v1 < v2) {
        
        return NSOrderedAscending;
        
    } else if (v1 > v2) {
        
        return NSOrderedDescending;
        
    } else {
        
        return NSOrderedSame;
    }
}

@end
