% Create a cell array from a sequence.
%
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function output = toList(self)

if iscell(self.array)
   output = self.array;
else
   % Works for all array types
   output = num2cell(self.array);
   %StringsAreIterable?
end
