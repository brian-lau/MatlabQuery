% Yields elements from a sequence while a test is true and then skips 
% the remainder of the sequence. Stops when the predicate function 
% returns false or the end of the source sequence is reached.
% 
function self = takeWhile(self,func)

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

self.take(index-1);
