//
//  AppDelegate.m
//  iMNet Bryan2
//
//  Created by Bryan on 13/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext,managedObjectModel,persistentStoreCoordinator;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //create RscMgr object for use with the redpark cable
    rscMgr = [[RscMgr alloc] init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        // Handle the error.
    }
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UINavigationController *naviController0 = [[tabBarController viewControllers] objectAtIndex:0];
    UINavigationController *naviController1 = [[tabBarController viewControllers] objectAtIndex:1];
    UINavigationController *naviController2 = [[tabBarController viewControllers] objectAtIndex:2];

    FirstViewController *firstViewController = [[naviController0 viewControllers] objectAtIndex:0];
    ContactsViewController *contactsViewController = [[naviController1 viewControllers] objectAtIndex:0];
    ContactDetailsViewController *contactDetailsViewController = [[contactsViewController.navigationController viewControllers] objectAtIndex:0];
    MessageLogViewController *messageLogViewControlller = [[contactDetailsViewController.navigationController viewControllers] objectAtIndex:0];
    OptionsTableViewController *optionsTableViewController = [[naviController2 viewControllers] objectAtIndex:0];
    MapViewController *mapViewController = [[tabBarController viewControllers] objectAtIndex:3];
    
    //initialise FrameID counter;
    firstViewController.managedObjectContext = context;
    firstViewController.rscMgr = rscMgr;
    contactsViewController.managedObjectContext = context;
    contactsViewController.rscMgr = rscMgr;
    contactDetailsViewController.managedObjectContext = context;
    messageLogViewControlller.managedObjectContext = context;
    optionsTableViewController.managedObjectContext = context;
    optionsTableViewController.rscMgr = rscMgr;
    
    mapViewController.managedObjectContext = context;
    mapViewController.rscMgr = rscMgr;
    
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];     
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}




#pragma mark -
#pragma mark Core Data stack


/*
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */



- (NSManagedObjectContext *) managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/*
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */


- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
    return managedObjectModel;
}


/*
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iMNet1.1.sqlite"];
    
    NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle the error.
    }    
    
    return persistentStoreCoordinator;
}

#pragma mark Application's documents directory

/*
 Returns the path to the application's documents directory.
 */


- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext
{
    
    NSError *error = nil;
    NSManagedObjectContext *objectContext = self.managedObjectContext;
    if (objectContext != nil)
    {
        if ([objectContext hasChanges] && ![objectContext save:&error])
        {
            // add error handling here
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}





@end
