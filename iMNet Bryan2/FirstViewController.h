//
//  FirstViewController.h
//  iMNet Bryan2
//
//  Created by Bryan on 13/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDetailsViewController.h"


//core data headers
#import "Contacts.h"
#import "Images.h"
#import "Location.h"
#import "Messages.h"
#import "OwnSettings.h"

//redpark cable headers
#import "RscMgr.h"
#import "XbeeRx.h"
#import "XbeeTx.h"
#import "hexConvert.h"
#define BUFFER_LEN 1024
#define fragment_len 177

@interface FirstViewController : UIViewController<RscMgrDelegate>{

    NSManagedObjectContext *managedObjectContext;   
    
    //redpark cable declarations
    RscMgr *rscMgr;
    UInt8   rxBuffer[BUFFER_LEN];
    UInt8   txBuffer[BUFFER_LEN];
    NSMutableArray *rxPacketBuffer;     //Temporary storage of bytes while rxBuffer is accumulating a packet
    int FrameID;                   //Frame ID counter    
    serialPortStatus portStatus;
    serialPortConfig portConfig;
    NSMutableArray *txBufferArray;      //iPhone packet buffer for transmitting large files
    NSMutableArray *rxBufferArray;      //iPhone packet buffer for receiving large files (> 1 packet)

    
    Contacts *currentContact; 
    
    IBOutlet UITextField *sendMessage;
    IBOutlet UITextField *receivedMessage;
    IBOutlet UITextField *username;
    IBOutlet UITextField *addr16;
    IBOutlet UITextField *addr64;
    IBOutlet UITextField *receivedHexMessage;
}

- (IBAction)resignKeyboard:(id)sender;
- (IBAction)sendMessage:(id)sender;


@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;  
@property (nonatomic,retain) NSMutableArray *txBufferArray;
@property (nonatomic,retain) UITextField *receivedMessage;
@property (nonatomic,retain) UITextField *receivedHexMessage;
@property (nonatomic,retain) UITextField *sendMessage;
@property (nonatomic,retain) UITextField *username;
@property (nonatomic,retain) UITextField *addr16;
@property (nonatomic,retain) UITextField *addr64;
@property (nonatomic,retain) RscMgr *rscMgr;
@property (nonatomic,retain) Contacts *currentContact;

@end
