%https://code.google.com/p/edulinq/source/browse/src/Edulinq.Tests/AnyTest.cs
function test_suite = testLinqAll
initTestSuite;


%%
function testNullSource
%?

function testNullPredicate
%?

function testEmptySequenceReturnsTrue
q = linq([]);
assertTrue(q.all(@(x) x > 10));

q = linq({});
assertTrue(q.all(@(x) x > 10));

function testPredicateMatchingNoElements
q = linq([1 5 20 30]);
assertFalse(q.all(@(x) x < 0))

q = linq({1 5 20 30});
assertFalse(q.all(@(x) x < 0))

function testPredicateMatchingSomeElements
q = linq([1 5 8 9]);
assertFalse(q.all(@(x) x > 3))

q = linq({1 5 20 30});
assertFalse(q.all(@(x) x > 3))

function testPredicateMatchingAllElements
q = linq([1 5 8 9]);
assertTrue(q.all(@(x) x > 0))

q = linq({1 5 20 30});
assertTrue(q.all(@(x) x > 0))
