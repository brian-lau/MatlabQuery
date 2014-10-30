function output = last(self,func)

if nargin == 1
   output = lastOrDefault(self);
else
   output = lastOrDefault(self,func);
end

if isempty(output)
   error('linq:last:Invalid','No matching element');
end
