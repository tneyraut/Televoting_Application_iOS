//
//  ProfListeReponsesTableViewController.m
//  Televoting
//
//  Created by Thomas Mac on 05/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "ProfListeReponsesTableViewController.h"

#import "SpecificTableViewCell.h"

#import "Reponse.h"

@interface ProfListeReponsesTableViewController () <UIAlertViewDelegate, UIActionSheetDelegate>

@property(nonatomic, strong) QuestionModel *_questionModel;

@property(nonatomic, strong) ReponseModel *_reponseModel;

@property(nonatomic, strong) ApercuQuestionnaireModel *_apercuQuestionnaireModel;

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSMutableArray *switchArray;

@property(nonatomic, strong) Reponse *reponseSelected;
@property(nonatomic) int indiceSelected;

@property(nonatomic) int mode;

@end

@implementation ProfListeReponsesTableViewController

- (void) initialisationView {
    
    [self.navigationItem setTitle:@"Liste des réponses"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Liste des réponses" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    UIBarButtonItem *buttonAdd = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(actionListenerButtonAdd)];
    [self.navigationItem setRightBarButtonItem:buttonAdd];
    
    [buttonAdd setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:30.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) actionListenerButtonAdd
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    [alertView setDelegate:self];
    
    [alertView setTitle:@"Création d'une nouvelle réponse"];
    [alertView setMessage:@"Veuillez rentrer la nouvelle réponse et indiquer si elle est vrai ou fausse."];
    
    [[alertView textFieldAtIndex:0] setPlaceholder:@"réponse"];
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeAlphabet];
    
    [[alertView textFieldAtIndex:1] setPlaceholder:@"Réponse vrai : YES or NO"];
    [[alertView textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeAlphabet];
    [[alertView textFieldAtIndex:1] setSecureTextEntry:NO];
    
    [alertView addButtonWithTitle:@"Valider"];
    [alertView addButtonWithTitle:@"Annuler"];
    
    self.mode = 3;
    
    [alertView show];
}

- (void) addSwitchInCell:(UITableViewCell*)cell value:(BOOL)value
{
    UISwitch *unSwitch = [[UISwitch alloc] init];
    
    [unSwitch setFrame:CGRectMake(cell.frame.size.width - unSwitch.frame.size.width - 10.0f, (cell.frame.size.height - unSwitch.frame.size.height) / 2, unSwitch.frame.size.width, unSwitch.frame.size.height)];
    
    [unSwitch setOn:value];
    
    [unSwitch addTarget:self action:@selector(switchActionListener:) forControlEvents:UIControlEventAllTouchEvents];
    
    [cell addSubview:unSwitch];
    
    [self.switchArray addObject:unSwitch];
}

- (void) switchActionListener:(UISwitch*)sender
{
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    
    [self.activityIndicatorView startAnimating];
    
    for (int i=0;i<self.switchArray.count;i++)
    {
        if ([sender isEqual:[self.switchArray objectAtIndex:i]])
        {
            self.indiceSelected = i;
            break;
        }
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Souhaitez-vous vraiment modifier la valeur de cette propriété ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Oui", @"Non", nil];
    
    [self.activityIndicatorView stopAnimating];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Oui"])
    {
        self.mode = 4;
        
        [self updateReponse:alertView];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Non"])
    {
        UISwitch *unSwitch = [self.switchArray objectAtIndex:self.indiceSelected];
        
        [unSwitch setOn:![unSwitch isOn] animated:YES];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Valider"])
    {
        if (self.mode == 0 || self.mode == 1)
        {
            [self updateQuestion:alertView];
        }
        else if (self.mode == 2)
        {
            [self updateReponse:alertView];
        }
        else if (self.mode == 3)
        {
            [self creerReponse:alertView];
        }
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Supprimer"])
    {
        [self supprimerReponse:self.reponseSelected.reponse_id];
    }
}

- (void) supprimerReponse:(int)reponse_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._reponseModel)
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self._reponseModel = [[ReponseModel alloc] init];
        self._reponseModel.delegate = self;
    }
        
    [self._reponseModel supprimerReponse:reponse_id];
}

- (void) updateQuestion:(UIAlertView*)alertView
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._questionModel)
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self._questionModel = [[QuestionModel alloc] init];
        self._questionModel.delegate = self;
    }
    
    NSString *question = self.questionSelected.question;
    int temps_imparti = self.questionSelected.temps_imparti;
    
    if (self.mode == 0 && [[[alertView textFieldAtIndex:0] text] isEqualToString:@""])
    {
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self.activityIndicatorView stopAnimating];
        
        [alertError show];
        
        return;
    }
    else if (self.mode == 0 && ![[[alertView textFieldAtIndex:0] text] isEqualToString:@""])
    {
        question = [[alertView textFieldAtIndex:0] text];
    }
    else if (self.mode == 1 && [[[alertView textFieldAtIndex:0] text] isEqualToString:@""])
    {
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self.activityIndicatorView stopAnimating];
        
        [alertError show];
        
        return;
    }
    else if (self.mode == 1 && ![[[alertView textFieldAtIndex:0] text] isEqualToString:@""])
    {
        temps_imparti = [[[alertView textFieldAtIndex:0] text] intValue];
    }
    
    [self._questionModel updateQuestion:self.questionSelected.question_id question:question temps_imparti:temps_imparti];
}

- (void) updateReponse:(UIAlertView*)alertView
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._reponseModel)
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self._reponseModel = [[ReponseModel alloc] init];
        self._reponseModel.delegate = self;
    }
    
    Reponse *reponse = [self.reponsesArray objectAtIndex:self.indiceSelected];
    
    if (self.mode == 2)
    {
        // Update reponse
        if ([[[alertView textFieldAtIndex:0] text] isEqualToString:@""])
        {
            UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Champ réponse incorrect : Veuillez saisir une réponse" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [self.activityIndicatorView stopAnimating];
            
            [alertError show];
            
            return;
        }
        
        [self._reponseModel updateReponse:reponse.reponse_id reponse:[[alertView textFieldAtIndex:0] text] reponse_correcte:reponse.reponse_correcte question_suivante_id:reponse.question_suivante_id];
    }
    else if (self.mode == 4)
    {
        // Update reponse_correcte
        if (![[[alertView textFieldAtIndex:0] text] isEqualToString:@"YES"] && ![[[alertView textFieldAtIndex:0] text] isEqualToString:@"NO"])
        {
            UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Champ réponse correcte incorrect : Veuillez saisir YES ou NO" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [self.activityIndicatorView stopAnimating];
            
            [alertError show];
            
            return;
        }
        
        [self._reponseModel updateReponse:reponse.reponse_id reponse:reponse.reponse reponse_correcte:[[[alertView textFieldAtIndex:0] text] boolValue] question_suivante_id:reponse.question_suivante_id];
    }
}

- (void) creerReponse:(UIAlertView*)alertView
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._reponseModel)
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self._reponseModel = [[ReponseModel alloc] init];
        self._reponseModel.delegate = self;
    }
    
    if ([[[alertView textFieldAtIndex:0] text] isEqualToString:@""])
    {
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Champ réponse incorrect : Veuillez saisir une réponse" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self.activityIndicatorView stopAnimating];
        
        [alertError show];
        
        return;
    }
    else
    {
        for (int i=0;i<self.reponsesArray.count;i++)
        {
            Reponse *reponse = [self.reponsesArray objectAtIndex:i];
            
            if ([[[alertView textFieldAtIndex:0] text] isEqualToString:reponse.reponse])
            {
                UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Cette réponse existe déjà pour cette question." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [self.activityIndicatorView stopAnimating];
                
                [alertError show];
                
                return;
            }
        }
    }
    
    if (![[[alertView textFieldAtIndex:1] text] isEqualToString:@"YES"] && ![[[alertView textFieldAtIndex:1] text] isEqualToString:@"NO"])
    {
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Champ réponse correcte incorrect : Veuillez saisir YES ou NO" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self.activityIndicatorView stopAnimating];
        
        [alertError show];
        
        return;
    }
    
    [self._reponseModel creerReponse:self.questionSelected.question_id reponse:[[alertView textFieldAtIndex:0] text] reponse_correcte:[[[alertView textFieldAtIndex:1] text] boolValue] question_suivante_id:0];
}

- (void) questionDownloaded:(NSArray *)items
{
    [self.activityIndicatorView stopAnimating];
    
    [self downloadAllData:self.questionnaireSelected.questionnaire_id];
}

- (void) reponseDownloaded:(NSArray *)items
{
    [self.activityIndicatorView stopAnimating];
    
    [self downloadAllData:self.questionnaireSelected.questionnaire_id];
}

- (void) downloadAllData:(int)questionnaire_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._apercuQuestionnaireModel)
    {
        self._apercuQuestionnaireModel = [[ApercuQuestionnaireModel alloc] init];
        self._apercuQuestionnaireModel.delegate = self;
    }
    
    [self._apercuQuestionnaireModel getListeQuestionsReponses:questionnaire_id];
}

- (void) getApercuQuestionnaireDownloaded:(NSArray *)items
{
    if (items.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Aucune donnée trouvée..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self.activityIndicatorView stopAnimating];
        
        [alertView show];
        
        return;
    }
    
    for (int i=0;i<items.count;i=i+2)
    {
        Question *question = [items objectAtIndex:i];
        if (question.question_id == self.questionSelected.question_id)
        {
            self.questionSelected = question;
            self.reponsesArray = [items objectAtIndex:i+1];
            break;
        }
    }
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cellTemps"];
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cellReponse"];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self initialisationView];
    
    self.switchArray = [[NSMutableArray alloc] init];
    
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
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [super viewDidAppear:animated];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.activityIndicatorView startAnimating];
    
    if (buttonIndex == 0)
    {
        //@"Modifier la réponse"
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        [alertView setDelegate:self];
        
        [alertView setTitle:@"Modification de la réponse"];
        [alertView setMessage:@"Veuillez rentrer une nouvelle réponse."];
        
        [[alertView textFieldAtIndex:0] setPlaceholder:@"réponse"];
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeAlphabet];
        [[alertView textFieldAtIndex:0] setText:self.reponseSelected.reponse];
        
        [alertView addButtonWithTitle:@"Valider"];
        [alertView addButtonWithTitle:@"Annuler"];
        
        self.mode = 2;
        
        [self.activityIndicatorView stopAnimating];
        
        [alertView show];
    }
    else if (buttonIndex == 1)
    {
        //@"Supprimer la réponse"
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        [alertView setDelegate:self];
        
        [alertView setTitle:[@"Suppression de la réponse : " stringByAppendingString:self.reponseSelected.reponse]];
        [alertView setMessage:@"Êtes-vous sûr de vouloir supprimer cette réponse ?"];
        
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
    return 1 + self.reponsesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Question";
    }
    return [NSString stringWithFormat:@"Réponse %d", (int)section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.imageView setImage:[UIImage imageNamed:@"iconQuestion.png"]];
            
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, 5.0f, 2 * self.view.frame.size.width / 3 - 50, cell.frame.size.height - 10.0f)];
            
            [textView setText:self.questionSelected.question];
            [textView setTextColor:[UIColor blackColor]];
            [textView setFont:[UIFont fontWithName:textView.font.fontName size:15.0]];
            [textView setEditable:NO];
            
            [cell addSubview:textView];
            
            return cell;
        }
        
        SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTemps" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        
        [cell.imageView setImage:[UIImage imageNamed:@"iconTimer.png"]];
        
        [cell.textLabel setText:[NSString stringWithFormat:@"Temps imparti de %d secondes", self.questionSelected.temps_imparti]];
        
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        
        return cell;
    }
    
    Reponse *reponse = [self.reponsesArray objectAtIndex:indexPath.section - 1];
    
    if (indexPath.row == 0)
    {
        SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        
        [cell.imageView setImage:[UIImage imageNamed:@"iconReponse.png"]];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, 5.0f, 2 * self.view.frame.size.width / 3 - 50, cell.frame.size.height - 10.0f)];
        
        [textView setText:reponse.reponse];
        [textView setTextColor:[UIColor blackColor]];
        [textView setFont:[UIFont fontWithName:textView.font.fontName size:15.0]];
        [textView setEditable:NO];
        
        [cell addSubview:textView];
        
        return cell;
    }
    
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellReponse" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (reponse.reponse_correcte)
    {
        [cell.imageView setImage:[UIImage imageNamed:@"iconBonneReponse.png"]];
        
        [cell.textLabel setText:@"Bonne réponse"];
    }
    else
    {
        [cell.imageView setImage:[UIImage imageNamed:@"iconMauvaiseReponse.png"]];
        
        [cell.textLabel setText:@"Mauvaise réponse"];
    }
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    [self addSwitchInCell:cell value:reponse.reponse_correcte];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] init];
            
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            [alertView setDelegate:self];
            
            [alertView setTitle:@"Modification de la question"];
            [alertView setMessage:@"Veuillez rentrer une nouvelle question."];
            
            [[alertView textFieldAtIndex:0] setPlaceholder:@"question"];
            [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeAlphabet];
            [[alertView textFieldAtIndex:0] setText:self.questionSelected.question];
            
            [alertView addButtonWithTitle:@"Valider"];
            [alertView addButtonWithTitle:@"Annuler"];
            
            self.mode = 0;
            
            [self.activityIndicatorView stopAnimating];
            
            [alertView show];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] init];
            
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            [alertView setDelegate:self];
            
            [alertView setTitle:@"Modification du temps imparti"];
            [alertView setMessage:@"Veuillez rentrer un entier positif (temps en seconde)."];
            
            [[alertView textFieldAtIndex:0] setPlaceholder:@"temps imparti"];
            [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
            [[alertView textFieldAtIndex:0] setText:[NSString stringWithFormat:@"%d",self.questionSelected.temps_imparti]];
            
            [alertView addButtonWithTitle:@"Valider"];
            [alertView addButtonWithTitle:@"Annuler"];
            
            self.mode = 1;
            
            [self.activityIndicatorView stopAnimating];
            
            [alertView show];
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            self.reponseSelected = [self.reponsesArray objectAtIndex:indexPath.section - 1];
            
            self.indiceSelected = (int)indexPath.section - 1;
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.questionnaireSelected.questionnaire_name delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:@"Modifier la réponse", @"Supprimer la réponse", nil];
            
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
}

@end
