%https://code.google.com/p/edulinq/source/browse/src/Edulinq.Tests/JoinTest.cs
function test_suite = testLinqJoin
initTestSuite;


%%

function testSimpleJoin
%http://www.dotnetperls.com/join
outer = linq([4 3 0]);
result = outer.join([5 4 2],@(x) x+1,@(y) y,@(x,y) x).toArray;
assertEqual(result,[4 3]);

customer(1).id = 5;
customer(1).name = 'Sam';
customer(2).id = 6;
customer(2).name = 'Dave';
customer(3).id = 7;
customer(3).name = 'Julia';
customer(4).id = 8;
customer(4).name = 'Sue';

order(1).id = 5;
order(1).product = 'Book';
order(2).id = 6;
order(2).product = 'Game';
order(3).id = 7;
order(3).product = 'Computer';
order(4).id = 8;
order(4).product = 'Shirt';

% NEW NOT DONE
outer = linq(customer);
result = outer.join(order,@(x) x.id, @(y) y.id,...
   @(x,y) [x.name ' bought ' y.product]);

function testSimpleJoin2
outer = linq({ 'first', 'second', 'third'});
inner = { 'essence', 'offer', 'eating', 'psalm' };
outer.join(inner,@(x) x(1),@(y) y(2),@(x,y) [x ':' y])