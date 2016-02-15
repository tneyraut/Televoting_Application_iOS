//
//  ProfListeElevesTableViewController.m
//  Televoting
//
//  Created by Thomas Mac on 06/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "ProfListeElevesTableViewController.h"

#import "SpecificTableViewCell.h"
#import "Groupe.h"
#import "User.h"

@interface ProfListeElevesTableViewController () <UIAlertViewDelegate, UISearchBarDelegate>

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) GroupeModel *_groupeModel;

@property(nonatomic, strong) UserModel *_userModel;

@property(nonatomic, strong) AbsenceModel *_absenceModel;

@property(nonatomic, strong) RetardModel *_retardModel;

@property(nonatomic, strong) NSArray *elevesArray;
@property(nonatomic, strong) NSMutableDictionary *etatEleveArray;

@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic) BOOL research;

@property(nonatomic) UITapGestureRecognizer *singleFingerTap;

@end

@implementation ProfListeElevesTableViewController

- (void) initialisationView {
    
    [self.navigationItem setTitle:@"Liste des élèves"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Liste des élèves" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) getGroupe:(int)cours_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._groupeModel)
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self._groupeModel = [[GroupeModel alloc] init];
        self._groupeModel.delegate = self;
    }
    
    [self._groupeModel getListeGroupesByCours:cours_id];
}

- (void) groupesDownloaded:(NSArray *)items
{
    [self.activityIndicatorView stopAnimating];
    
    if (items.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:[[@"Aucun groupe d'élèves n'a été trouvé pour votre cours : " stringByAppendingString:self.coursSelected.cours_name] stringByAppendingString:@". Veuillez contacter l'administrateur si cette situation persiste."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    else
    {
        Groupe *groupe = [items objectAtIndex:0];
        
        [self getEleves:groupe.groupe_id];
    }
}

- (void) getEleves:(int)groupe_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._userModel)
    {
        self._userModel = [[UserModel alloc] init];
        self._userModel.delegate = self;
    }
    
    [self._userModel getListeElevesByGroupe:groupe_id];
}

- (void) getUserDownloaded:(NSArray *)items
{
    if (items.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:[[@"Aucun élève n'a été trouvé pour votre cours : " stringByAppendingString:self.coursSelected.cours_name] stringByAppendingString:@". Veuillez contacter l'administrateur si cette situation persiste."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self.activityIndicatorView stopAnimating];
        
        [alertView show];
    }
    else
    {
        self.elevesArray = [[NSArray alloc] init];
        
        self.elevesArray = items;
        
        if (!self.etatEleveArray)
        {
            self.etatEleveArray = [[NSMutableDictionary alloc] init];
            
            for (int i=0;i<items.count;i++)
            {
                User *eleve = [self.elevesArray objectAtIndex:i];
                
                [self.etatEleveArray setObject:[NSString stringWithFormat:@"%d", 0] forKey:[NSString stringWithFormat:@"%d", eleve.user_id]];
            }
        }
        
        [self.tableView reloadData];
        
        [self.activityIndicatorView stopAnimating];
        
        if (self.research && ![self.searchBar.text isEqualToString:@""])
        {
            [self searchTableList];
        }
    }
}

- (void) creerAbsence:(int)user_id cours_id:(int)cours_id date_value:(NSString *)date_value
{
    if (!self._absenceModel)
    {
        self._absenceModel = [[AbsenceModel alloc] init];
        self._absenceModel.delegate = self;
    }
    [self._absenceModel creationAbsence:user_id cours_id:cours_id date_value:date_value];
}

- (void) creerRetard:(int)user_id cours_id:(int)cours_id date_value:(NSString*)date_value
{
    if (!self._retardModel)
    {
        self._retardModel = [[RetardModel alloc] init];
        self._retardModel.delegate = self;
    }
    [self._retardModel creationRetard:user_id cours_id:cours_id date_value:date_value];
}

- (void) absencesDownloaded:(NSArray *)items
{
    
}

- (void) retardsDownloaded:(NSArray *)items
{
    
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
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    [self.navigationController.toolbar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    UIBarButtonItem *buttonValider = [[UIBarButtonItem alloc] initWithTitle:@"Valider les absents"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(buttonValiderActionListener)];
    
    [buttonValider setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    
    [self.navigationController.toolbar setItems:@[ flexibleSpace, buttonValider, flexibleSpace ]];
    
    [self getGroupe:self.coursSelected.cours_id];
    
    [super viewDidAppear:animated];
}

- (void) buttonValiderActionListener
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView setDelegate:self];
    
    [alertView setTitle:@"Validation pour l'envoi des présences"];
    [alertView setMessage:@"Êtes-vous sûr de vouloir valider ces présences ? Avant de valider les présences, veuillez rentrer l'horaire de la séance de cours correspondante."];
    
    [alertView addButtonWithTitle:@"Valider"];
    [alertView addButtonWithTitle:@"Annuler"];
    
    [[alertView textFieldAtIndex:0] setPlaceholder:@"Jour/Mois/Année (03/01/2015)"];
    
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    
    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Valider"])
    {
        NSString *date_value = [alertView textFieldAtIndex:0].text;
        
        if ([date_value isEqualToString:@""])
        {
            UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Champ date du cours incorrect : Veuillez rentrer une date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertError show];
            
            return;
        }
        
        NSString *dateRegEx = @"[0-3][0-9][/][0-1][0-9][/][2][0][1-9][0-9]";
        
        NSPredicate *dateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", dateRegEx];
        
        if (![dateTest evaluateWithObject:date_value])
        {
            UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Format du champ date incorrect. Format correct : Jour/Mois/Année (03/01/2015)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertError show];
            
            return;
        }
        
        for (int i=0;i<self.elevesArray.count;i++)
        {
            User *eleve = [self.elevesArray objectAtIndex:i];
            
            if ([[self.etatEleveArray objectForKey:[NSString stringWithFormat:@"%d", eleve.user_id]] intValue] == 1)
            {
                [self creerRetard:eleve.user_id cours_id:self.coursSelected.cours_id date_value:date_value];
            }
            else if ([[self.etatEleveArray objectForKey:[NSString stringWithFormat:@"%d", eleve.user_id]] intValue] == 2)
            {
                [self creerAbsence:eleve.user_id cours_id:self.coursSelected.cours_id date_value:date_value];
            }
        }
        
        [self.navigationController popToViewController:self.listeCoursView animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.elevesArray.count + 1;
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
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    User *eleve = [self.elevesArray objectAtIndex:(indexPath.row - 1)];
    
    NSString *etat = @"";
    
    NSString *imageName = @"";
    
    if ([[self.etatEleveArray objectForKey:[NSString stringWithFormat:@"%d", eleve.user_id]] intValue] == 0)
    {
        etat = @"Présent";
        
        imageName = @"iconElevePresent.png";
    }
    else if ([[self.etatEleveArray objectForKey:[NSString stringWithFormat:@"%d", eleve.user_id]] intValue] == 1)
    {
        etat = @"En retard";
        
        imageName = @"iconEleveRetard.png";
    }
    else if ([[self.etatEleveArray objectForKey:[NSString stringWithFormat:@"%d", eleve.user_id]] intValue] == 2)
    {
        etat = @"Absent";
        
        imageName = @"iconEleveAbsent.png";
    }
    
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    
    [cell.textLabel setText:[[eleve.login stringByAppendingString:@" : "] stringByAppendingString:etat]];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    
    [self.activityIndicatorView startAnimating];
    
    User *eleve = [self.elevesArray objectAtIndex:(indexPath.row - 1)];
    
    if ([[self.etatEleveArray objectForKey:[NSString stringWithFormat:@"%d", eleve.user_id]] intValue] == 0)
    {
        [[tableView cellForRowAtIndexPath:indexPath].imageView setImage:[UIImage imageNamed:@"iconEleveRetard.png"]];
        
        [[tableView cellForRowAtIndexPath:indexPath].textLabel setText:[eleve.login stringByAppendingString:@" : En retard"]];
        
        [self.etatEleveArray setObject:[NSString stringWithFormat:@"%d", 1] forKey:[NSString stringWithFormat:@"%d", eleve.user_id]];
    }
    else if ([[self.etatEleveArray objectForKey:[NSString stringWithFormat:@"%d", eleve.user_id]] intValue] == 1)
    {
        [[tableView cellForRowAtIndexPath:indexPath].imageView setImage:[UIImage imageNamed:@"iconEleveAbsent.png"]];
        
        [[tableView cellForRowAtIndexPath:indexPath].textLabel setText:[eleve.login stringByAppendingString:@" : Absent"]];
        
        [self.etatEleveArray setObject:[NSString stringWithFormat:@"%d", 2] forKey:[NSString stringWithFormat:@"%d", eleve.user_id]];
    }
    else if ([[self.etatEleveArray objectForKey:[NSString stringWithFormat:@"%d", eleve.user_id]] intValue] == 2)
    {
        [[tableView cellForRowAtIndexPath:indexPath].imageView setImage:[UIImage imageNamed:@"iconElevePresent.png"]];
        
        [[tableView cellForRowAtIndexPath:indexPath].textLabel setText:[eleve.login stringByAppendingString:@" : Présent"]];
        
        [self.etatEleveArray setObject:[NSString stringWithFormat:@"%d", 0] forKey:[NSString stringWithFormat:@"%d", eleve.user_id]];
    }
    
    [self.activityIndicatorView stopAnimating];
}

- (void) searchTableList
{
    [self.activityIndicatorView startAnimating];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    BOOL elementFound = NO;
    
    for (int i=0;i<self.elevesArray.count;i++)
    {
        User *eleve = [self.elevesArray objectAtIndex:i];
        
        if ([eleve.login rangeOfString:self.searchBar.text].location != NSNotFound)
        {
            elementFound = YES;
            
            [array addObject:eleve];
        }
    }
    
    if (elementFound)
    {
        self.elevesArray = array;
        
        [self.tableView reloadData];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Aucun élève correspond à la recherche." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
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
    
    [self getGroupe:self.coursSelected.cours_id];
}

- (void) toucheDone
{
    self.research = NO;
    
    [self.view removeGestureRecognizer:self.singleFingerTap];
    
    [self.view endEditing:YES];
    
    [self getGroupe:self.coursSelected.cours_id];
}

@end
