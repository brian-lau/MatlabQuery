%https://code.google.com/p/edulinq/source/browse/src/Edulinq.Tests/ContainsTest.cs
function test_suite = testLinqContains
initTestSuite;


%%
function testNoMatchNoComparer
q = linq(0:5);
assertFalse(q.contains(6));

q = linq({'foo' 'bar' 'baz'});
assertFalse(q.contains('BAR'));

function testMatchNoComparer
q = linq(0:5);
assertTrue(q.contains(5));

q = linq({'foo' 'bar' 'baz'});
assertTrue(q.contains('bar'));

function testNoMatchCustomComparer
q = linq(0:5);
assertFalse(q.contains(@(x) (x/2)>3 ));

q = linq({'foo' 'bar' 'baz'});
assertFalse(q.contains(@(x) strcmpi(x,'gronk')));

function testMatchCustomComparer
q = linq(0:5);
assertTrue(q.contains(@(x) (x/5)==1));

q = linq({'foo' 'bar' 'baz'});
assertTrue(q.contains(@(x) strcmpi(x,'BAR')));
