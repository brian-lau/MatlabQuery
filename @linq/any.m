% Checks whether any element of a sequence satisfies a condition.
% If no predicate function is specified, simply returns true if 
% the source sequence contains any elements. Enumeration of the 
% source sequence is terminated as soon as the result is known.
% 
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function [output,ind] = any(self,func)

if nargin == 1
   if self.count
      output = true;
      ind = 1;
   else
      output = false;
      ind = [];
   end
   return
end

ind = 1;
output = false;
maxInd = self.count;
while ind <= maxInd
   if func(self.elementAt(ind))
      output = true;
      break;
   end
   ind = ind + 1;
end

if ~output
   ind = [];
end