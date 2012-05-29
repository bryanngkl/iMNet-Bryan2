//
//  HexEditorViewController.h
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

@interface HexEditorViewController : UIViewController{
    NSManagedObjectContext *managedObjectContext;   
    
    RscMgr *rscMgr;
    int FrameID;
    UInt8   txBuffer[BUFFER_LEN];

    IBOutlet UITextField *sendHex;
    IBOutlet UITextView *receivedHex;
}
- (IBAction)resignKeyboard:(id)sender;

- (void)hexReceived:(NSNotification *)notification;

- (IBAction)sendHexMessage:(id)sender;
@property (nonatomic,retain) RscMgr *rscMgr;
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;  
@property (nonatomic,retain) UITextField *sendHex;
@property (nonatomic,retain) UITextView *receivedHex;

@end
