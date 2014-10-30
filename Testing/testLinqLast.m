%https://code.google.com/p/edulinq/source/browse/src/Edulinq.Tests/LastTest.cs
function test_suite = testLinqLast
initTestSuite;


%%
function testNullSource
%?

function testNullPredicate
%?

function testEmptySequenceWithoutPredicate
q = linq([]);
f = @() q.last();
assertExceptionThrown(f,'linq:last:Invalid')

function testSingleElementWithoutPredicate
q = linq(5);
assertEqual(5,q.last());

function testMultipleElementWithoutPredicate
q = linq([5 10]);
assertEqual(10,q.last());

function testEmptySequenceWithPredicate
q = linq([]);
f = @() q.last(@(x) x > 3);
assertExceptionThrown(f,'linq:last:Invalid')

function testSingleElementWithMatchingPredicate
q = linq(5);
assertEqual(5,q.last(@(x) x > 3));

function testSingleElementWithNonMatchingPredicate
q = linq(5);
f = @() q.last(@(x) x < 3);
assertExceptionThrown(f,'linq:last:Invalid')

function testMultipleElementWithNoMatchingPredicate
q = linq([ 1 2 2 1]);
f = @() q.last(@(x) x > 3);
assertExceptionThrown(f,'linq:last:Invalid')

function testMultipleElementWithSingleMatchingPredicate
q = linq([ 1 2 5 2 1]);
assertEqual(5,q.last(@(x) x > 3));

function testMultipleElementWithMultipleMatchingPredicate
q = linq([ 1 2 5 10 2 1]);
assertEqual(10,q.last(@(x) x > 3));

