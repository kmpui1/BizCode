//
//  UserDetailsViewController.m
//  Business Card
//
//  Created by Kar Mun Pui on 6/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import "UserDetailsViewController.h"

@interface UserDetailsViewController ()

@property (strong, nonatomic) NSNumber *idnum;
@property (strong, nonatomic) NSArray *users;

@end

@implementation UserDetailsViewController 

//  To check whether the Photo Library is available in the device
+ (BOOL)canAddPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return YES;
        
    }
    return NO;
}

//Create and open a file to store object
-(void)useDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"UserDocument"];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    //When UITextfield is not active or when user tap at the background which is not a textfield, the keyboard will be dismissed
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
    [self useDocument];
    
    //when user added a profile and chose edit from the namecard view or when there is a profile for the user and user click on add button, the recent details will be presented in the textfield to allow user to edit or remain the same as it is.
    if (self.user && self.page == 2) {
        [self.nameTextField setText:[self.user valueForKey:@"name"]];
        [self.titleTextField setText:[self.user valueForKey:@"title"]];
        [self.companyTextField setText:[self.user valueForKey:@"company"]];
        [self.positionTextField setText:[self.user valueForKey:@"position"]];
        [self.phoneTextField setText:[self.user valueForKey:@"phone"]];
        [self.addressTextField setText:[self.user valueForKey:@"address"]];
        [self.emailTextField setText:[self.user valueForKey:@"email"]];
        self.idnum = [self.user valueForKey:@"idnum"];
        UIImage *image = [UIImage imageWithData:[self.user valueForKey:@"image"]];
        self.imageView.image = image;
    }
    else if(self.user && self.number == 1){
        [self.nameTextField setText:[self.user valueForKey:@"name"]];
        [self.titleTextField setText:[self.user valueForKey:@"title"]];
        [self.companyTextField setText:[self.user valueForKey:@"company"]];
        [self.positionTextField setText:[self.user valueForKey:@"position"]];
        [self.phoneTextField setText:[self.user valueForKey:@"phone"]];
        [self.addressTextField setText:[self.user valueForKey:@"address"]];
        [self.emailTextField setText:[self.user valueForKey:@"email"]];
        self.idnum = [self.user valueForKey:@"idnum"];
        UIImage *image = [UIImage imageWithData:[self.user valueForKey:@"image"]];
        self.imageView.image = image;
    }
	
}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; // make "return key" hide keyboard
    return YES;
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSString *name = self.nameTextField.text;
    NSString *title = self.titleTextField.text;
    NSString *position = self.positionTextField.text;
    NSString *company = self.companyTextField.text;
    NSString *address = self.addressTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *phone = self.phoneTextField.text;
    
    
    UIImage *image = self.imageView.image;
    
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    
    

    if (self.user) {
        [self.user setValue:name forKey:@"name"];
        [self.user setValue:title forKey:@"title"];
        [self.user setValue:position forKey:@"position"];
        [self.user setValue:company forKey:@"company"];
        [self.user setValue:address forKey:@"address"];
        [self.user setValue:email forKey:@"email"];
        [self.user setValue:phone forKey:@"phone"];
        [self.user setValue:imageData forKey:@"image"];
        [self updateDatabase];
    }
    else{
        //Create a new managed object
        Users *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
        [newUser setValue:name forKey:@"name"];
        [newUser setValue:title forKey:@"title"];
        [newUser setValue:position forKey:@"position"];
        [newUser setValue:company forKey:@"company"];
        [newUser setValue:address forKey:@"address"];
        [newUser setValue:email forKey:@"email"];
        [newUser setValue:phone forKey:@"phone"];
        [newUser setValue:imageData forKey:@"image"];
        
        [self insertToDatabase];
        [self performFetch];
        
        [self download];
        NSLog(@"The ID number is %@", self.idnum);
        [self performFetch];
        
        //add user id for reference in future
        //To convert NSString to NSNumber
        //Eg:
        //[NSNumber numberWithInteger:[theString integerValue]];
        //[NSNumber numberWithDouble:[theString doubleValue]];
        [newUser setValue:self.idnum forKey:@"idnum"];
        
        
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
    
    //upload/update image through ftp client (Black Raccoon)
    [self uploadToFTP];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)performFetch{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Users"];
    self.users = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    [self performFetch];
}

-(void)setUsers:(NSArray *)users{
    
    _users = users;
    
}

//For first time adding new user profile details to the database
-(void) insertToDatabase {
    
    NSString *name = self.nameTextField.text;
    NSString *title = self.titleTextField.text;
    NSString *position = self.positionTextField.text;
    NSString *company = self.companyTextField.text;
    NSString *address = self.addressTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *phone = self.phoneTextField.text;
    
    
    
    NSString *rawStr = [NSString stringWithFormat:@"Position=%@&Title=%@&Name=%@&Phone=%@&Company=%@&Address=%@&Email=%@",
                        position, title, name, phone, company, address, email];
    
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"http://testforfun.noip.me:8080/insert.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSString *responseString = [NSString stringWithUTF8String:[responseData bytes]];
    NSLog(@"%@", responseString);
    
    NSString *success = @"success";
    [success dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%lu", (unsigned long)responseString.length);
    NSLog(@"%lu", (unsigned long)success.length);
    

}

//getting the ID of the user from the database after adding new user profile
-(void)download
{
    
    NSString *name = self.nameTextField.text;
    NSString *title = self.titleTextField.text;
    NSString *position = self.positionTextField.text;
    NSString *company = self.companyTextField.text;
    NSString *address = self.addressTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *phone = self.phoneTextField.text;
    
    
    NSString *rawStr = [NSString stringWithFormat:@"Position=%@&Title=%@&Name=%@&Phone=%@&Company=%@&Address=%@&Email=%@",
                        position, title, name, phone, company, address, email];
    
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURL* url;
    url = [NSURL URLWithString:@"http://testforfun.noip.me:8080/service.php"];
    
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
        
        NSLog(@"Found %lu hhhhnamecard!", (unsigned long)[foundNamecard count]);
        
        for (NSDictionary* namecard in foundNamecard)
        {
            NSString* identity = [namecard objectForKey:@"ID"];
            //To convert NSString to NSNumber
            //Eg:
            //[NSNumber numberWithInteger:[theString integerValue]];
            //[NSNumber numberWithDouble:[theString doubleValue]];
            self.idnum = [NSNumber numberWithInteger:[identity integerValue]];
            NSLog(@"The ID is %@", self.idnum);
        }
        
        //self.userIdnum = self.idnum;
        
        NSError* error;
        if(![self.managedObjectContext save:&error]) {
            NSLog(@"Could not save downloaded monster data:\n%@", error.userInfo);
        }
    }
    else
    {
        NSLog(@"Unexpected JSON format");
        return;
    }
}

//  When user choose to edit the profile details, the database will be updated
-(void) updateDatabase
{
    NSString *name = self.nameTextField.text;
    NSString *title = self.titleTextField.text;
    NSString *position = self.positionTextField.text;
    NSString *company = self.companyTextField.text;
    NSString *address = self.addressTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *phone = self.phoneTextField.text;
    NSString *idnum = [self.user valueForKey:@"idnum"];
    
    NSString *rawStr = [NSString stringWithFormat:@"ID=%@&Position=%@&Title=%@&Name=%@&Phone=%@&Company=%@&Address=%@&Email=%@",
                        idnum, position, title, name, phone, company, address, email];
    
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"http://testforfun.noip.me:8080/update.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSString *responseString = [NSString stringWithUTF8String:[responseData bytes]];
    NSLog(@"%@", responseString);
    
    NSString *success = @"success";
    [success dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%lu", (unsigned long)responseString.length);
    NSLog(@"%lu", (unsigned long)success.length);
}

#pragma mark - UIImage

- (IBAction)addPhoto:(id)sender {
    
    UIImagePickerController *uiipc = [[UIImagePickerController alloc] init];
    uiipc.delegate = self;
    uiipc.mediaTypes = @[(NSString *)kUTTypeImage];
    uiipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    uiipc.allowsEditing = YES;
    
    [self presentViewController:uiipc animated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image)
        image = info[UIImagePickerControllerOriginalImage];
    self.image = image;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setImage:(UIImage *)image
{

    self.imageView.image = image;
    
    // when image is changed, we must delete files we've created (if any)
    //[[NSFileManager defaultManager] removeItemAtURL:_imageURL error:NULL];
    //[[NSFileManager defaultManager] removeItemAtURL:_thumbnailURL error:NULL];
    //self.imageURL = nil;
    //self.thumbnailURL = nil;
}

- (UIImage *)image
{
    return self.imageView.image;
}

#pragma mark - upload image to server

//Uploading the image to the ftp server
-(void)uploadToFTP
{
    
    //----- get the file path for the item we want to upload
    //NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString *filepath = [NSString stringWithFormat: @"%@/%@", applicationDocumentsDir, @"file.text"];
    
    UIImage *image = self.imageView.image;
    
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    
    //----- read the entire file into memory (small files only)
    //self.uploadData = [NSData dataWithContentsOfFile: filepath];
    self.uploadData = imageData;
    
    //----- create our upload object
    self.uploadFile = [[BRRequestUpload alloc] initWithDelegate: self];
    
    //----- for anonymous login just leave the username and password nil
    self.uploadFile.path = [NSString stringWithFormat:@"/%@.png", self.idnum];
    self.uploadFile.hostname = @"testforfun.noip.me:7001";
    self.uploadFile.username = @"admin";
    self.uploadFile.password = @"admin";
    
    //----- we start the request
    [self.uploadFile start];
}

-(BOOL) shouldOverwriteFileWithRequest: (BRRequest *) request
{
    //----- set this as appropriate if you want the file to be overwritten
    if (request == self.uploadFile)
    {
        //----- if uploading a file, we set it to YES
        return YES;
    }
    
    //----- anything else (directories, etc) we set to NO
    return NO;
}

- (NSData *) requestDataToSend: (BRRequestUpload *) request
{
    //----- returns data object or nil when complete
    //----- basically, first time we return the pointer to the NSData.
    //----- and BR will upload the data.
    //----- Second time we return nil which means no more data to send
    NSData *temp = self.uploadData;   // this is a shallow copy of the pointer
    
    self.uploadData = nil;            // next time around, return nil...
    
    return temp;
}

-(void) requestCompleted: (BRRequest *) request
{
    if (request == self.uploadFile)
    {
        NSLog(@"%@ completed!", request);
        self.uploadFile = nil;
    }
}

-(void) requestFailed:(BRRequest *) request
{
    if (request == self.uploadFile)
    {
        NSLog(@"%@", request.error.message);
        self.uploadFile = nil;
    }
}



@end
