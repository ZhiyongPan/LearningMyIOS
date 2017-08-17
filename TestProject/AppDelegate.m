//
//  AppDelegate.m
//  TestProject
//
//  Created by pzy on 2017/6/28.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "AppDelegate.h"
#import "Mediator.h"
#import "TestMainViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "TestArrayModel.h"

@interface AppDelegate ()

@property (nonatomic, strong) TestMainViewController* mainVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [AVOSCloud setApplicationId:@"ePbQVTjo0fnDWwRmmYhzrJQj-9Nh9j0Va" clientKey:@"WVfUf7gmyrD8tEKBT9y2AGLW"];
    
//    AVObject *testObject = [AVObject objectWithClassName:@"TestArrayModel"];
//    [testObject setObject:@"panzhiyong" forKey:@"name"];
//    [testObject setObject:@"15715651072" forKey:@"myID"];
//    [testObject setObject:@(25) forKey:@"age"];
//    [testObject setObject:@[@"str1", @"str2", @"str5"] forKey:@"array"];
//    [testObject save];
    
    AVQuery *query = [AVQuery queryWithClassName:@"TestArrayModel"];
    [query orderByDescending:@"createdAt"];
    // owner 为 Pointer，指向 _User 表
    [query includeKey:@"name"];
    // image 为 File
    [query includeKey:@"myID"];
    [query includeKey:@"age"];
    [query includeKey:@"array"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            AVObject *object = [objects firstObject];
            NSMutableDictionary *dict = object[@"localData"];
            NSString *name = [dict objectForKey:@"name"];
            NSString *myID = [dict objectForKey:@"myID"];
            NSInteger age = [[dict objectForKey:@"age"] integerValue];
            NSArray *array = [dict objectForKey:@"array"];
            NSLog(@"haha %@---%@---%@---%@",name,myID,@(age),array);
        }
    }];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Private

- (void)setMainViewController
{
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    [[Mediator sharedObject] setupWithNavigationController:navigationController];
    self.mainVC = (TestMainViewController *)navigationController.visibleViewController;
    
}

@end
