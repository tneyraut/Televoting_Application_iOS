//
//  ListeCoursView.m
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 15/03/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "ListeCoursView.h"

#import "Cours.h"
#import "User.h"

#import "ListeQuestionnairesView.h"
#import "ListeQuestionnairesResultatTableViewController.h"
#import "ProfListeQuestionnairesTableViewController.h"
#import "ProfListeElevesTableViewController.h"
#import "ListeQuestionsEleveView.h"

#import "SpecificTableViewCell.h"

@interface ListeCoursView () <UIActionSheetDelegate, UISearchBarDelegate>

@property(nonatomic,strong) CoursModel* _coursModel;
@property(nonatomic,strong) NSArray* _feedItems;

@property(nonatomic,strong) ParticipantModel* _participantModel;

@property(nonatomic,strong) UserModel* _userModel;
@property(nonatomic,strong) NSArray* _userItems;

@property(nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic,strong) User *user;

@property(nonatomic) BOOL modeRepondre;

@property(nonatomic, strong) Cours *coursSelected;

@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic) BOOL research;

@property(nonatomic) UITapGestureRecognizer *singleFingerTap;

@end

@implementation ListeCoursView

- (void) initialisationView {
    
    [self.navigationItem setTitle:@"Liste des cours"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonDeconnexion = [[UIBarButtonItem alloc] initWithTitle:@"Déco" style:UIBarButtonItemStyleDone target:self action:@selector(actionListenerButtonDeconnexion)];
    
    [buttonDeconnexion setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    [self.navigationItem setRightBarButtonItem:buttonDeconnexion];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Liste des cours" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) actionListenerButtonDeconnexion
{
    [self.identificationView.sauvegardeIdentifiants setObject:@"" forKey:@"login"];
    [self.identificationView.sauvegardeIdentifiants setObject:@"" forKey:@"password"];
    
    [self.identificationView.sauvegardeIdentifiants synchronize];
    
    [self.navigationController popToViewController:self.identificationView animated:YES];
}

- (void) miseAJourParticipant:(int)userId annee:(int)uneAnnee {
    if (!self._participantModel)
    {
        self._participantModel = [[ParticipantModel alloc] init];
        self._participantModel.delegate = self;
    }
    [self._participantModel creationParticipant:userId uneAnnee:uneAnnee];
}

- (void) participantActionDone
{
}

- (void) verificationIdentifiant {
    if (!self._userModel)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self._userItems = [[NSArray alloc] init];
        self._userModel = [[UserModel alloc] init];
        
        self._userModel.delegate = self;
    }
    [self._userModel getUser:self.login pass:self.password];
}

- (void) getUserDownloaded: (NSArray*) items {
    self._userItems = items;
    if (items.count == 0) {
        [self.activityIndicatorView stopAnimating];
        
        [self.identificationView.sauvegardeIdentifiants setObject:@"" forKey:@"login"];
        [self.identificationView.sauvegardeIdentifiants setObject:@"" forKey:@"password"];
        
        [self.identificationView.sauvegardeIdentifiants synchronize];
        
        [self alert:@"Erreur" message:@"Identifiant et/ou password incorrecte(s)" button:@"OK"];
        [self.navigationController popToViewController:self.identificationView animated:YES];
    }
    else {
        self.user = self._userItems[0];
        
        if (!self.user.professeur)
        {
            [self miseAJourParticipant:self.user.user_id annee:self.user.annee];
            [self recuperationData:self.user.user_id];
        }
        else
        {
            [self getCoursProfesseur:self.user.user_id];
        }
    }
}

- (void) getCoursProfesseur:(int)user_id
{
    if (!self._coursModel)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self._feedItems = [[NSArray alloc] init];
        self._coursModel = [[CoursModel alloc] init];
        
        self._coursModel.delegate = self;
    }
    [self._coursModel getListeCoursProfesseur:user_id];
}

- (void) recuperationData:(int)userID {
    if (!self._coursModel)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self._feedItems = [[NSArray alloc] init];
        self._coursModel = [[CoursModel alloc] init];
        
        self._coursModel.delegate = self;
    }
    
    if (self.modeRepondre)
    {
        [self._coursModel getCoursAFaire:userID];
    }
    else
    {
        [self._coursModel getAllCoursByUser:userID];
    }
}

-(void)coursDownloaded:(NSArray *)items {
    [self.activityIndicatorView stopAnimating];
    
    self._feedItems = items;
    
    [self.tableView reloadData];
    
    if (items.count == 0)
    {
        if (!self.user.professeur)
        {
            [self alert:@"Information" message:@"Aucun cours n'a été enregistré ou n'est disponible pour votre année, ou vous avez déjà répondu à tous les questionnaires disponibles" button:@"OK"];
        }
        else
        {
            [self alert:@"Information" message:@"Aucun cours n'a été enregistré pour votre compte. Pour ajouter un cours veuillez contacter l'administrateur à l'adresse mail suivante thomas.neyraut@minesdedouai.fr" button:@"OK"];
        }
    }
    else if (self.research && ![self.searchBar.text isEqualToString:@""])
    {
        [self searchTableList];
    }
}

- (void) alert:(NSString *)titre message:(NSString *)contenu button:(NSString *)buttonTitle {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titre message:contenu delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil];
    [alert show];
}

- (void) boutonModeRepondreActionListener
{
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    self.modeRepondre = YES;
    
    [self.navigationController.toolbar setItems:[[NSArray alloc] init]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    UIBarButtonItem *buttonModeRepondre = [[UIBarButtonItem alloc] initWithTitle:@"Accès questions"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(boutonModeRepondreActionListener)];
    
    [buttonModeRepondre setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.6 green:1 blue:0.8 alpha:1], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *buttonModeResultat = [[UIBarButtonItem alloc] initWithTitle:@"Accès résultats"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(boutonModeResultatActionListener)];
    
    [buttonModeResultat setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    
    [self.navigationController.toolbar setItems:@[ buttonModeRepondre , flexibleSpace , buttonModeResultat ]];
    
    [self recuperationData:self.user.user_id];
}

- (void) boutonModeResultatActionListener
{
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    self.modeRepondre = NO;
    
    [self.navigationController.toolbar setItems:[[NSArray alloc] init]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    UIBarButtonItem *buttonModeRepondre = [[UIBarButtonItem alloc] initWithTitle:@"Accès questions"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(boutonModeRepondreActionListener)];
    
    [buttonModeRepondre setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *buttonModeResultat = [[UIBarButtonItem alloc] initWithTitle:@"Accès résultats"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(boutonModeResultatActionListener)];
    
    [buttonModeResultat setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.6 green:1 blue:0.8 alpha:1], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    
    [self.navigationController.toolbar setItems:@[ buttonModeRepondre , flexibleSpace , buttonModeResultat ]];
    
    [self recuperationData:self.user.user_id];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cellSearch"];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self initialisationView];
    
    if (self.demandeIdentification) {
        [self.activityIndicatorView startAnimating];
        
        [self verificationIdentifiant];
    }
    
    self.modeRepondre = YES;
    
    self.searchBar = [[UISearchBar alloc] init];
    
    self.searchBar.barTintColor = [UIColor whiteColor];
    
    self.searchBar.delegate = self;
    
    self.singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toucheDone)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    self.research = NO;
    
    if (self.user && !self.user.professeur)
    {
        [self.navigationController setToolbarHidden:NO animated:YES];
        
        [self.navigationController.toolbar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
        
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
        shadow.shadowOffset = CGSizeMake(0, 1);
        
        UIBarButtonItem *buttonModeRepondre = [[UIBarButtonItem alloc] initWithTitle:@"Accès questions"
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(boutonModeRepondreActionListener)];
        
        UIBarButtonItem *buttonModeResultat = [[UIBarButtonItem alloc] initWithTitle:@"Accès résultats"
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(boutonModeResultatActionListener)];
        
        if (self.modeRepondre)
        {
            [buttonModeRepondre setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.6 green:1 blue:0.8 alpha:1], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
            
            [buttonModeResultat setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
        }
        
        else
        {
            [buttonModeRepondre setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
            
            [buttonModeResultat setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.6 green:1 blue:0.8 alpha:1], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
        }
    
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
        
        [self.navigationController.toolbar setItems:@[ buttonModeRepondre , flexibleSpace , buttonModeResultat ]];
    }
    else
    {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
        
    if (self.user)
    {
        [self.activityIndicatorView startAnimating];
        
        if (!self.user.professeur)
        {
            [self miseAJourParticipant:self.user.user_id annee:self.user.annee];
            [self recuperationData:self.user.user_id];
        }
        else
        {
            [self getCoursProfesseur:self.user.user_id];
        }
    }
    
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self._feedItems.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 40.0f;
    }
    return 75.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
    {
        SpecificTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellSearch" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.searchBar setFrame:CGRectMake(15.0f, (cell.frame.size.height - 30.0f) / 2, cell.frame.size.width - 30.0f, 30.0f)];
        
        [cell addSubview:self.searchBar];
        
        return cell;
    }
    
    SpecificTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Cours* item = self._feedItems[indexPath.row - 1];
    
    [cell.textLabel setText: item.cours_name];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    [cell.imageView setImage:[UIImage imageNamed:@"iconCours.png"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.activityIndicatorView isAnimating] || indexPath.row == 0)
    {
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    Cours *cours = self._feedItems[indexPath.row - 1];
    
    self.coursSelected = cours;
    
    if (!self.user.professeur)
    {
        if (self.modeRepondre)
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:cours.cours_name delegate:self cancelButtonTitle:@"Annuler"   destructiveButtonTitle:nil otherButtonTitles:@"Liste des questionnaires", @"Liste des questions des élèves", nil];
            
            [self.activityIndicatorView stopAnimating];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                [actionSheet showFromToolbar:self.navigationController.toolbar];
            }
            else
            {
                [actionSheet showInView:self.view];
            }
        }
        else
        {
            ListeQuestionnairesResultatTableViewController *listeQuestionnairesResultatTableViewController = [[ListeQuestionnairesResultatTableViewController alloc] initWithStyle:UITableViewStylePlain];
            
            listeQuestionnairesResultatTableViewController.user_id = self.user.user_id;
            listeQuestionnairesResultatTableViewController.cours_id = self.coursSelected.cours_id;
            
            [self.activityIndicatorView stopAnimating];
            
            [self.navigationController pushViewController:listeQuestionnairesResultatTableViewController animated:YES];
        }
    }
    
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:cours.cours_name delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:@"Liste des questionnaires", @"Liste des questions des élèves", @"Liste des élèves", nil];
        
        [self.activityIndicatorView stopAnimating];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [actionSheet showFromToolbar:self.navigationController.toolbar];
        }
        else
        {
            [actionSheet showInView:self.view];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //@"Liste des questionnaires"
        if (self.user.professeur)
        {
            ProfListeQuestionnairesTableViewController *profListeQuestionnairesTableViewController = [[ProfListeQuestionnairesTableViewController alloc] initWithStyle:UITableViewStylePlain];
            
            profListeQuestionnairesTableViewController.coursSelected = self.coursSelected;
            
            [self.navigationController pushViewController:profListeQuestionnairesTableViewController animated:YES];
        }
        else
        {
            ListeQuestionnairesView *listeQuestionnairesView = [[ListeQuestionnairesView alloc] initWithStyle:UITableViewStylePlain];
            
            listeQuestionnairesView.user_id = self.user.user_id;
            listeQuestionnairesView.cours_id = self.coursSelected.cours_id;
            
            [self.activityIndicatorView stopAnimating];
            
            [self.navigationController pushViewController:listeQuestionnairesView animated:YES];
        }
    }
    else if (buttonIndex == 2 && ![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Annuler"])
    {
        //@"Liste des élèves"
        
        ProfListeElevesTableViewController *profListeElevesTableViewController = [[ProfListeElevesTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        profListeElevesTableViewController.coursSelected = self.coursSelected;
        profListeElevesTableViewController.listeCoursView = self;
        
        [self.navigationController pushViewController:profListeElevesTableViewController animated:YES];
    }
    else if (buttonIndex == 1)
    {
        //@"Liste des questions des élèves"
        
        ListeQuestionsEleveView *listeQuestionsEleveView = [[ListeQuestionsEleveView alloc] initWithStyle:UITableViewStylePlain];
        
        listeQuestionsEleveView.coursSelected = self.coursSelected;
        listeQuestionsEleveView.user = self.user;
        
        [self.navigationController pushViewController:listeQuestionsEleveView animated:YES];
    }
}

- (void) searchTableList
{
    [self.activityIndicatorView startAnimating];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    BOOL elementFound = NO;
    
    for (int i=0;i<self._feedItems.count;i++)
    {
        Cours *cours = [self._feedItems objectAtIndex:i];
        
        if ([cours.cours_name rangeOfString:self.searchBar.text].location != NSNotFound)
        {
            elementFound = YES;
            
            [array addObject:cours];
        }
    }
    
    if (elementFound)
    {
        self._feedItems = array;
        
        [self.tableView reloadData];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Aucun cours correspond à la recherche." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    
    [self.activityIndicatorView stopAnimating];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.view addGestureRecognizer:self.singleFingerTap];
    
    self.research = YES;
    
    [self.activityIndicatorView startAnimating];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view removeGestureRecognizer:self.singleFingerTap];
    
    if (!self.user.professeur)
    {
        [self recuperationData:self.user.user_id];
    }
    else
    {
        [self getCoursProfesseur:self.user.user_id];
    }
}

- (void) toucheDone
{
    self.research = NO;
    
    [self.view removeGestureRecognizer:self.singleFingerTap];
    
    [self.view endEditing:YES];
    
    if (!self.user.professeur)
    {
        [self recuperationData:self.user.user_id];
    }
    else
    {
        [self getCoursProfesseur:self.user.user_id];
    }
}

@end
