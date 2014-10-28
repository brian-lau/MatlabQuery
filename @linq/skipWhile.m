% Skips elements from a sequence while a test is true and then yields 
% the remainder of the sequence. Once the predicate function returns 
% false for an element, that element and the remaining elements are 
% yielded with no further invocations of the predicate function.

function self = skipWhile(self,func)

index = 1;
n = self.count;
arg = {};
while index <= n
   % Index overload
   if (nargin(func)==2) && isequal(@arrayfun,self.func)
      arg = {index};
   elseif (nargin(func)==2) && isequal(@cellfun,self.func)
      arg = {{index}};
   end
   
   if self.func(func,self.array(index),arg{:})
      index = index + 1;
   else
      break;
   end
end

self.skip(index-1);
