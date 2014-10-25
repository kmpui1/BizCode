//
//  NamecardDetailsViewController.m
//  Business Card
//
//  Created by Kar Mun Pui on 7/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import "NamecardDetailsViewController.h"

@interface NamecardDetailsViewController ()

@property (strong, nonatomic) NSArray *namecards;

@end

@implementation NamecardDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self useDocument];
    if (self.page == 1 || self.page == 3) {
        [self checkUpdate];
        [self displayNamecard];
    }

	// Do any additional setup after loading the view.
}

//Update the content every time appear the view
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self useDocument];
    [self performFetch];
    
    if(self.page == 2){
        [self checkUpdate];
        [self displayNamecard];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self performFetch];
    [super viewDidDisappear:animated];
}

-(void)useDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"NamecardDocument"];
    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        [self.document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = self.document.managedObjectContext;
            }
        }];
    }else if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = self.document.managedObjectContext;
            }
        }];
    }else {
        self.managedObjectContext = self.document.managedObjectContext;
    }
    
}

-(void)performFetch{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"NamecardData1"];
    self.namecards = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    [self performFetch];
}

-(void)setNamecards:(NSArray *)namecards{
    _namecards = namecards;
}

// search namecard details using id and name from the database server and load it into the screen.
-(void)displayNamecard
{
    
    NSString* nameSearch;
    NSString* idnumSearch;
    
    if (self.page == 3) {
        
        NSArray* qr = (NSArray*)self.qrstring;
        for (NSDictionary* foundQr in qr)
        {
            nameSearch = [foundQr objectForKey:@"Name"];
            idnumSearch = [foundQr objectForKey:@"ID"];
        }
        
    }
    else{
        nameSearch = self.namecardName;
        idnumSearch = self.namecardId;
    }

    
    NSString *rawStr = [NSString stringWithFormat:@"ID=%@&Name=%@", idnumSearch, nameSearch];
    
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"http://testforfun.noip.me:8080/loadSearch.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //parseJSON
    //displaying namecard details
    
    id json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    if(json == nil)
    {
        NSLog(@"Error parsing JSON:\n%@", err.userInfo);
        return;
    }
    
    if([json isKindOfClass:[NSArray class]])
    {
        NSArray* foundNamecard = (NSArray*)json;
        
        NSLog(@"Displaying %lu namecard!", (unsigned long)[foundNamecard count]);
        
        for (NSDictionary* namecard in foundNamecard)
        {
            [self.namecardTitleLabel setText:[NSString stringWithFormat:@"%@", [namecard objectForKey:@"Title"]]];
            [self.namecardNameLabel setText:[namecard objectForKey:@"Name"]];
            [self.namecardPositionLabel setText:[namecard objectForKey:@"Position"]];
            [self.namecardCompanyLabel setText:[namecard objectForKey:@"Company"]];
            [self.namecardEmailLabel setText:[namecard objectForKey:@"Email"]];
            [self.namecardPhoneLabel setText:[namecard objectForKey:@"Phone"]];
            [self.namecardAddressLabel setText:[namecard objectForKey:@"Address"]];
            //[self.idnumLabel setText:[NSString stringWithFormat:@"%@", [self.user valueForKey:@"idnum"]]];
        }
        
    }
    else
    {
        NSLog(@"Unexpected JSON format");
        return;
    }
    
    NSString *imageUrl = [NSString stringWithFormat:@"http://testforfun.noip.me:8080/imgForApp/%@.png", idnumSearch];
    
    NSLog(@"Show imageUrl: %@",imageUrl);
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
    self.image = self.imageView.image;

}

// check for updates from the database server and save it into persistent store
- (void)checkUpdate {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSString* nameSearch;
    NSString* idnumSearch;
    
    if (self.page == 3) {
        
        NSArray* qr = (NSArray*)self.qrstring;
        for (NSDictionary* foundQr in qr)
        {
            nameSearch = [foundQr objectForKey:@"Name"];
            idnumSearch = [foundQr objectForKey:@"ID"];
        }
        
    }
    else{
        nameSearch = self.namecardName;
        idnumSearch = self.namecardId;
    }
    
    NSString *rawStr = [NSString stringWithFormat:@"ID=%@&Name=%@", idnumSearch, nameSearch];
    
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"http://testforfun.noip.me:8080/saveSearch.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //parseJSON
    //check for updates before saving
    id json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    if(json == nil)
    {
        NSLog(@"Error parsing JSON:\n%@", err.userInfo);
        return;
    }
    
    if([json isKindOfClass:[NSArray class]])
    {
        NSArray* foundNamecard = (NSArray*)json;
        
        NSLog(@"Found %lu namecard!", (unsigned long)[foundNamecard count]);
        
        for (NSDictionary* namecard in foundNamecard)
        {
            
            if (self.page == 1) {
                
                //remove the old version
                
                NSManagedObjectContext *context = [self managedObjectContext];
                [context deleteObject:self.namecard];
                [self performFetch];
                
                NSError *error = nil;
                if (![context save:&error]) {
                    NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                    return;
                }
            }
            
            
            //Create a new version of the namecard
            NamecardData1 *newNamecard = [NSEntityDescription insertNewObjectForEntityForName:@"NamecardData1" inManagedObjectContext:context];
            [newNamecard setValue:[namecard objectForKey:@"Name"] forKey:@"name"];
            [newNamecard setValue:[NSNumber numberWithInteger:[[namecard objectForKey:@"ID"] integerValue]] forKey:@"identity"];
            [newNamecard setValue:[namecard objectForKey:@"Position"] forKey:@"position"];
            [newNamecard setValue:[namecard objectForKey:@"Company"] forKey:@"company"];
            NSLog(@"Updated %@, %@", [NSNumber numberWithInteger:[[namecard objectForKey:@"ID"] integerValue]], [namecard objectForKey:@"Company"]);
            
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                return;
            }


        }
        
        NSError *error = nil;
        
        //Save the object to persistent store
        if(![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        else {
            //Save context to file system
            [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"document saved ...");
                }
                else {
                    NSLog(@"document not saved ...");
                }
            }];
        }
        
    }
    else
    {
        NSLog(@"Unexpected JSON format");
        return;
    }
    
}

- (void)setImage:(UIImage *)image
{
    
    self.imageView.image = image;
    
}

- (UIImage *)image
{
    return self.imageView.image;
}

#pragma mark - Adding contact

- (ABRecordRef)addAccountWithFirstName:(NSString*)firstName Position:(NSString*)position Company:(NSString*)company Phone:(NSString*)phone Email:(NSString*)email  Image:(UIImage*)image inAddressBook:(ABAddressBookRef)addressBook
{
    ABRecordRef result = NULL;
    CFErrorRef error = NULL;
    
    //1
    result = ABPersonCreate();
    if (result == NULL) {
        NSLog(@"Failed to create a new person.");
        return NULL;
    }
    
    //2
    BOOL couldSetFirstName = ABRecordSetValue(result, kABPersonFirstNameProperty, (__bridge CFTypeRef)firstName, &error);
    BOOL couldSetPosition = ABRecordSetValue(result, kABPersonJobTitleProperty, (__bridge CFTypeRef)position, &error);
    BOOL couldSetCompany = ABRecordSetValue(result, kABPersonOrganizationProperty, (__bridge CFTypeRef)company, &error);
    
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge_retained CFDataRef)phone, kABPersonPhoneMobileLabel, NULL);
    BOOL couldSetPhone = ABRecordSetValue(result, kABPersonPhoneProperty, multiPhone, &error);
    CFRelease(multiPhone);
    
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail, (__bridge_retained CFDataRef)email, kABHomeLabel, NULL);
    BOOL couldSetEmail = ABRecordSetValue(result, kABPersonEmailProperty, multiEmail, &error);
    CFRelease(multiEmail);
    
    if (couldSetFirstName && couldSetPosition && couldSetCompany && couldSetPhone && couldSetEmail) {
        NSLog(@"Successfully set the details of the person.");
    } else {
        NSLog(@"Failed.");
    }
    
    //3
    BOOL couldAddPerson = ABAddressBookAddRecord(addressBook, result, &error);
    
    if (couldAddPerson) {
        NSLog(@"Successfully added the person.");
    } else {
        NSLog(@"Failed to add the person.");
        CFRelease(result);
        result = NULL;
        return result;
    }
    
    //4
    if (ABAddressBookHasUnsavedChanges(addressBook)) {
        BOOL couldSaveAddressBook = ABAddressBookSave(addressBook, &error);
        
        if (couldSaveAddressBook) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Contact Added." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            NSLog(@"Succesfully saved the address book.");
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Contact Not Added." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            NSLog(@"Failed.");
        }
    }
    
    return result;
}

- (IBAction)addContact:(id)sender {
    ABAddressBookRef addressBook = NULL;
    CFErrorRef error = NULL;
    
    switch (ABAddressBookGetAuthorizationStatus()) {
        case kABAuthorizationStatusAuthorized: {
            addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            
            [self addAccountWithFirstName:self.namecardNameLabel.text Position:self.namecardPositionLabel.text Company:self.namecardCompanyLabel.text Phone:self.namecardPhoneLabel.text Email:self.namecardEmailLabel.text  Image:self.image inAddressBook:addressBook];
            
            if (addressBook != NULL) CFRelease(addressBook);
            break;
        }
        case kABAuthorizationStatusDenied: {
            NSLog(@"Access denied to address book");
            break;
        }
        case kABAuthorizationStatusNotDetermined: {
            addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    NSLog(@"Access was granted");
                    [self addAccountWithFirstName:self.namecardNameLabel.text Position:self.namecardPositionLabel.text Company:self.namecardCompanyLabel.text Phone:self.namecardPhoneLabel.text Email:self.namecardEmailLabel.text  Image:self.image inAddressBook:addressBook];
                }
                else NSLog(@"Access was not granted");
                if (addressBook != NULL) CFRelease(addressBook);
            });
            break;
        }
        case kABAuthorizationStatusRestricted: {
            NSLog(@"access restricted to address book");
            break;
        }
    }
}

- (IBAction)done:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
