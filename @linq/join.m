% Performs an inner join of two sequences based on matching keys extracted 
% from the elements.
%
%http://msmvps.com/blogs/jon_skeet/archive/2010/12/31/reimplementing-linq-to-objects-part-19-join.aspx
%https://code.google.com/p/edulinq/source/browse/src/Edulinq.Tests/JoinTest.cs
function self = join(self,inner,outerKeySelector,innerKeySelector,resultSelector)

outer = self;
inner = linq(inner);
outerKey = linq(self.array).select(outerKeySelector);
innerKey = linq(inner.array).select(innerKeySelector);

% TODO 
%   o optimize to avoid inner loop
%   x need 'new' keyword? no do directly with struct
count = 1;
for i = 1:outerKey.count
   for j = 1:innerKey.count
      if isequal(outerKey.elementAt(i),innerKey.elementAt(j))
         array{count} = resultSelector(outer.elementAt(i),inner.elementAt(j));
         count = count + 1;
      end
   end
end
self.place(array);
