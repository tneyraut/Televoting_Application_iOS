//
//  ProfListeQuestionnairesTableViewController.m
//  Televoting
//
//  Created by Thomas Mac on 02/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "ProfListeQuestionnairesTableViewController.h"
#import "ProfDonneesGeneralesQuestionnaireTableViewController.h"
#import "ProfVisualisationQuestionnaireTableViewController.h"
#import "ProfListeQuestionsTableViewController.h"
#import "ProfStatistiquesParticipantsTableViewController.h"
#import "ProfStatistiquesQuestionsTableViewController.h"

#import "SpecificTableViewCell.h"

#import "Questionnaire.h"

@interface ProfListeQuestionnairesTableViewController () <UIActionSheetDelegate, UIAlertViewDelegate, UISearchBarDelegate>

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSArray *questionnairesArray;

@property(nonatomic, weak) Questionnaire *questionnaireSelected;

@property(nonatomic, strong) QuestionnaireModel *_questionnaireModel;

@property(nonatomic) BOOL creation;

@property(nonatomic) BOOL reinitialisation;

@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic) BOOL research;

@property(nonatomic) UITapGestureRecognizer *singleFingerTap;

@end

@implementation ProfListeQuestionnairesTableViewController

- (void) initialisationView {
    
    [self.navigationItem setTitle:@"Liste des questionnaires"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonAdd = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(actionListenerButtonAdd)];
    [self.navigationItem setRightBarButtonItem:buttonAdd];
    
    [buttonAdd setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:30.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Liste des questionnaires" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) actionListenerButtonAdd
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView setDelegate:self];
    
    [alertView setTitle:@"Création d'un nouveau questionnaire"];
    [alertView setMessage:@"Veuillez rentrer le nom du nouveau questionnaire."];
    
    [[alertView textFieldAtIndex:0] setPlaceholder:@"nom"];
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeAlphabet];
    
    [alertView addButtonWithTitle:@"Valider"];
    [alertView addButtonWithTitle:@"Annuler"];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Valider"])
    {
        [self creerQuestionnaire:alertView];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Oui"])
    {
        [self.activityIndicatorView startAnimating];
        
        [self._questionnaireModel reinitialisationQuestionnaire:self.questionnaireSelected.questionnaire_id];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Supprimer"])
    {
        [self.activityIndicatorView startAnimating];
        
        self.creation = YES;
        
        [self._questionnaireModel supprimerQuestionnaire:self.questionnaireSelected.questionnaire_id];
    }
}

- (void) creerQuestionnaire:(UIAlertView *)alertView
{
    [self.activityIndicatorView startAnimating];
    
    if ([[[alertView textFieldAtIndex:0] text] isEqualToString:@""])
    {
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Champ nom du questionnaire incorrect : Veuillez rentrer un nom" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self.activityIndicatorView stopAnimating];
        
        [alertError show];
        
        return;
    }
    
    for (int i=0;i<self.questionnairesArray.count;i++)
    {
        Questionnaire *questionnaire = [self.questionnairesArray objectAtIndex:i];
        if ([[[alertView textFieldAtIndex:0] text] isEqualToString:questionnaire.questionnaire_name])
        {
            UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Champ nom du questionnaire incorrect : Ce nom de questionnaire existe déjà pour ce cours" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [self.activityIndicatorView stopAnimating];
            
            [alertError show];
            
            return;
        }
    }
    
    self.creation = YES;
    
    [self._questionnaireModel creerQuestionnaire:self.coursSelected.cours_id questionnaire_name:[[alertView textFieldAtIndex:0] text]];
}

- (void) reinitialiserQuestionnaire
{
    self.reinitialisation = YES;
    
    UIAlertView *alertView = [[UIAlertView alloc] init];
    
    [alertView setDelegate:self];
    
    [alertView setTitle:self.questionnaireSelected.questionnaire_name];
    [alertView setMessage:@"Êtes-vous sûr de vouloir réinitialiser ce questionnaire ?"];
    
    [alertView addButtonWithTitle:@"Oui"];
    [alertView addButtonWithTitle:@"Non"];
    
    [alertView show];
}

- (void) getListeQuestionnaires:(int)cours_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._questionnaireModel)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.questionnairesArray = [[NSArray alloc] init];
        self._questionnaireModel = [[QuestionnaireModel alloc] init];
        self._questionnaireModel.delegate = self;
    }
    [self._questionnaireModel getAllQuestionnairesByCours:cours_id];
}

- (void) questionnaireDownloaded:(NSArray *)items
{
    if (self.reinitialisation)
    {
        self.reinitialisation = NO;
        
        [self.activityIndicatorView stopAnimating];
        
        return;
    }
    
    if (self.creation)
    {
        self.creation = NO;
        
        [self getListeQuestionnaires:self.coursSelected.cours_id];
        
        return;
    }
    
    self.questionnairesArray = items;
    
    if (items.count == 0)
    {
        [self.activityIndicatorView stopAnimating];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:[@"Vous n'avez créé pour le moment aucun questionnaire pour votre cours : " stringByAppendingString:self.coursSelected.cours_name] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        [self.tableView reloadData];
        
        return;
    }
    else if (self.research && ![self.searchBar.text isEqualToString:@""])
    {
        [self searchTableList];
    }
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
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
    
    self.creation = NO;
    self.reinitialisation = NO;
    
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
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [self getListeQuestionnaires:self.coursSelected.cours_id];
    
    [super viewDidAppear:animated];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.activityIndicatorView startAnimating];
    
    if (buttonIndex == 0)
    {
        //@"Données générales"
        
        ProfDonneesGeneralesQuestionnaireTableViewController *profDonneesGeneralesQuestionnaireTableViewController = [[ProfDonneesGeneralesQuestionnaireTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        profDonneesGeneralesQuestionnaireTableViewController.coursSelected = self.coursSelected;
        profDonneesGeneralesQuestionnaireTableViewController.questionnaireSelected = self.questionnaireSelected;
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController pushViewController:profDonneesGeneralesQuestionnaireTableViewController animated:YES];
    }
    else if (buttonIndex == 2)
    {
        //@"Visualisation partielle du questionnaire"
        
        ProfVisualisationQuestionnaireTableViewController *profVisualisationQuestionnaireTableViewController = [[ProfVisualisationQuestionnaireTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        profVisualisationQuestionnaireTableViewController.questionnaireSelected = self.questionnaireSelected;
        profVisualisationQuestionnaireTableViewController.apercuPartiel = YES;
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController pushViewController:profVisualisationQuestionnaireTableViewController animated:YES];
    }
    else if (buttonIndex == 3)
    {
        //@"Visualisation globale du questionnaire"
        
        ProfVisualisationQuestionnaireTableViewController *profVisualisationQuestionnaireTableViewController = [[ProfVisualisationQuestionnaireTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        profVisualisationQuestionnaireTableViewController.questionnaireSelected = self.questionnaireSelected;
        profVisualisationQuestionnaireTableViewController.apercuPartiel = NO;
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController pushViewController:profVisualisationQuestionnaireTableViewController animated:YES];
    }
    else if (buttonIndex == 1)
    {
        //@"Liste des questions"
        
        ProfListeQuestionsTableViewController *profListeQuestionsTableViewController = [[ProfListeQuestionsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        profListeQuestionsTableViewController.questionnaireSelected = self.questionnaireSelected;
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController pushViewController:profListeQuestionsTableViewController animated:YES];
    }
    else if (buttonIndex == 4)
    {
        //@"Statistiques des participants"
        
        ProfStatistiquesParticipantsTableViewController *profStatistiquesParticipantsTableViewController = [[ProfStatistiquesParticipantsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        profStatistiquesParticipantsTableViewController.questionnaireSelected = self.questionnaireSelected;
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController pushViewController:profStatistiquesParticipantsTableViewController animated:YES];
    }
    else if (buttonIndex == 5)
    {
        //@"Statistiques des questions"
        
        ProfStatistiquesQuestionsTableViewController *profStatistiquesQuestionsTableViewController = [[ProfStatistiquesQuestionsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        profStatistiquesQuestionsTableViewController.questionnaireSelected = self.questionnaireSelected;
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController pushViewController:profStatistiquesQuestionsTableViewController animated:YES];
    }
    else if (buttonIndex == 6)
    {
        //@"Réinitialiser le questionnaire"
        
        [self reinitialiserQuestionnaire];
        
        [self.activityIndicatorView stopAnimating];
    }
    else if (buttonIndex == 7)
    {
        //@"Supprimer le questionnaire"
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        [alertView setDelegate:self];
        
        [alertView setTitle:[@"Suppression du questionnaire : " stringByAppendingString:self.questionnaireSelected.questionnaire_name]];
        [alertView setMessage:@"Êtes-vous sûr de vouloir supprimer ce questionnaire ?"];
        
        [alertView addButtonWithTitle:@"Supprimer"];
        [alertView addButtonWithTitle:@"Annuler"];
        
        [self.activityIndicatorView stopAnimating];
        
        [alertView show];
    }
    
    [self.activityIndicatorView stopAnimating];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.questionnairesArray.count + 1;
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
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.imageView setImage:[UIImage imageNamed:@"iconQuestionnaire.png"]];
    
    Questionnaire *unQuestionnaire = [self.questionnairesArray objectAtIndex:(indexPath.row - 1)];
    
    [cell.textLabel setText:unQuestionnaire.questionnaire_name];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.activityIndicatorView.isAnimating || indexPath.row == 0)
    {
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    self.questionnaireSelected = [self.questionnairesArray objectAtIndex:(indexPath.row - 1)];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.questionnaireSelected.questionnaire_name delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:@"Données générales", @"Liste des questions", @"Visualisation partielle du questionnaire", @"Visualisation globale du questionnaire", @"Statistiques des participants", @"Statistiques des questions", @"Réinitialiser le questionnaire", @"Supprimer le questionnaire", nil];
    
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

- (void) searchTableList
{
    [self.activityIndicatorView startAnimating];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    BOOL elementFound = NO;
    
    for (int i=0;i<self.questionnairesArray.count;i++)
    {
        Questionnaire *questionnaire = [self.questionnairesArray objectAtIndex:i];
        
        if ([questionnaire.questionnaire_name rangeOfString:self.searchBar.text].location != NSNotFound)
        {
            elementFound = YES;
            
            [array addObject:questionnaire];
        }
    }
    
    if (elementFound)
    {
        self.questionnairesArray = array;
        
        [self.tableView reloadData];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Aucun questionnaire correspond à la recherche." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
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
    
    [self getListeQuestionnaires:self.coursSelected.cours_id];
}

- (void) toucheDone
{
    self.research = NO;
    
    [self.view removeGestureRecognizer:self.singleFingerTap];
    
    [self.view endEditing:YES];
    
    [self getListeQuestionnaires:self.coursSelected.cours_id];
}

@end
