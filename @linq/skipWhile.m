% Skips elements from a sequence while a test is true and then yields 
% the remainder of the sequence. Once the predicate function returns 
% false for an element, that element and the remaining elements are 
% yielded with no further invocations of the predicate function.
%
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function self = skipWhile(self,func)

useIndex = (nargin(func)==2);
indexCell = useIndex && iscell(self.array);
index = 1;
n = self.count;
arg = {};
while index <= n
   if useIndex
      if indexCell
         arg = {{index}};
      else
         arg = {index};
      end
   end

   if self.func(func,self.array(index),arg{:})
      index = index + 1;
   else
      break;
   end
end

self.skip(index-1);
