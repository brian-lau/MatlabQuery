%https://code.google.com/p/edulinq/source/browse/src/Edulinq.Tests/FirstOrDefaultTest.cs
function test_suite = testLinqFirstOrDefault
initTestSuite;


%%
function testNullSource
%?

function testNullPredicate
%?

function testEmptySequenceWithoutPredicate
q = linq([]);
assertEqual([],q.firstOrDefault())

function testSingleElementWithoutPredicate
q = linq(5);
assertEqual(5,q.firstOrDefault());

function testMultipleElementWithoutPredicate
q = linq([5 10]);
assertEqual(5,q.firstOrDefault());

function testEmptySequenceWithPredicate
q = linq([]);
assertEqual([],q.firstOrDefault(@(x) x > 3))

function testSingleElementWithMatchingPredicate
q = linq(5);
assertEqual(5,q.firstOrDefault(@(x) x > 3));

function testSingleElementWithNonMatchingPredicate
q = linq(5);
assertEqual([],q.firstOrDefault(@(x) x < 3));

function testMultipleElementWithNoMatchingPredicate
q = linq([ 1 2 2 1]);
assertEqual([],q.firstOrDefault(@(x) x > 3));

function testMultipleElementWithSingleMatchingPredicate
q = linq([ 1 2 5 2 1]);
assertEqual(5,q.firstOrDefault(@(x) x > 3));

function testMultipleElementWithMultipleMatchingPredicate
q = linq([ 1 2 5 10 2 1]);
assertEqual(5,q.firstOrDefault(@(x) x > 3));

