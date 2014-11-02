function test_suite = testLinqWhere
initTestSuite;


%%
function testInvalidFunctionException
f = @() linq(1:10).where('@(x) dogs');
assertExceptionThrown(f,'checkFunc:InputFormat')

function testLinq1
numbers = [5 4 1 3 9 8 6 7 2 0];
q = linq(numbers);
q.where(@(n) n < 5);
%fprintf('Numbers < 5: %g\n',q.toArray)
assertEqual(q.toArray,[4 1 3 2 0]);

clear q
a = linq(numbers).where(@(n) n < 5).toArray;
assertEqual(a,[4 1 3 2 0]);

function testLinq2
products(1:100) = struct('name',[],'UnitsInStock',[]);
for i = 1:100
   products(i).name = num2str(i);
   r = randi(100);
   if r > 50
      products(i).UnitsInStock = r;
   else
      products(i).UnitsInStock = 0;
   end
end

soldOutProducts = linq(products).where(@(p) p.UnitsInStock == 0)...
   .select(@(x) x.name,'UniformOutput',false).toList;

% for i = 1:length(soldOutProducts)
%    fprintf('%s is sold out !\n',soldOutProducts{i});
% end

ind = [products.UnitsInStock] == 0;
soldOutProducts2 = {products(ind).name};
assertEqual(soldOutProducts,soldOutProducts2);

function testLinq3
% Data as struct array
products(1:100) = struct('name',[],'UnitsInStock',[],'UnitPrice',[]);
for i = 1:100
   products(i).name = num2str(i);
   r = randi(100);
   if r > 50
      products(i).UnitsInStock = r;
   else
      products(i).UnitsInStock = 0;
   end
   products(i).UnitPrice = rand*10;
end

expensiveInStockProducts = linq(products).where(@(p) (p.UnitsInStock > 0) && (p.UnitPrice > 3))...
   .select(@(x) x.name,'UniformOutput',false).toList;

ind = ([products.UnitsInStock] > 0) & ([products.UnitPrice] > 3);
expensiveInStockProducts2 = {products(ind).name};
assertEqual(expensiveInStockProducts,expensiveInStockProducts2);

function testLinq5
digits = {'zero' 'one' 'two' 'three' 'four' 'five' 'six' 'seven' 'eight' 'nine'};

q = linq(digits);
shortDigits = q.where(@(digit,index) length(digit) < index-1).toList;
% v0.3.0 allows index overload
%shortDigits = q.where(@(digit,index) length(digit) < index,0:9).toList;
%fprintf('The word %s is shorter than its value.\n',shortDigits{:});
assertEqual(shortDigits,{'five' 'six' 'seven' 'eight' 'nine'});

%http://msmvps.com/blogs/jon_skeet/archive/2010/09/03/reimplementing-linq-to-objects-part-2-quot-where-quot.aspx
%https://code.google.com/p/edulinq/source/browse/src/Edulinq.Tests/WhereTest.cs

% function NullSourceThrowsNullArgumentException
% source = [];
% % Matlab doesn't allow nesting anon funcs?
% f = @(x) linq(x).where(@iseven);
% assertExceptionThrown(f(source),'linq:where:InputFormat')

function testNullPredicateThrowsNullArgumentException
f = @() linq(1:10).where(); % missing predicate
assertExceptionThrown(f,'linq:where:InputNumber')

function testSimpleFiltering
source = [1 3 4 2 8 1];
result = linq(source).where(@(x) x < 4).toArray;
assertEqual(result,[1 3 2 1])

source = {1 3 4 2 8 1};
result = linq(source).where(@(x) x < 4);
assertEqual(result.toArray,[1 3 2 1])
assertEqual(result.toList,{1 3 2 1})

function testWithIndexSimpleFiltering
source = [1 3 4 2 8 1];
result = linq(source).where(@(x,index) x < index).toArray;
% v0.3.0 allows index overload
% Using the index is not explicitly supported (I don't know how to get it
% dynamically. However, it can be hacked as a second input to the predicate
%result = linq(source).where(@(x,y) x < y,1:length(source)).toArray;
assertEqual(result,[2 1])

% function WithIndexEmptySource
% source = [0];
% result = linq(source).where(@(x,y) x < 4,1).toArray;
% 

