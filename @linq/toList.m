%     Create a cell array from a sequence.
%
%     OUTPUT
%     output - cell array
%
%     EXAMPLES
%     q = linq(1:10);
%     q.toList()
%
%     SEE ALSO
%     toArray, toDictionary

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
