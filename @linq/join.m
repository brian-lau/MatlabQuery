%     Performs an inner join of two sequences based on matching keys extracted 
%     from the elements.
%
%     INPUTS
%     inner - function handle, anonymous function, or string naming function
%     outerKeySelector - function handle, anonymous function
%     innerKeySelector - function handle, anonymous function
%     resultSelector - function handle, anonymous function
%
%     OUTPUT
%     self - linq object
%
%     EXAMPLES
%
%     SEE ALSO
%     

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function self = join(self,inner,outerKeySelector,innerKeySelector,resultSelector)

inner = linq(inner);
outerKey = linq(self.array);
outerKey.select(outerKeySelector);
innerKey = linq(inner.array).select(innerKeySelector);

count = 1;
% FIXME preallocate array to max, then trim to size
for i = 1:outerKey.count
   for j = 1:innerKey.count
      if isequal(outerKey.elementAt(i),innerKey.elementAt(j))
         array{count} = resultSelector(self.elementAt(i),inner.elementAt(j));
         count = count + 1;
      end
   end
end

self.place(array);
