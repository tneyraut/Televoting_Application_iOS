//
//  IdentificationView.m
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 15/03/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "IdentificationView.h"
#import "ListeCoursView.h"

@interface IdentificationView ()

@end

@implementation IdentificationView

- (void) initialisationView {
    [self.navigationItem setTitle:@"Accueil"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, (self.view.frame.size.height - self.view.frame.size.width + 30.0f) / 2, self.view.frame.size.width - 30.0f, self.view.frame.size.width - 30.0f)];
    [imageView setImage:[UIImage imageNamed:@"logoEcole.png"]];
    
    UIBarButtonItem *buttonConnexion = [[UIBarButtonItem alloc] initWithTitle:@"Connexion" style:UIBarButtonItemStyleDone target:self action:@selector(actionListenerButtonConnexion)];
    [self.navigationItem setRightBarButtonItem:buttonConnexion];
    
    [buttonConnexion setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    [self.view addSubview:imageView];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Accueil" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
    
    self.sauvegardeIdentifiants = [NSUserDefaults standardUserDefaults];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
}

- (void) connexion
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    
    [alertView setTitle:@"Connexion"];
    [alertView setMessage:@"Veuillez rentrer vos identifiants pour vous connecter."];
    [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [alertView addButtonWithTitle:@"Se connecter"];
    
    UITextField *loginTextField = [alertView textFieldAtIndex:0];
    UITextField *passwordTextField = [alertView textFieldAtIndex:1];
    
    [loginTextField setPlaceholder:@"login"];
    [passwordTextField setPlaceholder:@"password"];
    [passwordTextField setSecureTextEntry:YES];
    
    [alertView setDelegate:self];
    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Se connecter"])
    {
        [self.sauvegardeIdentifiants setObject:[[alertView textFieldAtIndex:0] text] forKey:@"login"];
        [self.sauvegardeIdentifiants setObject:[[alertView textFieldAtIndex:1] text] forKey:@"password"];
        [self.sauvegardeIdentifiants synchronize];
        
        ListeCoursView *listeCoursView = [[ListeCoursView alloc] initWithStyle:UITableViewStylePlain];
        listeCoursView.login = [self.sauvegardeIdentifiants objectForKey:@"login"];
        listeCoursView.password = [self.sauvegardeIdentifiants objectForKey:@"password"];
        listeCoursView.identificationView = self;
        listeCoursView.demandeIdentification = YES;
        
        [self.navigationController pushViewController:listeCoursView animated:YES];
    }
}

- (void) actionListenerButtonConnexion
{
    if ([[self.sauvegardeIdentifiants objectForKey:@"login"] isEqualToString:@""] || [[self.sauvegardeIdentifiants objectForKey:@"password"] isEqualToString:@""] || [self.sauvegardeIdentifiants objectForKey:@"login"] == nil || [self.sauvegardeIdentifiants objectForKey:@"password"] == nil)
    {
        [self connexion];
    }
    else
    {
        ListeCoursView *listeCoursView = [[ListeCoursView alloc] initWithStyle:UITableViewStylePlain];
        listeCoursView.login = [self.sauvegardeIdentifiants objectForKey:@"login"];
        listeCoursView.password = [self.sauvegardeIdentifiants objectForKey:@"password"];
        listeCoursView.identificationView = self;
        listeCoursView.demandeIdentification = YES;
        
        [self.navigationController pushViewController:listeCoursView animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialisationView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    [self.navigationController.toolbar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    UIBarButtonItem *buttonTitle = [[UIBarButtonItem alloc] initWithTitle:@"Mines de douai : Televoting"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:nil
                                                                   action:nil];
    
    [buttonTitle setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    
    [self.navigationController.toolbar setItems:@[ flexibleSpace, buttonTitle, flexibleSpace ]];
    
    [super viewDidAppear:animated];
}

@end
