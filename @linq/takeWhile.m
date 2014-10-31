% Yields elements from a sequence while a test is true and then skips 
% the remainder of the sequence. Stops when the predicate function 
% returns false or the end of the source sequence is reached.
% 
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function self = takeWhile(self,func)

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

self.take(index-1);
