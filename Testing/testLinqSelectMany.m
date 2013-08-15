function test_suite = testLinqWhere
initTestSuite;


%%
function testNullPredicateThrowsNullArgumentException
f = @() linq(1:10).selectMany(); % missing predicate
assertExceptionThrown(f,'linq:selectMany:InputNumber')

%http://www.hookedonlinq.com/SelectManyOperator.ashx
function testSplitStr
sentence = {'The quick brown' 'fox jumped over' 'the lazy dog.'};
words = linq(sentence).selectMany(@(s) strread(s,'%s','delimiter',' ')');
assertEqual(words.toList,...
   {'The'  'quick'  'brown'  'fox'  'jumped'  'over'  'the'  'lazy'  'dog.'});

%https://code.google.com/p/edulinq/source/browse/src/Edulinq.Tests/SelectManyTest.cs
function testSelectManyTest
numbers = [3 5 20 15];
query = linq(numbers).selectMany(@(x) num2cell(num2str(x)));
assertEqual(query.toList,{'3' '5' '2' '0' '1' '5'});

function testSimpleFlattenWithIndex
numbers = [3 5 20 15];
% Using the index is not explicitly supported (I don't know how to get it
% dynamically. However, it can be hacked as a second input to the predicate
query = linq(numbers).selectMany(@(x,y) num2cell(num2str(x+y)),0:3);
assertEqual(query.toList,{'3' '6' '2' '2' '1' '8'});

function testFlattenWithProjection
numbers = [3 5 20 15];
query = linq(numbers).selectMany(@(x) num2cell(num2str(x)),...
   @(x,c) [num2str(x) ': ' c]);
assertEqual(query.toList,{'3: 3', '5: 5', '20: 2', '20: 0', '15: 1', '15: 5'});

function FlattenWithProjectionAndIndex
numbers = [3 5 20 15];
% Using the index is not explicitly supported (I don't know how to get it
% dynamically. However, it can be hacked as a second input to the FIRST predicate
query = linq(numbers).selectMany(@(x,y) num2cell(num2str(x+y)),...
   @(x,c) [num2str(x) ': ' c],[0 1 2 3]);
assertEqual(query.toList,{'3: 3', '5: 6', '20: 2', '20: 2', '15: 1', '15: 8'});

% Location of additional inputs doesn't matter, they always go to the first
% predicate
query = linq(numbers).selectMany(@(x,y) num2cell(num2str(x+y)),[0 1 2 3],...
   @(x,c) [num2str(x) ': ' c]);
assertEqual(query.toList,{'3: 3', '5: 6', '20: 2', '20: 2', '15: 1', '15: 8'});

numbers = {3 5 20 15};
query = linq(numbers).selectMany(@(x,y) num2cell(num2str(x+y)),...
   @(x,c) [num2str(x) ': ' c],[0 1 2 3]);
assertEqual(query.toList,{'3: 3', '5: 6', '20: 2', '20: 2', '15: 1', '15: 8'});

query = linq(numbers).selectMany(@(x,y) num2cell(num2str(x+y)),[0 1 2 3],...
   @(x,c) [num2str(x) ': ' c]);
assertEqual(query.toList,{'3: 3', '5: 6', '20: 2', '20: 2', '15: 1', '15: 8'});

%http://www.code-magazine.com/Article.aspx?quickid=090043
function testEvenOdd

odds = (1:2:8);
evens = (2:2:8);
values = linq(odds).selectMany(@(x,y) y,{evens},'replicateInput',true,...
   'new',{'o' @(x) x 'e' @(y) y})...
   .select('new',{'oddNumber' @(x) x.o 'evenNumber' @(x) x.e 'sum' @(x) x.o+x.e});
% values = linq(odds).selectMany(@(x,y) y,num2cell(evens),'replicateInput',true,...
%    'new',{'o' @(x) x 'e' @(y) y})...
%    .select('new',{'oddNumber' @(x) x.o 'evenNumber' @(x) x.e 'sum' @(x) x.o+x.e});

% Works for cell arrays
odds = num2cell(1:2:8);
evens = num2cell(2:2:8);
values = linq(odds).selectMany(@(x,y) y,evens,'replicateInput',true,...
   'new',{'o' @(x) x 'e' @(y) y})...
   .select('new',{'oddNumber' @(x) x.o 'evenNumber' @(x) x.e 'sum' @(x) x.o+x.e});

% Somewhat easier syntax when the inner object is this simple
values = linq(odds).selectMany(@(x) num2cell(2:2:8),...
   'new',{'o' @(x) x 'e' @(y) y})...
   .select('new',{'oddNumber' @(x) x.o 'evenNumber' @(x) x.e 'sum' @(x) x.o+x.e});


function testNestedStruct
%http://blogs.interknowlogy.com/2008/10/10/use-linqs-selectmany-method-to-flatten-collections/
Players(1).Name = 'Rivers'; Players(1).Age = 20; Players(1).HomeState = 'CA';
Players(2).Name = 'Tomlinson'; Players(2).Age = 35; Players(2).HomeState = 'WA';
Players(3).Name = 'Gates'; Players(3).Age = 40; Players(3).HomeState = 'NY';
Teams(1).Name = 'Chargers';
Teams(1).HomeState = 'CA';
Teams(1).Players = Players;
Teams(1).NumberOfWins = 10;
Players(1).Name = 'Cutler'; Players(1).Age = 25; Players(1).HomeState = 'CA';
Players(2).Name = 'Bailey'; Players(2).Age = 35; Players(2).HomeState = 'NC';
Players(3).Name = 'Marshall'; Players(3).Age = 40; Players(3).HomeState = 'FL';
Players(4).Name = 'Frank'; Players(4).Age = 40; Players(3).HomeState = 'SD';
Teams(2).Name = 'Broncos';
Teams(2).HomeState = 'CO';
Teams(2).Players = Players;
Teams(2).NumberOfWins = 0;
Leagues(1).Name = 'AFC-West';
Leagues(1).ID = 1;
Leagues(1).Teams = Teams;
clear Teams Players;

Players(1).Name = 'Manning'; Players(1).Age = 29; Players(1).HomeState = 'MA';
Players(2).Name = 'Addai'; Players(2).Age = 35; Players(2).HomeState = 'CA';
Players(3).Name = 'Vinatieri'; Players(3).Age = 40; Players(3).HomeState = 'MN';
Teams(1).Name = 'Colts';
Teams(1).HomeState = 'IN';
Teams(1).Players = Players;
Teams(1).NumberOfWins = 2;
Leagues(2).Name = 'AFC-South';
Leagues(2).ID = 2;
Leagues(2).Teams = Teams;
clear Teams Players;

allTeams = linq(Leagues).selectMany(@(x) x.Teams);
assertEqual(allTeams.select(@(x) x.Name).toList,{'Chargers' 'Broncos' 'Colts'});

allPlayers = linq(Leagues).selectMany(@(x) x.Teams)...
   .selectMany(@(x) x.Players);
assertEqual(allPlayers.select(@(x) x.Name).toList,...
   {'Rivers' 'Tomlinson' 'Gates' 'Cutler' 'Bailey' 'Marshall' 'Frank' 'Manning' 'Addai' 'Vinatieri'});

onlyYoungPlayers = linq(Leagues).selectMany(@(x) x.Teams)...
   .selectMany(@(x) x.Players)...
   .where(@(x) x.Age < 30);
assertEqual(onlyYoungPlayers.select(@(x) x.Name).toList,...
   {'Rivers' 'Cutler' 'Manning'});

players = linq(Leagues).selectMany(@(x) x.Teams)...
   .where(@(x) x.NumberOfWins > 2)...
   .selectMany(@(x) x.Players)...
   .where(@(x) strcmp(x.HomeState,'CA'));
assertEqual(players.select(@(x) x.Name).toArray,'Rivers');

% Cannot reproduce as presented because I can't drill down through
% structures recursively?
teamsAndTheirLeagues = linq(Leagues)...
   .selectMany(@(x) x.Teams,'new',{'league' @(l) l 'team' @(t) t})...
   .select('new',{'league' @(a) a.league.Name ...
                  'teamCount' @(a) numel(a.league.Teams) ...
                  'team' @(a) a.team...
                  'playerCount' @(a) numel(a.team.Players)})...
   .where(@(x) (x.playerCount > 3) && (x.teamCount < 10))...
   .toArray();

assertEqual(teamsAndTheirLeagues.league,'AFC-West');
assertEqual(teamsAndTheirLeagues.teamCount,2);
assertEqual(teamsAndTheirLeagues.team.Name,'Broncos');
assertEqual(teamsAndTheirLeagues.team.HomeState,'CO');
assertEqual(teamsAndTheirLeagues.team.NumberOfWins,0);
assertEqual(teamsAndTheirLeagues.playerCount,4);

% function testNestedStruct2
% patient(1).name = 'Brian Lau';
% patient(1).billing = 28.50;
% patient(1).test = {'a' 'b' 'c'};
% patient(1).testResult = [1 2 3];
% 
% patient(2).name = 'C Karachi';
% patient(2).billing = 18.50;
% patient(2).test = {'e' 'f'};
% patient(2).testResult = [4 5];
% 
% patient(3).name = 'Elsa Agid';
% patient(3).billing = 1.50;
% patient(3).test = {'g' 'h' 'j' 'k'};
% patient(3).testResult = [6 7 8 9];
% 
% patient(4).name = 'Michelle Lau';
% patient(4).billing = 2.50;
% patient(4).test = {'g' 'h' 'j' 'k'};
% patient(4).testResult = [6 7 8 9];
% 
% patient(5).name = 'Chris Lau';
% patient(5).billing = 200.50;
% patient(5).test = {'g' 'h' 'j' 'k'};
% patient(5).testResult = [6 7 8 9];
% 
% linq(patient).where(@(x) ~isempty(strfind(x.name,'Lau'))>0 )...
%    .select(@(x) x.billing).toArray
% 
% linq(patient).where(@(x) ~isempty(strfind(x.name,'Lau'))>0 )...
%    .where(@(x) x.billing > 100)...
%    .select(@(x) x.name).toArray
% 
% linq(patient).where(@(x) any(strcmpi(x.test,'g'))>0 )...
%    .select(@(x) x.name)...
%    .toList
% 
% linq(patient).where(@(x) any(strcmpi(x.test,'g'))>0 )...
%    .toArray.testResult
% 
% linq(patient).selectMany(@(x) upper(x.test),'new',{'name' @(x) upper(x.name) 'test' @(y) y})...
%    .select(@(x) fprintf('%s - %s\n',x.name,x.test));
% 
% linq(patient).selectMany(@(x) x.testResult,'new',{'name' @(x) upper(x.name) 'op' @(x) x*2})...
%    .select(@(x) fprintf('%s - %1.3f\n',x.name,x.op));
% 
% c = linq(patient).select('new',{'a' @(x) x.name 'b' @(x) x.test 'c' @(x) sum(x.testResult)})...
%    .toList
% 
% s(1) = struct('customer','george','purchases',[]);
% s(1).purchases = struct('item','wrench','cost',55);
% s(1).purchases(2) = struct('item','coat','cost',25);
% s(2) = struct('customer','frank','purchases',[]);
% s(2).purchases = struct('item','steak','cost',15);
% s(2).purchases(2) = struct('item','dog','cost',250);
% s(2).purchases(3) = struct('item','flowers','cost',50);
% 
% d = linq(s).selectMany(@(x) x.purchases,...
%    'new',{'name' @(x) upper(x.customer) 'test' @(y) y.item}...
%    )...
%    .toList


