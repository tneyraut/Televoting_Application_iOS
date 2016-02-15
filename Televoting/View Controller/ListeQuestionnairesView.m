//
//  ListeQuestionnairesView.m
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "ListeQuestionnairesView.h"
#import "ListeCoursView.h"
#import "ListeQuestionsView.h"
#import "QuestionsReponsesView.h"

#import "Questionnaire.h"
#import "Question.h"

#import "SpecificTableViewCell.h"

@interface ListeQuestionnairesView () <UISearchBarDelegate>

@property(nonatomic,strong) QuestionnaireModel* _questionnaireModel;
@property(nonatomic,strong) NSArray* _feedItems;

@property(nonatomic,strong) QuestionModel* _questionModel;
@property(nonatomic,strong) NSArray* questions;

@property(nonatomic,strong) ReponseModel* _reponseModel;
@property(nonatomic,strong) NSArray* reponses;

@property(nonatomic,strong) PropositionReponseModel* _propositionReponseModel;

@property(nonatomic,weak) NSString *nomCours;

@property(nonatomic) int compteur;

@property(nonatomic,strong) NSTimer *timerPause;
@property(nonatomic) BOOL pauseEffectuee;

@property(nonatomic,strong) Questionnaire *questionnaireChoisi;

@property(nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic) BOOL research;

@property(nonatomic) UITapGestureRecognizer *singleFingerTap;

@end

@implementation ListeQuestionnairesView

- (void) alert:(NSString *)titre message:(NSString *)contenu button:(NSString *)buttonTitle {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titre message:contenu delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil];
    [alert show];
}

- (void) initialisationView
{
    [self.navigationItem setTitle:@"Liste des questionnaires"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Liste des questionnaires" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) recuperationQuestionnaires:(int)coursID
{
    if (!self._questionnaireModel)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    
        self._feedItems = [[NSArray alloc] init];
        self._questionnaireModel = [[QuestionnaireModel alloc] init];
        
        self._questionnaireModel.delegate = self;
    }
    [self._questionnaireModel getQuestionnairesByCours:coursID user_id:self.user_id];
}

- (void) questionnaireDownloaded:(NSArray *)items
{
    [self.activityIndicatorView stopAnimating];
    
    self._feedItems = items;
    
    [self.tableView reloadData];
    
    if (self._feedItems.count == 0)
    {
        [self alert:@"Information" message:@"Vous avez répondu à tous les questionnaires de ce cours" button:@"OK"];
    }
    else if (self.research && ![self.searchBar.text isEqualToString:@""])
    {
        [self searchTableList];
    }
}

- (void) recuperationQuestions:(int)questionnaireId
{
    if (!self._questionModel)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.questions = [[NSArray alloc] init];
        self._questionModel = [[QuestionModel alloc] init];
        
        self._questionModel.delegate = self;
    }
    [self._questionModel getQuestionsByQuestionnaire:self.user_id questionnaireID:questionnaireId];
}

- (void) questionDownloaded:(NSArray *)items
{
    self.questions = items;
    if (self.questions.count == 0) {
        [self.activityIndicatorView stopAnimating];
        
        [self alert:@"Information" message:@"Vous avez déjà répondu à ce questionnaire" button:@"OK"];
    }
    else {
        self.compteur = 0;
        [self preparationDesDonnees];
    }
}

- (void) recuperationReponses:(int)questionId
{
    if (!self._reponseModel)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.reponses = [[NSArray alloc] init];
        self._reponseModel = [[ReponseModel alloc] init];
        
        self._reponseModel.delegate = self;
    }
    [self._reponseModel getReponsesByQuestion:questionId];
}

- (void) reponseDownloaded:(NSArray *)items
{
    self.reponses = items;
    [self.questionsReponses addObject:self.reponses];
    self.pauseEffectuee = YES;
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
    
    [self.activityIndicatorView startAnimating];
    
    [self recuperationQuestionnaires:self.cours_id];
    
    [super viewDidAppear:animated];
}

- (void) creerPropositionReponse:(int)questionId questionnaire:(int)questionnaireId {
    if (!self._propositionReponseModel)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self._propositionReponseModel = [[PropositionReponseModel alloc] init];
        self._propositionReponseModel.delegate = self;
    }
    [self._propositionReponseModel creationPropositionReponse:self.user_id questionnaireID:questionnaireId questionID:questionId];
}

- (void) propositionReponseActionDone
{
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
    
    Questionnaire* item = self._feedItems[indexPath.row - 1];
    
    [cell.textLabel setText: item.questionnaire_name];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    [cell.imageView setImage:[UIImage imageNamed:@"iconQuestionnaire.png"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.activityIndicatorView isAnimating] || indexPath.row == 0)
    {
        return;
    }
    
    [self.activityIndicatorView startAnimating];
    
    Questionnaire* questionnaire = self._feedItems[indexPath.row - 1];
    self.questionnaireChoisi = questionnaire;
    
    if (self.questionnaireChoisi.pause)
    {
        ListeQuestionsView *listeQuestionsView = [[ListeQuestionsView alloc] initWithStyle:UITableViewStylePlain];
        
        listeQuestionsView.questionnaireChoisi = self.questionnaireChoisi;
        listeQuestionsView.user_id = self.user_id;
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController pushViewController:listeQuestionsView animated:YES];
    }
    else
    {
        [self recuperationQuestions:self.questionnaireChoisi.questionnaire_id];
        self.questionsReponses = [[NSMutableArray alloc] init];
    }
}

- (void) pause {
    if (self.pauseEffectuee) {
        [self.timerPause invalidate];
        [self preparationDesDonnees];
    }
}

- (void) preparationDesDonnees {
    if (self.compteur >= self.questions.count)
    {
        [self.activityIndicatorView stopAnimating];
        
        QuestionsReponsesView *questionsReponsesView =[[QuestionsReponsesView alloc] initWithStyle:UITableViewStylePlain];
        
        questionsReponsesView.listeQuestionnairesView = self;
        questionsReponsesView.user_id = self.user_id;
        questionsReponsesView.questionnaireChoisi = self.questionnaireChoisi;
        questionsReponsesView.questionsReponses = self.questionsReponses;
        
        [self.navigationController pushViewController:questionsReponsesView animated:YES];
    }
    else
    {
        Question* uneQuestion = [self.questions objectAtIndex:self.compteur];
        
        [self.questionsReponses addObject:uneQuestion];
        
        [self creerPropositionReponse:uneQuestion.question_id questionnaire:self.questionnaireChoisi.questionnaire_id];
        
        [self recuperationReponses:uneQuestion.question_id];
        
        self.compteur++;
        self.pauseEffectuee = NO;
        
        self.timerPause = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(pause) userInfo:nil repeats:YES];
    }
}

- (void) searchTableList
{
    [self.activityIndicatorView startAnimating];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    BOOL elementFound = NO;
    
    for (int i=0;i<self._feedItems.count;i++)
    {
        Questionnaire *questionnaire = [self._feedItems objectAtIndex:i];
        
        if ([questionnaire.questionnaire_name rangeOfString:self.searchBar.text].location != NSNotFound)
        {
            elementFound = YES;
            
            [array addObject:questionnaire];
        }
    }
    
    if (elementFound)
    {
        self._feedItems = array;
        
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
    
    [self recuperationQuestionnaires:self.cours_id];
}

- (void) toucheDone
{
    self.research = NO;
    
    [self.view removeGestureRecognizer:self.singleFingerTap];
    
    [self.view endEditing:YES];
    
    [self recuperationQuestionnaires:self.cours_id];
}

@end
