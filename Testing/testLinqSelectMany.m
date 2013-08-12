function test_suite = testLinqWhere
initTestSuite;


%%
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
