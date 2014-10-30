%https://code.google.com/p/edulinq/source/browse/src/Edulinq.Tests/AnyTest.cs
function test_suite = testLinqFirst
initTestSuite;


%%
function testNullSource
%?

function testNullPredicate
%?

function testEmptySequenceWithoutPredicate
q = linq([]);
f = @() q.first();
assertExceptionThrown(f,'linq:first:Invalid')

function testSingleElementWithoutPredicate
q = linq(5);
assertEqual(5,q.first());

function testMultipleElementWithoutPredicate
q = linq([5 10]);
assertEqual(5,q.first());

function testEmptySequenceWithPredicate
q = linq([]);
f = @() q.first(@(x) x > 3);
assertExceptionThrown(f,'linq:first:Invalid')

function testSingleElementWithMatchingPredicate
q = linq(5);
assertEqual(5,q.first(@(x) x > 3));

function testSingleElementWithNonMatchingPredicate
q = linq(5);
f = @() q.first(@(x) x < 3);
assertExceptionThrown(f,'linq:first:Invalid')

function testMultipleElementWithNoMatchingPredicate
q = linq([ 1 2 2 1]);
f = @() q.first(@(x) x > 3);
assertExceptionThrown(f,'linq:first:Invalid')

function testMultipleElementWithSingleMatchingPredicate
q = linq([ 1 2 5 2 1]);
assertEqual(5,q.first(@(x) x > 3));

function testMultipleElementWithMultipleMatchingPredicate
q = linq([ 1 2 5 10 2 1]);
assertEqual(5,q.first(@(x) x > 3));

