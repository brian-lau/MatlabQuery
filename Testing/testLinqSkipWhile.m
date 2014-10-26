%https://code.google.com/p/edulinq/source/browse/src/Edulinq.Tests/SkipTest.cs
function test_suite = testLinqSkipWhile
initTestSuite;


%%
function testEmptySource
l = linq([]);
f = @() l.skipWhile(@(x) x > 3);
assertExceptionThrown(f,'linq:skip:InputValue')

function testPredicateFailingFirstElement
l = linq(1:10);
result = l.skipWhile(@(x) x > 1);
assertEqual(result.toArray,[1:10]);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
result = l.place(source).skipWhile(@(x) length(x) < 4);
assertEqual(result.toList,source);

function testPredicateMatchingSomeElements
l = linq(1:10);
result = l.skipWhile(@(x) x < 5);
assertEqual(result.toArray,[5:10]);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
result = l.place(source).skipWhile(@(x) length(x) < 5);
assertEqual(result.toList,source(4:end));

% source = {'zero' 'one' 'two' 'three' 'four' 'five'};
% result = l.place(source).skipWhile(@(x,y) length(x) > y,1:length(source));
% assertEqual(result.toList,source(4:end));
% 

function testPredicateMatchingAllElements
l = linq(1:10);
result = l.skipWhile(@(x) x < 10);
assertEqual(result.toArray,[]);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
result = l.place(source).skipWhile(@(x) length(x) < 50);
assertEqual(result.toList,{});

