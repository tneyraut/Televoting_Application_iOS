//
//  ListeQuestionsView.m
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "ListeQuestionsView.h"
#import "ListeReponsesView.h"

#import "SpecificTableViewCell.h"

@interface ListeQuestionsView ()

@property(nonatomic,strong) QuestionModel* _questionModel;
@property(nonatomic,strong) NSArray* _feedItems;

@property(nonatomic,strong) ReponseModel* _reponseModel;
@property(nonatomic,strong) NSArray* _reponses;

@property(nonatomic,strong) PropositionReponseModel* _propositionReponseModel;

@property(nonatomic,strong) ParticipantModel* _participantModel;

@property(nonatomic,strong) NSTimer *timerPause;

@property(nonatomic) int compteur;

@property(nonatomic,weak) NSString *nomQuestionaire;

@property(nonatomic,strong) Question *questionChoisie;

@property(nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic) BOOL creationFirstPropositionReponseDone;

@end

@implementation ListeQuestionsView

- (void) alert:(NSString *)titre message:(NSString *)contenu button:(NSString *)buttonTitle {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titre message:contenu delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil];
    [alert show];
}

- (void) creerPropositionReponse:(int)question_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._propositionReponseModel)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self._propositionReponseModel = [[PropositionReponseModel alloc] init];
        self._propositionReponseModel.delegate = self;
    }
    
    self.creationFirstPropositionReponseDone = YES;
    
    [self._propositionReponseModel creationPropositionReponse:self.user_id questionnaireID:self.questionnaireChoisi.questionnaire_id questionID:question_id];
}

- (void) propositionReponseActionDone
{
    [self.activityIndicatorView stopAnimating];
    
    if (self.creationFirstPropositionReponseDone)
    {
        [self.activityIndicatorView startAnimating];
        
        [self recuperationReponses:self.questionChoisie.question_id];
    }
}

- (void) recuperationQuestions
{
    if (!self._questionModel)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self._feedItems = [[NSArray alloc] init];
        self._questionModel = [[QuestionModel alloc] init];
        
        self._questionModel.delegate = self;
    }
    [self._questionModel getQuestionsByQuestionnaire:self.user_id questionnaireID:self.questionnaireChoisi.questionnaire_id];
}

- (void) questionDownloaded:(NSArray *)items
{
    if (!self.reponseEffectuee)
    {
        [self.activityIndicatorView stopAnimating];
    }
    
    self._feedItems = items;
    [self.tableView reloadData];
    if (self._feedItems.count == 0) {
        [self alert:@"Information" message:@"Vous avez déjà répondu à toutes les questions de ce questionnaire" button:@"OK"];
    }
}

- (void) recuperationReponses:(int)question_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._reponseModel)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self._reponses = [[NSArray alloc] init];
        self._reponseModel = [[ReponseModel alloc] init];
        self._reponseModel.delegate = self;
    }
    [self._reponseModel getReponsesByQuestion:question_id];
}

- (void) reponseDownloaded:(NSArray *)items
{
    self._reponses = items;
    
    ListeReponsesView *listeReponsesView = [[ListeReponsesView alloc] initWithStyle:UITableViewStylePlain];
    
    listeReponsesView.questionChoisie = self.questionChoisie;
    listeReponsesView.reponses = self._reponses;
    listeReponsesView.questionnaireChoisi = self.questionnaireChoisi;
    listeReponsesView.listeQuestionsView = self;
    
    [self.activityIndicatorView stopAnimating];
    
    [self.navigationController pushViewController:listeReponsesView animated:YES];
}

- (void) resultat
{
    if (!self.questionnaireChoisi.mode_examen) {
        if ([[self.reponsesEffectuees objectAtIndex:1] intValue] == 0) {
            [self alert:@"Information" message:@"Vous avez trouvé la/les bonne(s) réponse(s)" button:@"OK"];
        }
        else {
            NSString* message = @"Vous vous êtes trompés. La ou les bonne(s) réponse(s) étaient : ";
            for (int i=0; i<self.bonnesReponses.count; i++) {
                message = [message stringByAppendingString:[self.bonnesReponses objectAtIndex:i]];
                message = [message stringByAppendingString:@" ; "];
            }
            [self alert:@"Information" message:message button:@"OK"];
        }
    }
}

- (void) updateParticipant
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._participantModel)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self._participantModel = [[ParticipantModel alloc] init];
        self._participantModel.delegate = self;
    }
    
    
    
    [self._participantModel updateParticipant:self.user_id fautes:[[self.reponsesEffectuees objectAtIndex:1] intValue] bonnesReponses:[[self.reponsesEffectuees objectAtIndex:2] intValue] ident:self.questionnaireChoisi.questionnaire_id];
}

- (void) participantActionDone
{
    [self.activityIndicatorView stopAnimating];
    
    [self updatePropositionReponse];
}

- (void) updatePropositionReponse
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._propositionReponseModel)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self._propositionReponseModel = [[PropositionReponseModel alloc] init];
        self._propositionReponseModel.delegate = self;
    }
    
    for (int i=1; i<=[[self.reponsesEffectuees objectAtIndex:3] intValue]; i++) {
        if (i == 1) {
        [self._propositionReponseModel updatePropositionReponse:self.user_id questionnaireID:self.questionnaireChoisi.questionnaire_id questionID:[[self.reponsesEffectuees objectAtIndex:0] intValue] reponseID:[[self.reponsesEffectuees objectAtIndex:3+i] intValue]];
        }
        else {
            [self._propositionReponseModel creationPropositionReponseComplete:self.user_id questionnaireID:self.questionnaireChoisi.questionnaire_id questionID:[[self.reponsesEffectuees objectAtIndex:0] intValue] reponseID:[[self.reponsesEffectuees objectAtIndex:3+i] intValue]];
        }
    }
    
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
    
    [self.navigationItem setTitle:@"Liste des questions"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Liste des questions" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
    
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
    
    self.compteur = 0;
    
    self.creationFirstPropositionReponseDone = NO;
    
    if (self.reponseEffectuee)
    {
        [self resultat];
        
        [self updateParticipant];
        
        [self recuperationQuestions];
    }
    else
    {
        [self recuperationQuestions];
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
    return self._feedItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecificTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (self.compteur >= 0) {
        Question* uneQuestion = self._feedItems[indexPath.row];
        Question* premiereQuestion = self._feedItems[0];
        
        int n = uneQuestion.question_id - premiereQuestion.question_id + 1;
        
        [cell.textLabel setText: [NSString stringWithFormat:@"Question N°%d",n]];
        
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        
        [cell.imageView setImage:[UIImage imageNamed:@"iconQuestion.png"]];
    }
    
    self.compteur++;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    
    Question* question = self._feedItems[indexPath.row];
    self.questionChoisie = question;
    
    [self creerPropositionReponse:self.questionChoisie.question_id];
}

@end
