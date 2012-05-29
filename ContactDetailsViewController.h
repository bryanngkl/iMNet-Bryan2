//
//  ContactDetailsViewController.h
//  iMNet Bryan2
//
//  Created by Bryan on 13/2/12.
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
#import "MessageLogViewController.h"

@interface ContactDetailsViewController : UIViewController{

    NSManagedObjectContext *managedObjectContext;   
    
    RscMgr *rscMgr;
    
    Contacts *currentContact;
    IBOutlet UITextField *username;
    IBOutlet UITextField *addr64;
    IBOutlet UITextField *addr16;
    
}
- (IBAction)resignKeyboard:(id)sender;

@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;  
@property (nonatomic,retain) Contacts *currentContact;  
@property (nonatomic,retain) UITextField *username;  
@property (nonatomic,retain) UITextField *addr64;  
@property (nonatomic,retain) UITextField *addr16;  
@property (nonatomic,retain) RscMgr *rscMgr;


@end
