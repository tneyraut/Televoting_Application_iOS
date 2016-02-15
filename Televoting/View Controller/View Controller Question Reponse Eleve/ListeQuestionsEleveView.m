//
//  ListeQuestionsEleveView.m
//  Televoting
//
//  Created by Thomas Mac on 26/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "ListeQuestionsEleveView.h"
#import "ListeReponsesQuestionEleveView.h"

#import "SpecificTableViewCell.h"

@interface ListeQuestionsEleveView () <UIAlertViewDelegate>

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) QuestionEleveModel *_questionEleveModel;

@property(nonatomic, strong) NSMutableArray *questionsEleveArray;

@property(nonatomic, strong) NSMutableArray *reponsesQuestionEleveArray;

@property(nonatomic) BOOL creationQuestion;

@end

@implementation ListeQuestionsEleveView

- (void) initialisationView {
    
    [self.navigationItem setTitle:@"Liste des questions posées"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    if (!self.user.professeur)
    {
        UIBarButtonItem *buttonAddQuestion = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(actionListenerButtonAddQuestion)];
        
        [buttonAddQuestion setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
        
        [self.navigationItem setRightBarButtonItem:buttonAddQuestion];
    }
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Liste des questions posées" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) actionListenerButtonAddQuestion
{
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] init];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView setDelegate:self];
    
    [alertView setTitle:@"Poser une question"];
    [alertView setMessage:@"Veuillez rentrer la question que vous souhaitez poser."];
    
    [[alertView textFieldAtIndex:0] setPlaceholder:@"Question"];
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeAlphabet];
    
    [alertView addButtonWithTitle:@"Valider"];
    [alertView addButtonWithTitle:@"Annuler"];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Valider"])
    {
        for (int i=0;i<self.questionsEleveArray.count;i++)
        {
            question_eleve *questionEleve = [self.questionsEleveArray objectAtIndex:i];
            if ([questionEleve.question isEqualToString:[alertView textFieldAtIndex:0].text])
            {
                UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Cette question existe déjà." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertError show];
                
                return;
            }
        }
        [self creerQuestionEleve:self.user.user_id cours_id:self.coursSelected.cours_id question:[alertView textFieldAtIndex:0].text];
    }
}

- (void) downloadQuestionsReponsesEleve:(int)cours_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._questionEleveModel)
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self._questionEleveModel = [[QuestionEleveModel alloc] init];
        self.questionsEleveArray = [[NSMutableArray alloc] init];
        self.reponsesQuestionEleveArray = [[NSMutableArray alloc] init];
        
        self._questionEleveModel.delegate = self;
    }
    
    [self._questionEleveModel getQuestionsAndReponsesEleveByCours:cours_id];
}

- (void) creerQuestionEleve:(int)user_id cours_id:(int)cours_id question:(NSString*)question
{
    [self.activityIndicatorView startAnimating];
    
    self.creationQuestion = YES;
    
    [self._questionEleveModel creationQuestionEleve:user_id cours_id:cours_id question:question];
}

- (void) questionsEleveDownloaded:(NSArray *)items
{
    if (self.creationQuestion)
    {
        self.creationQuestion = NO;
        
        [self.activityIndicatorView stopAnimating];
        
        [self downloadQuestionsReponsesEleve:self.coursSelected.cours_id];
        
        return;
    }
    
    self.questionsEleveArray = items[0];
    
    self.reponsesQuestionEleveArray = items[1];
    
    if (self.questionsEleveArray.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Aucune question enregistrée pour ce cours" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        [self.activityIndicatorView stopAnimating];
        
        return;
    }
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
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
    
    [self.activityIndicatorView startAnimating];
    
    [self downloadQuestionsReponsesEleve:self.coursSelected.cours_id];
    
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.questionsEleveArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.imageView setImage:[UIImage imageNamed:@"iconQuestion.png"]];
    
    question_eleve *questionEleve = [[question_eleve alloc] init];
    
    questionEleve = [self.questionsEleveArray objectAtIndex:indexPath.row];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, 5.0f, 2 * self.view.frame.size.width / 3 - 30.0f, cell.frame.size.height - 10.0f)];
    
    [textView setText:questionEleve.question];
    [textView setTextColor:[UIColor blackColor]];
    [textView setFont:[UIFont fontWithName:textView.font.fontName size:15.0]];
    [textView setEditable:NO];
    
    [cell addSubview:textView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    question_eleve *questionEleve = [[question_eleve alloc] init];
    
    questionEleve = self.questionsEleveArray[indexPath.row];
    
    ListeReponsesQuestionEleveView *listeReponsesQuestionEleveView = [[ListeReponsesQuestionEleveView alloc] initWithStyle:UITableViewStylePlain];
    
    listeReponsesQuestionEleveView.question_eleve_selected = questionEleve;
    listeReponsesQuestionEleveView.reponsesQuestionEleveArray = self.reponsesQuestionEleveArray[indexPath.row];
    listeReponsesQuestionEleveView.user = self.user;
    
    [self.navigationController pushViewController:listeReponsesQuestionEleveView animated:YES];
    
    [self.activityIndicatorView stopAnimating];
}

@end
