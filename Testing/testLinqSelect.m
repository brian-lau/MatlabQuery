function test_suite = testLinqSelect
initTestSuite;


%%
function testSimpleProjection
source = [1 5 2];
result = linq(source).select(@(x) x*2);
assertEqual(result.toArray,2*source);

source = {1 5 2};
result = linq(source).select(@(x) x*2);
assertEqual(result.toList,{2 10 4});

function testSimpleProjectionToDifferentType
source = [1 5 2];
result = linq(source).select(@(x) num2str(x));
assertEqual(result.toList,{'1' '5' '2'});

source = {1 5 2};
result = linq(source).select(@(x) num2str(x));
assertEqual(result.toList,{'1' '5' '2'});

function testEmptySource
source = [];
result = linq(source).select(@(x) x*2);
assertEqual(result.toArray,[]);

function testWithIndexSimpleProjection
source = [1 5 2];
result = linq(source).select(@(x,y) x + (y-1)*10);
% v0.3.0 allows index overload
% Using the index is not explicitly supported (I don't know how to get it
% dynamically. However, it can be hacked as a second input to the predicate
%result = linq(source).select(@(x,y) x + y*10,(1:length(source))-1);
assertEqual(result.toArray,[1 15 22]);

source = {1 5 2};
result = linq(source).select(@(x,y) x + (y-1)*10);
assertEqual(result.toArray,[1 15 22]);

function testWithIndexEmptySource
source = [];
q = linq(source);
q.select(@(x,index) x + index);
assertEqual(q.toArray,[]);

function testSimpleProjectionWithNew
% source = [1:10];
% result = linq(source)...
%    .select('new',{'source' @(x) x 'projection' @(x) x^2})...
%    .toArray();
% assertEqual([result.source],1:10);
% assertEqual([result.projection],(1:10).^2);

% This is probably the easier way to do this.....
source = [1:10];
result = linq(source)...
   .select(@(x) struct('source',x,'projection',x^2))...
   .toArray();
assertEqual([result.source],1:10);
assertEqual([result.projection],(1:10).^2);

function testCharProjectionWithNew
%http://www.hookedonlinq.com/SelectOperator.ashx
words =  {'aPPLE', 'BlUeBeRrY', 'cHeRry'};
% upperLower = linq(words)...
%    .select('new',{'Upper' @(x) upper(x) 'Lower' @(x) lower(x)})...
%    .toArray();
% assertEqual(upperLower(1).Upper,'APPLE');
% assertEqual(upperLower(2).Upper,'BLUEBERRY');
% assertEqual(upperLower(3).Upper,'CHERRY');
% assertEqual(upperLower(1).Lower,'apple');
% assertEqual(upperLower(2).Lower,'blueberry');
% assertEqual(upperLower(3).Lower,'cherry');

upperLower = linq(words)...
   .select(@(x) struct('Upper',upper(x),'Lower',lower(x)))...
   .toArray();
assertEqual(upperLower(1).Upper,'APPLE');
assertEqual(upperLower(2).Upper,'BLUEBERRY');
assertEqual(upperLower(3).Upper,'CHERRY');
assertEqual(upperLower(1).Lower,'apple');
assertEqual(upperLower(2).Lower,'blueberry');
assertEqual(upperLower(3).Lower,'cherry');
