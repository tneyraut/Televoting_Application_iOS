//
//  ProfDonneesGeneralesQuestionnaireTableViewController.m
//  Televoting
//
//  Created by Thomas Mac on 03/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "ProfDonneesGeneralesQuestionnaireTableViewController.h"

#import "SpecificTableViewCell.h"

@interface ProfDonneesGeneralesQuestionnaireTableViewController () <UIAlertViewDelegate>

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSArray *dataArray;

@property(nonatomic, strong) DataQuestionnaireModel *_dataQuestionnaireModel;
@property(nonatomic, strong) QuestionnaireModel *_questionnaireModel;

@property(nonatomic, strong) UISwitch *modeExamenSwitch;
@property(nonatomic, strong) UISwitch *modePauseSwitch;
@property(nonatomic, strong) UISwitch *lanceSwitch;

@property(nonatomic, strong) UISwitch *switchSelected;

@property(nonatomic) BOOL setSwitchDone;

@property(nonatomic) BOOL modificationName;

@end

@implementation ProfDonneesGeneralesQuestionnaireTableViewController

- (void) initialisationView {
    
    [self.navigationItem setTitle:@"Données générales"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Données générales" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) setCellImage:(UITableViewCell*)cell indice:(int)indice
{
    NSString *imageName = @"";
    
    if (indice == 0)
    {
        imageName = @"iconCours.png";
    }
    else if (indice == 1)
    {
        imageName = @"iconQuestionnaire.png";
    }
    else if (indice == 2)
    {
        imageName = @"iconModeExamen.png";
    }
    else if (indice == 3)
    {
        imageName = @"iconMalus.png";
    }
    else if (indice == 4)
    {
        imageName = @"iconPause.png";
    }
    else if (indice == 5)
    {
        imageName = @"iconLance.png";
    }
    else if (indice == 6)
    {
        imageName = @"iconNote.png";
    }
    else if (indice == 7)
    {
        imageName = @"iconMauvaiseReponse.png";
    }
    
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
}

- (NSString*) addTextSupplementaire:(int)indice
{
    NSString *resultat = @"";
    
    if (indice == 2)
    {
        resultat = @"Mode examen : ";
    }
    else if (indice == 3)
    {
        resultat = @"Malus : ";
    }
    else if (indice == 4)
    {
        resultat = @"Avec pause : ";
    }
    else if (indice == 5)
    {
        resultat = @"Lancé : ";
    }
    else if (indice == 6)
    {
        resultat = @"Nombre de points : ";
    }
    else if (indice == 7)
    {
        resultat = @"Nombre de fautes : ";
    }
    return resultat;
}

- (void) addGraphicElement:(UITableViewCell*)cell indice:(int)indice
{
    if (indice == 2)
    {
        self.modeExamenSwitch = [[UISwitch alloc] init];
        
        [self.modeExamenSwitch setFrame:CGRectMake(cell.frame.size.width - self.modeExamenSwitch.frame.size.width - 10.0f, (cell.frame.size.height - self.modeExamenSwitch.frame.size.height) / 2, self.modeExamenSwitch.frame.size.width, self.modeExamenSwitch.frame.size.height)];
        
        [self.modeExamenSwitch setOn:[[self.dataArray objectAtIndex:2] boolValue]];
        
        [self.modeExamenSwitch addTarget:self action:@selector(switchActionListener:) forControlEvents:UIControlEventAllTouchEvents];
        
        [cell addSubview:self.modeExamenSwitch];
    }
    else if (indice == 4)
    {
        self.modePauseSwitch = [[UISwitch alloc] init];
        
        [self.modePauseSwitch setFrame:CGRectMake(cell.frame.size.width - self.modeExamenSwitch.frame.size.width - 10.0f, (cell.frame.size.height - self.modeExamenSwitch.frame.size.height) / 2, self.modeExamenSwitch.frame.size.width, self.modeExamenSwitch.frame.size.height)];
        
        [self.modePauseSwitch setOn:[[self.dataArray objectAtIndex:4] boolValue]];
        
        [self.modePauseSwitch addTarget:self action:@selector(switchActionListener:) forControlEvents:UIControlEventAllTouchEvents];
        
        [cell addSubview:self.modePauseSwitch];
    }
    else if (indice == 5)
    {
        self.lanceSwitch = [[UISwitch alloc] init];
        
        [self.lanceSwitch setFrame:CGRectMake(cell.frame.size.width - self.modeExamenSwitch.frame.size.width - 10.0f, (cell.frame.size.height - self.modeExamenSwitch.frame.size.height) / 2, self.modeExamenSwitch.frame.size.width, self.modeExamenSwitch.frame.size.height)];
        
        [self.lanceSwitch setOn:[[self.dataArray objectAtIndex:5] boolValue]];
        
        [self.lanceSwitch addTarget:self action:@selector(switchActionListener:) forControlEvents:UIControlEventAllTouchEvents];
        
        [cell addSubview:self.lanceSwitch];
        
        self.setSwitchDone = YES;
    }
}

- (void) switchActionListener:(UISwitch*)sender
{
    if (self.activityIndicatorView.isAnimating)
    {
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    self.switchSelected = sender;
    
    NSString *message = @"";
    
    if ([sender isEqual:self.modeExamenSwitch])
    {
        if ([sender isOn])
        {
            message = @"Êtes-vous sûr de vouloir activer le mode Examen ?";
        }
        else
        {
            message = @"Êtes-vous sûr de vouloir désactiver le mode Examen ?";
        }
    }
    else if ([sender isEqual:self.modePauseSwitch])
    {
        if ([sender isOn])
        {
            message = @"Êtes-vous sûr de vouloir activer les pauses ?";
        }
        else
        {
            message = @"Êtes-vous sûr de vouloir désactiver les pauses ?";
        }
    }
    else if ([sender isEqual:self.lanceSwitch])
    {
        if ([sender isOn])
        {
            message = @"Êtes-vous sûr de vouloir lancer le questionnaire ?";
        }
        else
        {
            message = @"Êtes-vous sûr de vouloir arrêter le questionnaire ?";
        }
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Oui", @"Non", nil];
    
    [self.activityIndicatorView stopAnimating];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Oui"])
    {
        [self updateQuestionnaire:self.questionnaireSelected.questionnaire_id questionnaire_name:[self.dataArray objectAtIndex:1] mode_examen:[self.modeExamenSwitch isOn] pause:[self.modePauseSwitch isOn] lancee:[self.lanceSwitch isOn] malus:[[self.dataArray objectAtIndex:3] floatValue]];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Non"])
    {
        [self.switchSelected setOn:![self.switchSelected isOn] animated:YES];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Valider"])
    {
        if (self.modificationName)
        {
            [self updateQuestionnaire:self.questionnaireSelected.questionnaire_id questionnaire_name:[[alertView textFieldAtIndex:0] text] mode_examen:[self.modeExamenSwitch isOn] pause:[self.modePauseSwitch isOn] lancee:[self.lanceSwitch isOn] malus:[[self.dataArray objectAtIndex:3] floatValue]];
        }
        else
        {
            //VERIFICATION QUE C'EST BIEN UN FLOAT ? + AJOUTER POSSIBILITE DE MODIFIER LE NOM DU QUESTIONNAIRE
            [self updateQuestionnaire:self.questionnaireSelected.questionnaire_id questionnaire_name:[self.dataArray objectAtIndex:1] mode_examen:[self.modeExamenSwitch isOn] pause:[self.modePauseSwitch isOn] lancee:[self.lanceSwitch isOn] malus:[[[alertView textFieldAtIndex:0] text] floatValue]];
        }
    }
}

- (void) getAllDataQuestionnaire:(int)questionnaire_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._dataQuestionnaireModel)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.dataArray = [[NSArray alloc] init];
        self._dataQuestionnaireModel = [[DataQuestionnaireModel alloc] init];
        self._dataQuestionnaireModel.delegate = self;
    }
    [self._dataQuestionnaireModel getDataQuestionnaire:questionnaire_id];
}

- (void) getDataQuestionnaireDownloaded:(NSArray *)items
{
    self.dataArray = items;
    
    if (items.count == 0)
    {
        [self.activityIndicatorView stopAnimating];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Une erreur de connection ou de base de données s'est produite. Veuillez recharger la page actuelle. Si le problème persiste, veuillez contacter l'administrateur." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
}

- (void) questionnaireDownloaded:(NSArray *)items
{
    [self.activityIndicatorView stopAnimating];
    
    [self getAllDataQuestionnaire:self.questionnaireSelected.questionnaire_id];
}

- (void) updateQuestionnaire:(int)questionnaire_id questionnaire_name:(NSString *)questionnaire_name mode_examen:(BOOL)mode_examen pause:(BOOL)pause lancee:(BOOL)lancee malus:(float)malus
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._questionnaireModel)
    {
        self._questionnaireModel = [[QuestionnaireModel alloc] init];
        self._questionnaireModel.delegate = self;
    }
    [self._questionnaireModel updateQuestionnaire:questionnaire_id questionnaire_name:questionnaire_name mode_examen:mode_examen pause:pause lancee:lancee malus:malus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self initialisationView];
    
    self.setSwitchDone = NO;
    
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
    
    [self getAllDataQuestionnaire:self.questionnaireSelected.questionnaire_id];
    
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 0 || indexPath.row == 6 || indexPath.row == 7)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [self setCellImage:cell indice:(int)indexPath.row];
    
    NSString *text = [self addTextSupplementaire:(int)indexPath.row];
    
    if (indexPath.row == 0 || indexPath.row == 1)
    {
        text = [text stringByAppendingString:[self.dataArray objectAtIndex:indexPath.row]];
    }
    else if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5)
    {
        if ([[self.dataArray objectAtIndex:indexPath.row] intValue] == 1)
        {
            text = [text stringByAppendingString:@"Activé"];
        }
        else
        {
            text = [text stringByAppendingString:@"Désactivé"];
        }
    }
    else if (indexPath.row == 3)
    {
        text = [NSString stringWithFormat:@"%@%f", text, [[self.dataArray objectAtIndex:indexPath.row] floatValue]];
    }
    else if (indexPath.row > 5)
    {
        text = [NSString stringWithFormat:@"%@%d", text, [[self.dataArray objectAtIndex:indexPath.row] intValue]];
    }
    
    [cell.textLabel setText:text];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    if (!self.setSwitchDone)
    {
        [self addGraphicElement:cell indice:(int)indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.activityIndicatorView.isAnimating)
    {
        return;
    }
    
    [self.activityIndicatorView startAnimating];
    
    if (indexPath.row == 3)
    {
        self.modificationName = NO;
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        [alertView setDelegate:self];
        
        [alertView setTitle:@"Modification du malus"];
        [alertView setMessage:@"Veuillez rentrer un entier ou un réel positif."];
        
        [[alertView textFieldAtIndex:0] setPlaceholder:@"malus"];
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [[alertView textFieldAtIndex:0] setText:[NSString stringWithFormat:@"%f", [[self.dataArray objectAtIndex:indexPath.row] floatValue]]];
        
        [alertView addButtonWithTitle:@"Valider"];
        [alertView addButtonWithTitle:@"Annuler"];
        
        [self.activityIndicatorView stopAnimating];
        
        [alertView show];
    }
    
    if (indexPath.row == 1)
    {
        self.modificationName = YES;
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        [alertView setDelegate:self];
        
        [alertView setTitle:@"Modification du nom du questionnaire"];
        [alertView setMessage:@"Veuillez rentrer un nouveau nom"];
        
        [[alertView textFieldAtIndex:0] setPlaceholder:@"nom"];
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeAlphabet];
        [[alertView textFieldAtIndex:0] setText:[self.dataArray objectAtIndex:indexPath.row]];
        
        [alertView addButtonWithTitle:@"Valider"];
        [alertView addButtonWithTitle:@"Annuler"];
        
        [self.activityIndicatorView stopAnimating];
        
        [alertView show];
    }
    
    [self.activityIndicatorView stopAnimating];
}

@end
