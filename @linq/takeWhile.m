% Yields elements from a sequence while a test is true and then skips 
% the remainder of the sequence. Stops when the predicate function 
% returns false or the end of the source sequence is reached.
% 
function self = takeWhile(self,func,varargin)

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

if i == self.count
   i = i + 1;
end

self.take(i-1);
