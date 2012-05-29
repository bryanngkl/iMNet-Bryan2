//
//  MessageLogViewController.h
//  iMNet Bryan2
//
//  Created by Bryan on 15/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//core data headers
#import "Contacts.h"
#import "Images.h"
#import "Location.h"
#import "Messages.h"
#import "OwnSettings.h"


@interface MessageLogViewController : UITableViewController{
    NSManagedObjectContext *managedObjectContext;   
    Contacts *currentContact;
    NSMutableArray *fetchedMessagesArray;

}

- (void)messageReceived:(NSNotification *)notification;
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;  
@property (nonatomic,retain) Contacts *currentContact;  

@end
