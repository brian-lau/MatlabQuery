%     Create an array from a sequence
%
%     OUTPUT
%     output - array
%
%     EXAMPLES
%     q = linq(1:10);
%     q.toArray()
%
%     SEE ALSO
%     toList, toDictionary

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function output = toArray(self)

if iscell(self.array)
   output = [self.array{:}];
   %output = cell2mat(self.array);
   if iscell(output)
      % Likely nested cell arrays or objects
      warning('linq:toArray:OutputFormat',...
         'Could not return an array.');
   end
elseif ismatrix(self.array)
   output = self.array;
else
   error('linq:toArray:InputFormat',...
      'Cannot convert to matrix');
end
