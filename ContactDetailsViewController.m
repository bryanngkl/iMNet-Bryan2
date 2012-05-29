//
//  ContactDetailsViewController.m
//  iMNet Bryan2
//
//  Created by Bryan on 13/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactDetailsViewController.h"

@implementation ContactDetailsViewController

@synthesize managedObjectContext;
@synthesize currentContact;
@synthesize addr16,addr64,username;
@synthesize rscMgr;

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
{
    [super viewDidLoad];
    self.addr16.text = currentContact.address16;
    self.addr64.text = currentContact.address64;
    self.username.text = currentContact.username;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (username.editing){
        [username resignFirstResponder];
        [super touchesBegan:touches withEvent:event];
    }
    if (addr16.editing){
        [addr16 resignFirstResponder];
        [super touchesBegan:touches withEvent:event];
    }
    if (addr64.editing){
        [addr64 resignFirstResponder];
        [super touchesBegan:touches withEvent:event];
    }
}
-(IBAction)resignKeyboard:(id)sender{
    [sender resignFirstResponder];
}


- (void)viewDidUnload
{
    username = nil;
    addr64 = nil;
    addr16 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"LoadContactToMessage"])
	{
        FirstViewController *firstViewController = segue.destinationViewController;
        firstViewController.currentContact = currentContact;
        firstViewController.managedObjectContext = managedObjectContext;
        firstViewController.rscMgr = rscMgr;
	}
    if ([segue.identifier isEqualToString:@"ContactDetailsToMessageLogSegue"])
	{
        MessageLogViewController *messageLogViewController = segue.destinationViewController;
        messageLogViewController.currentContact = currentContact;
        messageLogViewController.managedObjectContext = managedObjectContext;
	}
}

@end
