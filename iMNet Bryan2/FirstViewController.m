
//
//  FirstViewController.m
//  iMNet Bryan2
//
//  Created by Bryan on 13/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController

@synthesize managedObjectContext, txBufferArray;
@synthesize receivedMessage, sendMessage, username, addr16,addr64,receivedHexMessage;
@synthesize rscMgr;
@synthesize currentContact;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.username.text = currentContact.username;
    self.addr16.text = currentContact.address16;
    self.addr64.text = currentContact.address64;
    

    
    //initialise FrameID counter;
    FrameID = 1;
    [rscMgr setDelegate:self];
}
- (void)viewDidUnload
{
    receivedMessage = nil;
    username = nil;
    addr64 = nil;
    addr16 = nil;
    sendMessage = nil;
    [self setSendMessage:nil];
    receivedHexMessage = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
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
    if (receivedMessage.editing){
        [receivedMessage resignFirstResponder];
        [super touchesBegan:touches withEvent:event];
    }
    if (receivedHexMessage.editing){
        [receivedHexMessage resignFirstResponder];
        [super touchesBegan:touches withEvent:event];
    }

    if (sendMessage.editing){
        [sendMessage resignFirstResponder];
        [super touchesBegan:touches withEvent:event];
    }
}


-(IBAction)resignKeyboard:(id)sender{
    [sender resignFirstResponder];
}

- (IBAction)sendMessage:(id)sender {
    //This function takes the text string from send message and sends it to the address specified by the 64 bit address field
    NSFetchRequest *fetchContacts = [[NSFetchRequest alloc] init];
    NSEntityDescription *contactsEntity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:managedObjectContext];
    [fetchContacts setEntity:contactsEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"address64 == %@",self.addr64.text];
    [fetchContacts setPredicate:predicate];
    
    NSError *error = nil;
    Contacts *fetchedContact = [[managedObjectContext executeFetchRequest:fetchContacts error:&error] lastObject];
    
    //create tx packet
    XbeeTx *XbeeObj = [XbeeTx new];
    
    [XbeeObj TxMessage:self.sendMessage.text ofSize:0 andMessageType:1 withStartID:FrameID withFrameID:FrameID withPacketFrameId:FrameID withDestNode64:[[hexConvert alloc] convertStringToArray:[fetchedContact address64]] withDestNetworkAddr16:[[hexConvert alloc] convertStringToArray:[fetchedContact address16]]];
    self.username.text = [fetchedContact username];
    //write bytes from tx packet to serial cable
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



#pragma mark - RscMgrDelegate methods
- (void) cableConnected:(NSString *)protocol { 
    portConfig.baudLo = DEFAULT_BAUD;
    portConfig.baudHi = DEFAULT_BAUD;
    portConfig.dataLen = DEFAULT_SERIAL_DATABITS;
    portConfig.stopBits = DEFAULT_STOPBITS;
    portConfig.txFlowControl = TXFLOW_CTS;
    portConfig.rxFlowControl = DEFAULT_RXFLOW;
    portConfig.xonChar = DEFAULT_XON_CHAR;
    portConfig.xoffChar = DEFAULT_XOFF_CHAR;
    portConfig.rxForwardingTimeout = DEFAULT_RXFORWARDTIME;
    portConfig.rxForwardCount = DEFAULT_RXFORWARDCOUNT;
    portConfig.txAckSetting = DEFAULT_TXACKSETTING;
    [rscMgr setPortConfig:&portConfig RequestStatus:NO];
    [rscMgr setBaud:57600];
    
    [rscMgr open]; 
}

- (void) cableDisconnected { }


- (void) portStatusChanged { 
    
    [rscMgr getPortStatus:&portStatus];     //get entire port status to determine what has changed
    if (!(portStatus.txAck==0)) {          //if buffer is empty
        if (!(portStatus.rxFlowStat&TXFLOW_CTS)==TXFLOW_CTS) {  //if xbee is ready to receive bytes
            if ([txBufferArray count] > 0) {        //if the iPhone packet buffer contains packets
                NSMutableArray *txBufArrayTemp = [[NSMutableArray alloc] initWithArray:txBufferArray];  //init with packet buffer
                int count = [[txBufArrayTemp objectAtIndex:0] count];
                for ( int i = 0; i < count; i++ ) {
                    txBuffer[i] = [[[txBufArrayTemp objectAtIndex:0] objectAtIndex:i] unsignedIntValue];
                }
                [txBufArrayTemp removeObjectAtIndex:0];     //remove object that will be sent
                txBufferArray = txBufArrayTemp;         //update iphone packet buffer
                int bytesWritten = [rscMgr write:txBuffer Length:count];
            }
        }
    }
}

- (BOOL) rscMessageReceived:(UInt8 *)msg TotalLength:(int)len { 
    return FALSE;
}


- (void) didReceivePortConfig { }



//This function is called everytime bytes are available from the serial cable. It stores and sorts the incoming data accordingly
- (void) readBytesAvailable:(UInt32)numBytes {

    int bytesRead = [rscMgr read:rxBuffer Length:numBytes]; 

    NSMutableArray *rxPackBuf;
    
    if ([rxPacketBuffer count] == 0){
        rxPackBuf = [[NSMutableArray alloc] initWithCapacity:1];    //if empty, initialise array
    }
    else{
        rxPackBuf = [[NSMutableArray alloc] initWithArray:rxPacketBuffer];  //if not empty, initialise array with previous received bytes
    }
    
    for (int i = 0; i < numBytes; ++i) {
        [rxPackBuf addObject:[NSNumber numberWithUnsignedChar:rxBuffer[i]]];
        self.receivedHexMessage.text = [NSString stringWithFormat:@"%@%.2x",self.receivedHexMessage.text, rxBuffer[i]];
    }

    int packetLength = [[rxPackBuf objectAtIndex:1] unsignedIntValue] + [[rxPackBuf objectAtIndex:2] unsignedIntValue] + 4;
    // calculate length of entire packet


    
    if ([rxPackBuf count] >= packetLength) {
         NSIndexSet *onePacketIndexes = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, packetLength)];
         NSMutableArray  *rxOnePacket = [[NSMutableArray alloc] initWithArray:[rxPackBuf objectsAtIndexes:onePacketIndexes]];
         [rxPackBuf removeObjectsAtIndexes:onePacketIndexes];
         
        
        
        rxPacketBuffer = rxPackBuf;     //save the remainding bytes of packbuf for the next packet
                

        XbeeRx *XbeeRxObj = [XbeeRx new];
        [XbeeRxObj createRxInfo:rxOnePacket];   //load bytes into xbee receive object

        switch ([[XbeeRxObj frametype] unsignedIntValue]) {     //sort out frametypes
            case 136:    //frame is a zigbee receive AT command packet
                //if node discover packet received
                if (([[XbeeRxObj AT1] unsignedIntValue] == 78) && [[XbeeRxObj AT2] unsignedIntValue] == 68 ) {
                
                    NSFetchRequest *fetchContacts = [[NSFetchRequest alloc] init];
                    NSEntityDescription *contactsEntity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:managedObjectContext];
                    [fetchContacts setEntity:contactsEntity];
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"address64 == %@",[XbeeRxObj sourceAddr64HexString]];
                    [fetchContacts setPredicate:predicate];
                    
                    NSError *error = nil;
                    
                    Contacts *fetchedResult = [[managedObjectContext executeFetchRequest:fetchContacts error:&error] lastObject];
                    
                    if (!fetchedResult) {
                        //This method creates a new contact.
                        Contacts *newContact = (Contacts *)[NSEntityDescription insertNewObjectForEntityForName:@"Contacts" inManagedObjectContext:managedObjectContext];
                        
                        [newContact setAddress16:[XbeeRxObj sourceAddr16HexString]];
                        [newContact setAddress64:[XbeeRxObj sourceAddr64HexString]];
                        [newContact setUsername:[XbeeRxObj nodeidentifier]];
                        [newContact setIsAvailable:[NSNumber numberWithBool:TRUE]];
                        NSError *error = nil;
                        if (![managedObjectContext save:&error]) {
                            // Handle the error.
                        }
                    }
                    else{
                        [fetchedResult setAddress16:[XbeeRxObj sourceAddr16HexString]];
                        [fetchedResult setUsername:[XbeeRxObj nodeidentifier]];
                        [fetchedResult setIsAvailable:[NSNumber numberWithBool:TRUE]];
                        NSError *error = nil;
                        if (![managedObjectContext save:&error]) {
                            // Handle the error.
                        }
                    }

                    [[NSNotificationCenter defaultCenter] postNotificationName:@"contactUpdated" object:self];
                    }
                                    
                //if ATNI packet received
                else if([[XbeeRxObj ATString] isEqualToString:@"NI"]||[[XbeeRxObj ATString] isEqualToString:@"ID"]){                    
                    
                    if ([[XbeeRxObj ATCommandResponse] length] > 0) {
                        
                        NSFetchRequest *fetchOwnSettings = [[NSFetchRequest alloc] init];
                        NSEntityDescription *ownSettingsEntity = [NSEntityDescription entityForName:@"OwnSettings" inManagedObjectContext:managedObjectContext];
                        [fetchOwnSettings setEntity:ownSettingsEntity];
                        
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"atCommand == %@",[XbeeRxObj ATString]];
                        [fetchOwnSettings setPredicate:predicate];
                        
                        NSError *error = nil;
                        OwnSettings *fetchedSettings = [[managedObjectContext executeFetchRequest:fetchOwnSettings error:&error] lastObject];
                        
                        if (!fetchedSettings) {
                            //This method creates a new setting.
                            OwnSettings *newSettings = (OwnSettings *)[NSEntityDescription insertNewObjectForEntityForName:@"OwnSettings" inManagedObjectContext:managedObjectContext];
                            
                            [newSettings setAtCommand:[XbeeRxObj ATString]];
                            [newSettings setAtSetting:[XbeeRxObj ATCommandResponse]];
                            
                            NSError *error = nil;
                            if (![managedObjectContext save:&error]) {
                                // Handle the error.
                            }
                        }
                        else{
                            fetchedSettings.atCommand = [XbeeRxObj ATString];
                            fetchedSettings.atSetting = [XbeeRxObj ATCommandResponse];
                            NSError *error = nil;
                            if (![managedObjectContext save:&error]) {
                                // Handle the error.
                            }
                        }
                    }                        
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"optionsTableUpdate" object:self];

                }
                
                
                    //if ATSL or ATSH or ATMY packet received
                else if(([[XbeeRxObj ATString] isEqualToString:@"SL"])||([[XbeeRxObj ATString] isEqualToString:@"SH"])||([[XbeeRxObj ATString] isEqualToString:@"MY"])){
                    
                        if ([[XbeeRxObj ATCommandResponse] length] > 0) {
                            
                        NSFetchRequest *fetchOwnSettings = [[NSFetchRequest alloc] init];
                        NSEntityDescription *ownSettingsEntity = [NSEntityDescription entityForName:@"OwnSettings" inManagedObjectContext:managedObjectContext];
                        [fetchOwnSettings setEntity:ownSettingsEntity];
                        
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"atCommand == %@",[XbeeRxObj ATString]];
                        [fetchOwnSettings setPredicate:predicate];
                        
                        NSError *error = nil;
                        OwnSettings *fetchedSettings = [[managedObjectContext executeFetchRequest:fetchOwnSettings error:&error] lastObject];
                        
                        if (!fetchedSettings) {
                            //This method creates a new setting.
                            OwnSettings *newSettings = (OwnSettings *)[NSEntityDescription insertNewObjectForEntityForName:@"OwnSettings" inManagedObjectContext:managedObjectContext];
                            
                            [newSettings setAtCommand:[XbeeRxObj ATString]];
                            [newSettings setAtSetting:[XbeeRxObj ATCommandResponseHex]];
                    
                            NSError *error = nil;
                            if (![managedObjectContext save:&error]) {
                                // Handle the error.
                            }
                        }
                        else{
                            fetchedSettings.atCommand = [XbeeRxObj ATString];
                            fetchedSettings.atSetting = [XbeeRxObj ATCommandResponseHex];
                            NSError *error = nil;
                            if (![managedObjectContext save:&error]) {
                                // Handle the error.
                            }
                        }
                        }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"optionsTableUpdate" object:self];

                    }
            
                
                
                break;
                
            case 139:{     //frame is a transmit request acknowledgement
                
                if ([[XbeeRxObj ack] unsignedIntValue] == 0){
                    self.receivedMessage.text = [NSString stringWithFormat:@"Message sent to %@ with %d retries",[XbeeRxObj sourceAddr16HexString], [[XbeeRxObj retries] unsignedIntValue]] ;
                }
                else {
                    self.receivedMessage.text = [NSString stringWithFormat:@"Message to %@ not successful",[XbeeRxObj sourceAddr16HexString]];
                }
           
            break;
            }
                
            case 144:       //frame is a zigbee receive packet
            {
                
                NSFetchRequest *fetchContacts = [[NSFetchRequest alloc] init];
                NSEntityDescription *contactsEntity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:managedObjectContext];
                [fetchContacts setEntity:contactsEntity];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"address64 == %@",[XbeeRxObj sourceAddr64HexString]];
                [fetchContacts setPredicate:predicate];
                
                NSError *error = nil;
                Contacts *fetchedResult = [[managedObjectContext executeFetchRequest:fetchContacts error:&error] lastObject];
                
                    if ([XbeeRxObj msgType] == 1) {
                       
                        //output received text message into receivemsg.text
                        NSMutableString *rxMessage = [[NSMutableString alloc] initWithCapacity:2];
                        for (int i =0; i<[[XbeeRxObj receiveddata] count]; i++) {
                            [rxMessage appendString:[NSString stringWithFormat:@"%c",[[[XbeeRxObj receiveddata] objectAtIndex:i]    unsignedIntValue]]];
                        }
                        self.receivedMessage.text = rxMessage;
                        self.addr16.text = [XbeeRxObj sourceAddr16HexString];
                        self.addr64.text = [XbeeRxObj sourceAddr64HexString];
                        self.username.text = [XbeeRxObj nodeidentifier];
                        
                        if (!fetchedResult){
                            //This method creates a new contact.
                            Contacts *newContact = (Contacts *)[NSEntityDescription insertNewObjectForEntityForName:@"Contacts" inManagedObjectContext:managedObjectContext];
                            newContact.address16 = [XbeeRxObj sourceAddr16HexString];
                            newContact.address64 = [XbeeRxObj sourceAddr64HexString];
                            newContact.username = @"Unknown";
                            newContact.isAvailable = [NSNumber numberWithBool:TRUE];
                            
                            Messages *newMessage = (Messages *)[NSEntityDescription insertNewObjectForEntityForName:@"Messages" inManagedObjectContext:managedObjectContext];
                            newMessage.messageContents = rxMessage;
                            newMessage.messageReceived = [NSNumber numberWithBool:TRUE];
                            newMessage.messageDate = [NSDate date];
                            newMessage.messageFromContact = newContact;
                            }
                        else{
                            fetchedResult.address16 = [XbeeRxObj sourceAddr16HexString];
                            fetchedResult.isAvailable = [NSNumber numberWithBool:YES];
                            
                            Messages *newMessage = (Messages *)[NSEntityDescription insertNewObjectForEntityForName:@"Messages" inManagedObjectContext:managedObjectContext];
                            
                            [newMessage setMessageContents:[[NSString alloc] initWithString:rxMessage]];
                            [newMessage setMessageReceived:[NSNumber numberWithBool:YES]];
                            [newMessage setMessageFromContact:fetchedResult];
                            [newMessage setMessageDate:[NSDate date]];
                        }
                        NSError *error = nil;
                        if (![managedObjectContext save:&error]) {
                            // Handle the error.
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"messageReceived" object:self];

                   
                    }  /*
                    else if ([XbeeRxObj msgType] == 2) {
                        //If output is a picture
                    
                        NSMutableArray *rxBufArrayTemp = [[NSMutableArray alloc] initWithArray:rxBufferArray];
                        [rxBufArrayTemp addObject:[XbeeRxObj receiveddata]];    //add received packet to buffer
                    
                    
                        if ([rxBufArrayTemp count]==(1+[XbeeRxObj endID]-[XbeeRxObj startID])) {
                            int numberOfBytes = 0;
                            for (int i = 0; i<[rxBufArrayTemp count]; i++) {
                                numberOfBytes = numberOfBytes + [[rxBufArrayTemp objectAtIndex:i] count];
                            }
                            char rxBufferChar[numberOfBytes];
                            int counter = 0;
                            for (int i = 0; i < [rxBufArrayTemp count]; i++) {
                                for (int j = 0; j<[[rxBufArrayTemp objectAtIndex:i] count]; j++) {
                                    rxBufferChar[counter] = [[[rxBufArrayTemp objectAtIndex:i] objectAtIndex:j] unsignedCharValue];
                                    counter = counter + 1;
                                }
                            }                        
                        
                            NSData *imageData = [[NSData alloc] initWithBytes:rxBufferChar length:numberOfBytes];
                            UIImage *picture = [[UIImage alloc] initWithData:imageData];     //display picture
                            
                            [rxBufArrayTemp removeAllObjects];
                            rxBufferArray = rxBufArrayTemp;
                        }
                        else{
                            rxBufferArray = rxBufArrayTemp;
                        }*/
                        else if ([XbeeRxObj msgType] == 3){
                            NSMutableString *rxMessage = [[NSMutableString alloc] initWithCapacity:[[XbeeRxObj receiveddata] count]];
                            for (int i =0; i<[[XbeeRxObj receiveddata] count]; i++) {
                                [rxMessage appendString:[NSString stringWithFormat:@"%c",[[[XbeeRxObj receiveddata] objectAtIndex:i] unsignedIntValue]]];
                            }                    
                            
                            NSString *separator = @"*";
                            NSArray *receivedstrings = [rxMessage componentsSeparatedByString:separator];
                            NSString *title = [receivedstrings objectAtIndex:0];
                            NSString *description = [receivedstrings objectAtIndex:1];
                            NSString *location = [receivedstrings objectAtIndex:2];
                            NSLog(@"The received information are title = %@ with description = %@ and location = %@", title, description, location);
                            
                            //USING CORE DATA
                            NSFetchRequest *fetchLocation = [[NSFetchRequest alloc] init];
                            NSEntityDescription *locationEntity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext];
                            [fetchLocation setEntity:locationEntity];
                            
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationTitle == %@", title];
                            [fetchLocation setPredicate:predicate];
                            
                            NSError *error = nil;
                            Location *fetchedResult = [[managedObjectContext executeFetchRequest:fetchLocation error:&error] lastObject];
                            
                            if (!fetchedResult) {
                                //create new Location
                                Location *newLocation = (Location *) [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:managedObjectContext];
                                newLocation.locationTitle = title;
                                newLocation.locationDescription = description;
                                newLocation.locationLatitude = location;
                                // newLocation.locationLongitude = NULL;
                                NSError *error = nil;
                                //[managedObjectContext save:&error ];
                                if (![managedObjectContext save:&error]) {
                                    // Handle the error.
                                }
                            }
                            else{
                                fetchedResult.locationDescription = description;
                                fetchedResult.locationLatitude = location;
                                NSError *error = nil;
                                if (![managedObjectContext save:&error]) {
                                    // Handle the error.
                                }
                            }
                    }
            
                break;}
            default:
                break;
        }
        
    }
    else{
        rxPacketBuffer = rxPackBuf;
    }

}





@end
