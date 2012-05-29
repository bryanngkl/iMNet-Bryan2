//
//  AppDelegate.h
//  iMNet Bryan2
//
//  Created by Bryan on 13/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsViewController.h"
#import "FirstViewController.h"
#import "ContactsViewController.h"
#import "ContactDetailsViewController.h"
#import "OptionsTableViewController.h"
#import "MessageLogViewController.h"
#import "MapViewController.h"
#import "RMMapView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{

    RscMgr *rscMgr;

    
    //core data objects
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;   

    //map
    MapViewController *viewController;


}

@property (nonatomic, strong) IBOutlet MapViewController *viewController;
    //core data methods
- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;





@property (strong, nonatomic) UIWindow *window;





@end
