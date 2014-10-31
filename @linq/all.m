% Determine whether all the array elements satisfy a condition
%
% 
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function [output,ind] = all(self,func)

ind = 1;
output = true;

if self.count == 0
   return;
end

maxInd = self.count;
while ind <= maxInd
   if ~func(self.elementAt(ind))
      output = false;
      break;
   end
   ind = ind + 1;
end
