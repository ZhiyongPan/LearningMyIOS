//
//  NSObject+PZYKVO.m
//  TestProject
//
//  Created by 潘志勇 on 2018/1/29.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import "NSObject+PZYKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "PZYObserverInfo.h"

NSString * const PZYKVOClassPrefix = @"PZY_KVOClass_";
NSString *const PZYKVOAssociatedObservers = @"PZYKVOAssociatedObservers";

@implementation NSObject (PZYKVO)

- (void)test
{
    __unused NSObject *obj = [[NSObject alloc] init];
}

static NSString * kvoSetter(NSString *key)
{
    if (!key.length) {
        return nil;
    }
    NSString *firstCharacter = [[key substringToIndex:1] uppercaseString];
    NSString *remainCharacters = [key substringFromIndex:1];
    
    return [NSString stringWithFormat:@"set%@%@:", firstCharacter, remainCharacters];
}

static NSString * kvoGetter(NSString *setter)
{
    if (setter.length <=0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    
    // remove 'set' at the begining and ':' at the end
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    
    // lower case the first letter
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];
    
    return key;
}

- (BOOL)hasSelector:(SEL)selector
{
    Class clazz = object_getClass(self);
    unsigned int methodCount = 0;
    Method * methodList = class_copyMethodList(clazz, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method method = methodList[i];
        SEL methodSelctor = method_getName(method);
        if (methodSelctor == selector) {
            free(methodList);
            return YES;
        }
    }
    
    free(methodList);
    return NO;
}

- (void)PZY_addObserver:(NSObject *)object forKeyPath:(NSString *)keyPath withBlock:(PZYObserverBlock)block
{
    [self checkClassWithKeyPath:keyPath];
    
    //TODO addObserver
    PZYObserverInfo *info = [[PZYObserverInfo alloc] initWithObserver:object keyPath:keyPath block:block];
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(PZYKVOAssociatedObservers));
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)(PZYKVOAssociatedObservers), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [observers addObject:info];
}

- (void)checkClassWithKeyPath:(NSString *)keyPath
{
    Class clazz = object_getClass(self);
    NSString *clazzName = NSStringFromClass(clazz);
    if (![clazzName hasPrefix:PZYKVOClassPrefix]) {
        clazz = [self createKVOClassForOriginalClassName:clazzName];
        object_setClass(self, clazz);
    }
    
    SEL kvoSetterSelctor = NSSelectorFromString(kvoSetter(keyPath));
    if (![self hasSelector:kvoSetterSelctor]) {
        Method setterMethod = class_getInstanceMethod(clazz, kvoSetterSelctor);
        const char *types = method_getTypeEncoding(setterMethod);
        class_addMethod(clazz, kvoSetterSelctor, (IMP)kvo_setter, types);
    }
}

static void kvo_setter(id self, SEL _cmd, id newValue)
{
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = kvoGetter(setterName);
    
    id oldValue = [self valueForKey:getterName];
    
    struct objc_super superClazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    
    void(*objc_methodCast)(void * , SEL , id) = (void *)objc_msgSendSuper;
    objc_methodCast(&superClazz, _cmd, newValue);
    
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(PZYKVOAssociatedObservers));
    for (PZYObserverInfo *info in observers) {
        if ([info.key isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                info.block(self, info.key, oldValue, newValue);
            });
        }
    }
}

- (void)PZY_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    
}

static Class pzyKVOClass(id self, SEL _cmd)
{
    return class_getSuperclass(self);
}

- (Class)createKVOClassForOriginalClassName:(NSString *)originClazzName
{
    NSString *kvoClazzName = [PZYKVOClassPrefix stringByAppendingString:originClazzName];
    Class clazz = NSClassFromString(kvoClazzName);
    if (clazz) {
        return clazz;
    }
    
    Class originClazz = object_getClass(self);
    Class kvoClazz = objc_allocateClassPair(originClazz, kvoClazzName.UTF8String, 0);
    objc_registerClassPair(kvoClazz);
    
    Method originClassMethod = class_getInstanceMethod(originClazz, @selector(class));
    const char *types = method_getTypeEncoding(originClassMethod);
    class_addMethod(clazz, @selector(class), (IMP)pzyKVOClass, types);
    
    return kvoClazz;
}

@end
