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

function testPredicateWithIndexFailingFirstElement
l = linq(1:10);
result = l.skipWhile(@(x,index) x > 1 + index);
assertEqual(result.toArray,[1:10]);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
result = l.place(source).skipWhile(@(x,index) index + length(x) < 4);
assertEqual(result.toList,source);

function testPredicateMatchingSomeElements
l = linq(1:10);
result = l.skipWhile(@(x) x < 5);
assertEqual(result.toArray,[5:10]);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
result = l.place(source).skipWhile(@(x) length(x) < 5);
assertEqual(result.toList,source(4:end));

function testPredicateWithIndexMatchingSomeElements
l = linq([0, 1, 1, 2, 3, 5, 8, 13, 21]);
result = l.skipWhile(@(x,index) x <= index);
assertEqual(result.toArray,[8, 13, 21]);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
result = l.place(source).skipWhile(@(x,index) length(x) > index-1);
assertEqual(result.toList,source(5:end));

function testPredicateMatchingAllElements
l = linq(1:10);
result = l.skipWhile(@(x) x < 10);
assertEqual(result.toArray,[]);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
result = l.place(source).skipWhile(@(x) length(x) < 50);
assertEqual(result.toList,{});

function testPredicateWithIndexMatchingAllElements
l = linq([0, 1, 1, 2, 3, 5, 8, 13, 21]);
result = l.skipWhile(@(x,index) x <= index+100);
assertEqual(result.toArray,[]);

source = {'zero' 'one' 'two' 'three' 'four' 'five'};
result = l.place(source).skipWhile(@(x,index) length(x) > index-100);
assertEqual(result.toList,{});

