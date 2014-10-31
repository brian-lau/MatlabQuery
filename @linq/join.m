% Performs an inner join of two sequences based on matching keys extracted 
% from the elements.
%
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

%http://msmvps.com/blogs/jon_skeet/archive/2010/12/31/reimplementing-linq-to-objects-part-19-join.aspx
%https://code.google.com/p/edulinq/source/browse/src/Edulinq.Tests/JoinTest.cs
function self = join(self,inner,outerKeySelector,innerKeySelector,resultSelector)

inner = linq(inner);
outerKey = linq(self.array);
outerKey.select(outerKeySelector);
innerKey = linq(inner.array).select(innerKeySelector);

count = 1;
for i = 1:outerKey.count
   for j = 1:innerKey.count
      if isequal(outerKey.elementAt(i),innerKey.elementAt(j))
         array{count} = resultSelector(self.elementAt(i),inner.elementAt(j));
         count = count + 1;
      end
   end
end

self.place(array);
