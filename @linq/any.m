%     Checks whether any element of a sequence satisfies a condition.
%     If no predicate function is specified, simply returns true if 
%     the source sequence contains any elements. Enumeration of the 
%     source sequence is terminated as soon as the result is known.
%
%     INPUTS
%     func - function handle, anonymous function, or string naming function
%
%     OUTPUT
%     output - boolean
%     ind  - index where condition is first satisfied
%
%     EXAMPLES
%     q = linq(1:10);
%     [a,b] = q.any(@(x) x > 5);
%     q = linq({'dog' 'cat' 'human'});
%     [a,b] = q.any(@(x) strcmp(x,'cat'));
%
%     SEE ALSO
%     all, contains

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