%     Skips elements from a sequence while predicate is true yielding 
%     the remainder of the sequence. Once the predicate function returns 
%     false for an element, that element and the remaining elements are 
%     yielded with no further invocations of the predicate function.
%
%     INPUTS
%     func - function handle, anonymous function, or string naming function
%
%     OUTPUT
%     self - linq object
%
%     EXAMPLES
%     q = linq(1:10);
%     q.skipWhile(@(x) x <= 3)
%
%     SEE ALSO
%     skip, take, takeWhile

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function self = skipWhile(self,func)

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

self.skip(index-1);
