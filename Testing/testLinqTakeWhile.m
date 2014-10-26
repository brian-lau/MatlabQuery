%https://code.google.com/p/edulinq/source/browse/src/Edulinq.Tests/SkipTest.cs
function test_suite = testLinqTakeWhile
initTestSuite;


%%
function testEmptySource
l = linq([]);
f = @() l.takeWhile(@(x) x > 3);
assertExceptionThrown(f,'linq:take:InputValue')

function testPredicateFailingFirstElement
l = linq(1:10);
result = l.takeWhile(@(x) x < 1);
assertEqual(result.toArray,[]);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
result = l.place(source).takeWhile(@(x) length(x) > 4);
assertEqual(result.toList,{});

function testPredicateMatchingSomeElements
l = linq(1:10);
result = l.takeWhile(@(x) x < 5);
assertEqual(result.toArray,[1:4]);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
result = l.place(source).takeWhile(@(x) length(x) < 5);
assertEqual(result.toList,source(1:3));

function testPredicateMatchingAllElements
l = linq(1:10);
result = l.takeWhile(@(x) x <= 10);
assertEqual(result.toArray,1:10);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
result = l.place(source).takeWhile(@(x) length(x) < 50);
assertEqual(result.toList,source);

