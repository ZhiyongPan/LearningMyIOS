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


NSString * const PZYKVOClassPrefix = @"PZYKVOClassPrefix_";
NSString * const PZYObserversKey = @"PZYObserversKey";

@implementation NSObject (PZYKVO)

static NSString * setterForGetter(NSString *getter)
{
    if (getter.length <= 0) {
        return nil;
    }
    
    // upper case the first letter
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];
    
    // add 'set' at the begining and ':' at the end
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];
    
    return setter;
}

static NSString *getterForSetter(NSString *setter)
{
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *getter = [setter substringWithRange:range];

    // lower case the first letter
    NSString *firstLetter = [[getter substringToIndex:1] lowercaseString];
    getter = [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];

    return getter;
}

static void pzy_setter(id self, SEL _cmd, id newValue)
{
    //先拿到旧值
    NSString *setter = NSStringFromSelector(_cmd);
    NSString *getter = getterForSetter(setter);
    id oldValue = [self valueForKey:getter];
    
    //然后调用super的setter
    struct objc_super superClazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSuperSend_cast)(void *, SEL, id) = (void *)objc_msgSendSuper;
    objc_msgSuperSend_cast(&superClazz, _cmd, newValue);

    //然后判断有没有observer，调用Block
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(PZYObserversKey));
    for (PZYObserverInfo *info in observers) {
        if ([info.key isEqualToString:getter]) {
            info.block(self, info.key, oldValue, newValue);
            break;
        }
    }
}

- (void)PZY_addObserver:(id)observer forKeyPath:(NSString *)keyPath withBlock:(PZYObserverBlock)block
{
    NSString *setter = setterForGetter(keyPath);
    SEL setterSelector = NSSelectorFromString(setter);
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    
    //1.先判断自己是不是改造后的类，如果不是要构造
    Class clazz = object_getClass(self);
    NSString *clazzString = NSStringFromClass(clazz);
    if (![clazzString hasPrefix:PZYKVOClassPrefix]) {
        clazz = createKVOClazz(clazz);
        object_setClass(self, clazz);
    }
    
    //2.如果是的话，判断自己有没有对应的setter
    if (![self hasSlector:setterSelector]) {
        const char *types = method_getTypeEncoding(setterMethod);
        class_addMethod(clazz, setterSelector, (IMP)pzy_setter, types);
    }

    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(PZYObserversKey));
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)(PZYObserversKey), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    PZYObserverInfo *info = [[PZYObserverInfo alloc] initWithObserver:observer keyPath:keyPath block:block];
    [observers addObject:info];
}

static Class createKVOClazz(Class originClazz)
{
    NSString *originClazzName = NSStringFromClass(originClazz);
    NSString *kvoClazzName = [PZYKVOClassPrefix stringByAppendingString:originClazzName];


    Class kvoClazz = objc_allocateClassPair(originClazz, kvoClazzName.UTF8String, 0);

    Method clazzMethod = class_getInstanceMethod(originClazz, @selector(class));
    const char *types = method_getTypeEncoding(clazzMethod);
    class_addMethod(kvoClazz, @selector(class), (IMP)kvo_class, types);

    objc_registerClassPair(kvoClazz);
    return kvoClazz;
}

static Class kvo_class(id self, SEL _cmd){

    return class_getSuperclass(object_getClass(self));
}

- (BOOL)hasSlector:(SEL)selector
{
    Class clazz = object_getClass(self);
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(clazz, &methodCount);
    
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methodList[i];
        SEL aSelector = method_getName(method);
        if (aSelector == selector) {
            free(methodList);
            return YES;
        }
    }
    free(methodList);
    return NO;
}

@end

