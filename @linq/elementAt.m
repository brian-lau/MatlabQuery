% Returns the element at a given index in a sequence.
% 
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function output = elementAt(self,ind)

if iscell(self.array)
   output = self.array{ind};
else
   output = self.array(ind);
end
