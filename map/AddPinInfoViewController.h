//
//  AddPinInfoViewController.h
//  GUI_1
//
//  Created by Kenneth on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataClass.h"

//core data headers
#import "Contacts.h"
#import "Images.h"
#import "Location.h"
#import "Messages.h"
#import "OwnSettings.h"

#import "RscMgr.h"

#import "FirstViewController.h"
#import "SendLocationContactsViewController.h"

@protocol AddPinInfoViewControllerDelegate;

@interface AddPinInfoViewController : UIViewController{
    id<AddPinInfoViewControllerDelegate> delegate;
    UITextField *title;
    UITextView *description;
    NSString *stringToSend;
    
    
    //core data instance variables
    NSManagedObjectContext *managedObjectContext;   
    
    //redpark cable instance variables
    RscMgr *rscMgr;
    int FrameID;
    UInt8   txBuffer[BUFFER_LEN];

}
- (IBAction)resignKeyboard:(id)sender;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *title;
@property (strong, nonatomic) IBOutlet UITextView *description;

@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;  
@property (nonatomic,retain) RscMgr *rscMgr;
@property (nonatomic,retain) NSString * stringToSend;


@property (nonatomic, unsafe_unretained) id <AddPinInfoViewControllerDelegate> delegate;
- (IBAction)doneButtonOnKeyboardPressed: (id)sender;

@end
