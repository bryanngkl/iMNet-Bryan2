//
//  MapViewController.h
//  GUI_1
//
//  Created by Kenneth on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCLController.h"
#import <Foundation/Foundation.h>
#import "ConvertLocationData.h"
#import "AddPinInfoViewController.h"
#import "RscMgr.h"
#import "XbeeRx.h"
#import "XbeeTx.h"
#import "RMMapView.h"


//core data headers
#import "Contacts.h"
#import "Images.h"
#import "Location.h"
#import "Messages.h"
#import "OwnSettings.h"

#import "FirstViewController.h"


@protocol AddPinInfoViewControllerDelegate
- (void) infoAddedWithTitle: (NSString *) title andDescription: (NSString*) description;
- (void) didReceiveMessage :(NSString *) message;
@end 

@interface MapViewController : UIViewController <MyCLControllerDelegate, UIAlertViewDelegate,RscMgrDelegate, AddPinInfoViewControllerDelegate> 

{   
    
    RscMgr *rscMgr;
    UInt8   txBuffer[BUFFER_LEN];

    //core data instance variables
    NSManagedObjectContext *managedObjectContext;   

    
    IBOutlet RMMapView *mapView;
    //IBOutlet RMMapView *mapView;
    //IBOutlet RMMapView *mapView;
    MyCLController *locationController;
    IBOutlet UILabel *locationLabel;
    float startlat;
    float startlon;
    RMMarker *currentLocationMarker;
    RMMarker *currentlyTappedMarker;
    CLLocationCoordinate2D locationOfCurrentlyTappedMarker;
    int count;

    
    NSString *contactpath;              //Location of plist of contacts
    NSString *imagePath;              //Location of current Image in UIView
    UIImage *imageSend;             //image to be sent
    
    NSMutableArray *rxPacketBuffer;     //Temporary storage of bytes while rxBuffer is accumulating a packet
    int FrameID;                   //Frame ID counter
    
    serialPortStatus portStatus;
    serialPortConfig portConfig;
    NSMutableArray *txBufferArray;      //iPhone packet buffer for transmitting large files
    NSMutableArray *rxBufferArray;    
}

@property (strong, nonatomic) IBOutlet RMMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *addInfo;

-(void) locationUpdate:(CLLocation *)location;
-(void) locationError:(NSError *)error;
- (IBAction)dropPin:(id)sender;
- (IBAction)locateMe:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *unhideButton;
- (IBAction)sendLocation:(id)sender;
- (IBAction)deleteCurrentPin:(id)sender;
- (IBAction)getNearbyInfo:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *deletePin;
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;  
@property (nonatomic,retain) RscMgr *rscMgr;

@property (nonatomic,retain) NSMutableArray *txBufferArray;

@end
