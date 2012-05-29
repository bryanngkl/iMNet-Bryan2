//
//  OptionsTableViewController.h
//  iMNet Bryan2
//
//  Created by Bryan on 13/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//redpark cable headers
#import "XbeeRx.h"
#import "XbeeTx.h"
#import "hexConvert.h"

//core data headers
#import "Contacts.h"
#import "Images.h"
#import "Location.h"
#import "Messages.h"
#import "OwnSettings.h"

#import "FirstViewController.h"
#import "HexEditorViewController.h"
#import "MoreOptionsViewController.h"

@interface OptionsTableViewController : UITableViewController{
    
    IBOutlet UILabel *networkIDLabel;
    IBOutlet UILabel *usernameLabel;
    IBOutlet UILabel *addr16;
    IBOutlet UILabel *addr64;
    
    NSManagedObjectContext *managedObjectContext;   
    
    RscMgr *rscMgr;
    int FrameID;
    UInt8   txBuffer[BUFFER_LEN];
}

- (void)optionsTableUpdate:(NSNotification *)notification;
- (IBAction)updateNetworkDetails:(id)sender;


@property (nonatomic,retain) RscMgr *rscMgr;
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;  
@property (nonatomic,retain) UILabel *networkIDLabel;
@property (nonatomic,retain) UILabel *usernameLabel;
@property (nonatomic,retain) UILabel *addr16;
@property (nonatomic,retain) UILabel *addr64;


@end
