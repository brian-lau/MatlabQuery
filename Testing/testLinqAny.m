%https://code.google.com/p/edulinq/source/browse/src/Edulinq.Tests/AnyTest.cs
function test_suite = testLinqAny
initTestSuite;


%%
function testEmptySequenceWithoutPredicate
q = linq([]);
assertFalse(q.any());

q = linq({});
assertFalse(q.any());

function testEmptySequenceWithPredicate
q = linq([]);
assertFalse(q.any(@(x) x > 10));

q = linq({});
assertFalse(q.any(@(x) x > 10));

function testNonEmptySequenceWithoutPredicate
q = linq([1]);
assertTrue(q.any());

q = linq({1});
assertTrue(q.any());

function testNonEmptySequenceWithPredicateMatchingElement
q = linq([1 5 20 30]);
assertTrue(q.any(@(x) x > 10));

q = linq({'cat' 'dog' 'man'});
assertTrue(q.any(@(x) strcmpi(x,'man')));

function testNonEmptySequenceWithoutPredicateMatchingElement
q = linq([1 5 20 30]);
assertFalse(q.any(@(x) x > 30));

q = linq({'cat' 'dog' 'man'});
assertFalse(q.any(@(x) strcmpi(x,'woman')));
