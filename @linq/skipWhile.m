% Skips elements from a sequence while a test is true and then yields 
% the remainder of the sequence. Once the predicate function returns 
% false for an element, that element and the remaining elements are 
% yielded with no further invocations of the predicate function.

function self = skipWhile(self,func,varargin)

q = linq();
for i = 1:self.count
   % Index overload
   if (nargin(func)==2) && (nargin==2)
      arg = {i};
   else
      arg = varargin;
   end
   
   if q.place(self.array(i)).select(func,arg{:}).toArray
      continue;
   else
      break;
   end
end

self.skip(i-1);
