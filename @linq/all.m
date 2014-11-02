%     Determine whether all the array elements satisfy a condition
%
%     INPUTS
%     func - function handle, anonymous function, or string naming function
%
%     OUTPUT
%     output - boolean
%     ind  - index where condition is first violated
%
%     EXAMPLES
%     q = linq(1:10);
%     [a,b] = q.all(@(x) x < 5);
%     q = linq({'dog' 'cat' 'human'});
%     [a,b] = q.all(@(x) strcmp(x,'cat'));
%
%     SEE ALSO
%     any, contains

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
