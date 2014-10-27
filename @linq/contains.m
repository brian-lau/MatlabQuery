% Checks whether a sequence contains a given element.
%
% No NULL comparer?
% custom comparer handled by passing in function handle
function [output,ind] = contains(self,value)

if isa(value,'function_handle')
   [output,ind] = self.any(value);
else   
   [output,ind] = self.any(@(x) isequal(x,value));
end
