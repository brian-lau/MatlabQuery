%     Yields elements from a sequence while a test is true and then skips 
%     the remainder of the sequence. Stops when the predicate function 
%     returns false or the end of the source sequence is reached.
% 
%     INPUTS
%     func - function handle, anonymous function, or string naming function
%
%     OUTPUT
%     self - linq object
%
%     EXAMPLES
%     q = linq(1:10);
%     q.takeWhile(@(x) x >= 3)
%
%     SEE ALSO
%     skip, take, takeWhile

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function self = takeWhile(self,func)

func = checkFunc(func);
useIndex = (nargin(func)==2);
isCell = iscell(self.array);

index = 1;
n = self.count;
arg = {};
while index <= n
   if useIndex
      arg = {index};
   end
   
   if isCell
      x = self.array{index};
   else
      x = self.array(index);
   end
   
   if func(x,arg{:})
      index = index + 1;
   else
      break;
   end
end

self.take(index-1);
