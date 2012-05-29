//
//  SendLocationContactsViewController.h
//  iMNet Bryan2
//
//  Created by Bryan on 17/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//core data headers
#import "Contacts.h"
#import "Images.h"
#import "Location.h"
#import "Messages.h"
#import "OwnSettings.h"

#import "RscMgr.h"

#import "FirstViewController.h"

@interface SendLocationContactsViewController : UITableViewController{

    NSString *stringToSend;
    NSMutableArray *fetchedContactsArray;    
    //core data instance variables
    NSManagedObjectContext *managedObjectContext;   
    
    //redpark cable instance variables
    RscMgr *rscMgr;
    int FrameID;
    UInt8   txBuffer[BUFFER_LEN];
    
}
- (void)contactTableUpdate:(NSNotification *)notification;
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;  
@property (nonatomic,retain) RscMgr *rscMgr;
@property (nonatomic,retain) NSString *stringToSend;

@end
