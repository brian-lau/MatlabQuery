function test_suite = testLinqWhere
initTestSuite;


%%
function Linq1
numbers = [5 4 1 3 9 8 6 7 2 0];
q = linq(numbers);
q.where(@(n) n < 5)
fprintf('Numbers < 5: %g\n',q.toArray)
assertEqual(q.toArray,[4 1 3 2 0]);

clear q
a = linq(numbers).where(@(n) n < 5).toArray;
assertEqual(a,[4 1 3 2 0]);

function Linq2
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
   .select(@(x) x.name).toList;

for i = 1:length(soldOutProducts)
   fprintf('%s is sold out !\n',soldOutProducts{i});
end

ind = [products.UnitsInStock] == 0;
soldOutProducts2 = {products(ind).name};
assertEqual(soldOutProducts,soldOutProducts2);

function Linq3
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
   .select(@(x) x.name).toList;

ind = ([products.UnitsInStock] > 0) & ([products.UnitPrice] > 3);
expensiveInStockProducts2 = {products(ind).name};
assertEqual(expensiveInStockProducts,expensiveInStockProducts2);

function Linq5
digits = {'zero' 'one' 'two' 'three' 'four' 'five' 'six' 'seven' 'eight' 'nine'};

q = linq(digits);
shortDigits = q.where(@(digit,index) length(digit) < index,0:9).toList;
fprintf('The word %s is shorter than its value.\n',shortDigits{:});

assertEqual(shortDigits,{'five' 'six' 'seven' 'eight' 'nine'});

% 
% function testInsert
% % Inserting times
% p = pointProcess('times',1:10);
% p.insertTimes([10:20]);
% assertEqual(p.times,1:20);
% % Window does not change
% assertEqual(p.count,10);
% assertEqual(p.windowedTimes{1},1:10);
% assertEqual(p.windowIndex{1},1:10);
% % But start and end times do
% assertEqual(p.tStart,0);
% assertEqual(p.tEnd,20);
% % But explicit window change reflects new times
% p.window = [0 20];
% assertEqual(p.count,20);
% assertEqual(p.windowedTimes{1},1:20);
% assertEqual(p.windowIndex{1},1:20);
% 
% clear p;
% p = pointProcess('times',[1:10],'window',[0 20]);
% assertEqual(p.isValidWindow,false);
% p.insertTimes([10:20]);
% assertEqual(p.times,1:20);
% assertEqual(p.isValidWindow,true);
% % Initialization of bigger window now includes times automatically
% assertEqual(p.count,20);
% assertEqual(p.windowedTimes{1},1:20);
% assertEqual(p.windowIndex{1},1:20);
% 
% clear p;
% p = pointProcess('times',[11:20],'window',[10 20],'tStart',11);
% assertEqual(p.isValidWindow,false);
% p.insertTimes([1:10]);
% % Original window doesn't fully cover the newly inserted times
% assertEqual(p.times,1:20);
% assertEqual(p.windowedTimes{1},10:20);
% assertEqual(p.windowIndex{1},10:20);
% assertEqual(p.tStart,1);
% assertEqual(p.tEnd,20);
% assertEqual(p.isValidWindow,true);
% 
% % % Inserting using a containers.Map
% % clear p;
% % p = pointProcess('times',[1:3],'window',[0 20]);
% % p.insertTimes(containers.Map({4},{'dog'}));
% % assertEqual(p.times,1:4);
% % assertEqual(p.isValidWindow,false);
% % assertEqual(p.count,4);
% % assertEqual(p.map.keys,{1 2 3 4});
% % assertEqual(p.map.values,{[] [] [] 'dog'});
% 
% f = @() p.insertTimes('dog');
% assertExceptionThrown(f,'pointProcess:insertTimes:InputFormat')
