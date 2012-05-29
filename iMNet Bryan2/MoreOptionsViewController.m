//
//  MoreOptionsViewController.m
//  iMNet Bryan2
//
//  Created by Bryan on 16/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MoreOptionsViewController.h"

@implementation MoreOptionsViewController
@synthesize managedObjectContext,rscMgr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{   FrameID = 1;
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)scanChannels:(id)sender {
    //send AT command for xbee to carry out channel scan with channel mask 7FFF
    XbeeTx *XbeeObj = [XbeeTx new];
    [XbeeObj ATCommandSetNumber:@"SC" withParameter:[[NSMutableArray alloc] initWithObjects:[NSNumber numberWithUnsignedInt:127],[NSNumber numberWithUnsignedInt:255], nil] withFrameID:FrameID];
    NSArray *sendPacket = [XbeeObj txPacket];
    for ( int i = 0; i < (int)[sendPacket count]; i++ ) {
        txBuffer[i] = [[sendPacket objectAtIndex:i] unsignedIntValue]; 
    }
    int bytesWritten = [rscMgr write:txBuffer Length:[sendPacket count]];
    FrameID = FrameID + 1;  //increment FrameID
    if (FrameID == 256) {   //If FrameID > 0xFF, start counting from 1 again
        FrameID = 1;
    }

}
@end
