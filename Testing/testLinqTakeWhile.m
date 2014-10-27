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

function testPredicateWithIndexFailingFirstElement
l = linq(1:10);
result = l.takeWhile(@(x,index) x < index);
assertEqual(result.toArray,[]);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
% subtract 1 to match edulinq (0-offset versus 1-offset)
result = l.place(source).takeWhile(@(x,index) index - 1 + length(x) > 4);
assertEqual(result.toList,{});

function testPredicateMatchingSomeElements
l = linq(1:10);
result = l.takeWhile(@(x) x < 5);
assertEqual(result.toArray,[1:4]);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
result = l.place(source).takeWhile(@(x) length(x) < 5);
assertEqual(result.toList,source(1:3));

function testPredicateWithIndexMatchingSomeElements
% http://www.blackwasp.co.uk/LinqPartitioningIndexes.aspx
l = linq([0, 1, 1, 2, 3, 5, 8, 13, 21]);
result = l.takeWhile(@(x,index) x <= index);
assertEqual(result.toArray,[0, 1, 1, 2, 3, 5]);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
result = l.place(source).takeWhile(@(x,index) length(x) > index-1);
assertEqual(result.toList,source(1:4));

function testPredicateMatchingAllElements
l = linq(1:10);
result = l.takeWhile(@(x) x <= 10);
assertEqual(result.toArray,1:10);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
result = l.place(source).takeWhile(@(x) length(x) < 50);
assertEqual(result.toList,source);

function testPredicateWithIndexMatchingAllElements
l = linq([0, 1, 1, 2, 3, 5, 8, 13, 21]);
result = l.takeWhile(@(x,index) x <= index+100);
assertEqual(result.toArray,[0, 1, 1, 2, 3, 5, 8, 13, 21]);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
result = l.place(source).takeWhile(@(x,index) length(x) < 100);
assertEqual(result.toList,source);

