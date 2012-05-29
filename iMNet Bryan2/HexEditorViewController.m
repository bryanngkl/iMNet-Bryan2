//
//  HexEditorViewController.m
//  iMNet Bryan2
//
//  Created by Bryan on 16/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HexEditorViewController.h"

@implementation HexEditorViewController
@synthesize sendHex,receivedHex;

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

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactTableUpdate:) name:@"hexReceived" object:nil];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hexReceived" object:nil];
    [super viewWillDisappear:animated];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    FrameID = 1;
    [super viewDidLoad];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (sendHex.editing){
        [sendHex resignFirstResponder];
        [super touchesBegan:touches withEvent:event];
    }
}

-(IBAction)resignKeyboard:(id)sender{
    [sender resignFirstResponder];
}

- (void)viewDidUnload
{
    sendHex = nil;
    receivedHex = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)hexReceived:(NSNotification *)notification
{
    
    // Retrieve information about the document and update the panel
}


- (IBAction)sendHexMessage:(id)sender {
    XbeeTx *XbeeObj = [XbeeTx new];
    [XbeeObj TxRawApi:self.sendHex.text];
    NSArray *sendPacket = [XbeeObj txPacket];
    for ( int i = 0; i < (int)[sendPacket count]; i++ ) {
        txBuffer[i] = [[sendPacket objectAtIndex:i] unsignedIntValue];
    }
    int bytesWritten = [rscMgr write:txBuffer Length:[sendPacket count]];
    
}
@end
