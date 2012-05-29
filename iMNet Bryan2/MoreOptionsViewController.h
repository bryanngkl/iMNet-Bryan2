//
//  MoreOptionsViewController.h
//  iMNet Bryan2
//
//  Created by Bryan on 16/2/12.
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


@interface MoreOptionsViewController : UIViewController{
    NSManagedObjectContext *managedObjectContext;   
    
    RscMgr *rscMgr;
    int FrameID;
    UInt8   txBuffer[BUFFER_LEN];


}

- (IBAction)scanChannels:(id)sender;
@property (nonatomic,retain) RscMgr *rscMgr;
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;  
@end
