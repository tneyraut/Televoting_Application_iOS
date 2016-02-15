//
//  ProfListeQuestionsTableViewController.m
//  Televoting
//
//  Created by Thomas Mac on 05/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "ProfListeQuestionsTableViewController.h"
#import "ProfListeReponsesTableViewController.h"
#import "ProfStatistiquesQuestionReponsesTableViewController.h"

#import "SpecificTableViewCell.h"
#import "Question.h"

@interface ProfListeQuestionsTableViewController () <UIAlertViewDelegate, UIActionSheetDelegate, UISearchBarDelegate>

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) ApercuQuestionnaireModel *_apercuQuestionnaireModel;

@property(nonatomic, strong) QuestionModel *_questionModel;

@property(nonatomic, strong) NSMutableArray *questionsArray;

@property(nonatomic, strong) NSMutableArray *reponsesArray;

@property(nonatomic, strong) Question *questionSelected;
@property(nonatomic) int indiceSelected;

@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic) BOOL research;

@property(nonatomic) UITapGestureRecognizer *singleFingerTap;

@end

@implementation ProfListeQuestionsTableViewController

- (void) initialisationView {
    
    [self.navigationItem setTitle:@"Liste des questions"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonAdd = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(actionListenerButtonAdd)];
    [self.navigationItem setRightBarButtonItem:buttonAdd];
    
    [buttonAdd setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:30.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Liste des questions" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) actionListenerButtonAdd
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    [alertView setDelegate:self];
    
    [alertView setTitle:@"Création d'une nouvelle question"];
    [alertView setMessage:@"Veuillez rentrer la nouvelle question et potentiellement son temps imparti en seconde (entier positif)."];
    
    [[alertView textFieldAtIndex:0] setPlaceholder:@"question"];
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeAlphabet];
    
    [[alertView textFieldAtIndex:1] setPlaceholder:@"temps imparti en seconde (entier positif)"];
    [[alertView textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeNumberPad];
    [[alertView textFieldAtIndex:1] setSecureTextEntry:NO];
    
    [alertView addButtonWithTitle:@"Valider"];
    [alertView addButtonWithTitle:@"Annuler"];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Valider"])
    {
        [self creerQuestion:alertView];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Oui"])
    {
        if (!self._questionModel)
        {
            self._questionModel = [[QuestionModel alloc] init];
            self._questionModel.delegate = self;
        }
        [self.activityIndicatorView startAnimating];
        
        [self._questionModel supprimerQuestion:self.questionSelected.question_id];
    }
}

- (void) creerQuestion:(UIAlertView*)alertView
{
    [self.activityIndicatorView startAnimating];
    
    if ([[[alertView textFieldAtIndex:0] text] isEqualToString:@""])
    {
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Champ question incorrect : Veuillez rentrer une question" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self.activityIndicatorView stopAnimating];
        
        [alertError show];
        
        return;
    }
    else
    {
        for (int i=0;i<self.questionsArray.count;i++)
        {
            Question *question = [self.questionsArray objectAtIndex:i];
            
            if ([[[alertView textFieldAtIndex:0] text] isEqualToString:question.question])
            {
                UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Cette question existe déjà pour ce questionnaire." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [self.activityIndicatorView stopAnimating];
                
                [alertError show];
                
                return;
            }
        }
    }
    
    int temps_imparti = 0;
    
    if (![[[alertView textFieldAtIndex:1] text] isEqualToString:@""])
    {
        temps_imparti = [[[alertView textFieldAtIndex:1] text] intValue];
    }
    
    if (!self._questionModel)
    {
        self._questionModel = [[QuestionModel alloc] init];
        self._questionModel.delegate = self;
    }
    
    [self._questionModel creerQuestion:self.questionnaireSelected.questionnaire_id question:[[alertView textFieldAtIndex:0] text] temps_imparti:temps_imparti];
}

- (void) questionDownloaded:(NSArray *)items
{
    [self.activityIndicatorView stopAnimating];
    
    [self downloadData:self.questionnaireSelected.questionnaire_id];
}

- (void) downloadData:(int)questionnaire_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._apercuQuestionnaireModel)
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self._apercuQuestionnaireModel = [[ApercuQuestionnaireModel alloc] init];
        self._apercuQuestionnaireModel.delegate = self;
    }
    [self._apercuQuestionnaireModel getListeQuestionsReponses:questionnaire_id];
}

- (void) getApercuQuestionnaireDownloaded:(NSArray *)items
{
    self.questionsArray = [[NSMutableArray alloc] init];
    
    self.reponsesArray = [[NSMutableArray alloc] init];
    
    for (int i=0;i<items.count;i=i+2)
    {
        [self.questionsArray addObject:[items objectAtIndex:i]];
        
        [self.reponsesArray addObject:[items objectAtIndex:i+1]];
    }
    
    if (items.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:[@"Aucune question n'a été trouvée concernant le questionnaire : " stringByAppendingString:self.questionnaireSelected.questionnaire_name] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self.activityIndicatorView stopAnimating];
        
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
    
    [self downloadData:self.questionnaireSelected.questionnaire_id];
    
    [super viewDidAppear:animated];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.activityIndicatorView startAnimating];
    
    if (buttonIndex == 0)
    {
        //@"Liste des réponses"
        
        ProfListeReponsesTableViewController *profListeReponsesTableViewController = [[ProfListeReponsesTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        profListeReponsesTableViewController.questionnaireSelected = self.questionnaireSelected;
        profListeReponsesTableViewController.questionSelected = self.questionSelected;
        profListeReponsesTableViewController.reponsesArray = [self.reponsesArray objectAtIndex:self.indiceSelected];
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController pushViewController:profListeReponsesTableViewController animated:YES];
    }
    else if (buttonIndex == 1)
    {
        //@"Statistiques de la question"
        
        ProfStatistiquesQuestionReponsesTableViewController *profStatistiquesQuestionReponsesTableViewController = [[ProfStatistiquesQuestionReponsesTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        profStatistiquesQuestionReponsesTableViewController.questionnaireSelected = self.questionnaireSelected;
        profStatistiquesQuestionReponsesTableViewController.questionSelected = self.questionSelected;
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController pushViewController:profStatistiquesQuestionReponsesTableViewController animated:YES];
    }
    else if (buttonIndex == 2)
    {
        //@"Supprimer la question"
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        [alertView setDelegate:self];
        
        [alertView setTitle:[@"Suppression de la question : " stringByAppendingString:self.questionSelected.question]];
        [alertView setMessage:@"Êtes-vous sûr de vouloir supprimer cette question ?"];
        
        [alertView addButtonWithTitle:@"Oui"];
        [alertView addButtonWithTitle:@"Non"];
        
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
    return self.questionsArray.count + 1;
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
    
    [cell.imageView setImage:[UIImage imageNamed:@"iconQuestion.png"]];
    
    Question *question = [self.questionsArray objectAtIndex:(indexPath.row - 1)];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, 5.0f, 2 * self.view.frame.size.width / 3 - 50, cell.frame.size.height - 10.0f)];
    
    [textView setText:question.question];
    [textView setTextColor:[UIColor blackColor]];
    [textView setFont:[UIFont fontWithName:textView.font.fontName size:15.0]];
    [textView setEditable:NO];
    
    [cell addSubview:textView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.activityIndicatorView.isAnimating || indexPath.row == 0)
    {
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    self.questionSelected = [self.questionsArray objectAtIndex:(indexPath.row - 1)];
    
    self.indiceSelected = (int)(indexPath.row - 1);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.questionnaireSelected.questionnaire_name delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:@"Liste des réponses", @"Statistiques de la question", @"Supprimer la question", nil];
    
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
    
    for (int i=0;i<self.questionsArray.count;i++)
    {
        Question *question = [self.questionsArray objectAtIndex:i];
        
        if ([question.question rangeOfString:self.searchBar.text].location != NSNotFound)
        {
            elementFound = YES;
            
            [array addObject:question];
        }
    }
    
    if (elementFound)
    {
        self.questionsArray = array;
        
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
    
    [self downloadData:self.questionnaireSelected.questionnaire_id];
}

- (void) toucheDone
{
    self.research = NO;
    
    [self.view removeGestureRecognizer:self.singleFingerTap];
    
    [self.view endEditing:YES];
    
    [self downloadData:self.questionnaireSelected.questionnaire_id];
}

@end
