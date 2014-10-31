% 
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function output = first(self,func)

if nargin == 1
   output = firstOrDefault(self);
else
   output = firstOrDefault(self,func);
end

if isempty(output)
   error('linq:first:Invalid','No matching element');
end
