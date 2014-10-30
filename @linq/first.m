function output = first(self,func)

if nargin == 1
   output = firstOrDefault(self);
else
   output = firstOrDefault(self,func);
end

if isempty(output)
   error('linq:first:Invalid','No matching element');
end
