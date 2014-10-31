% Checks whether a sequence contains a given element.
% 
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery
%
% No NULL comparer?
% custom comparer handled by passing in function handle

function [output,ind] = contains(self,value)

if isa(value,'function_handle')
   [output,ind] = self.any(value);
else   
   [output,ind] = self.any(@(x) isequal(x,value));
end
