%     Returns the last element of a sequence matching predicate
%
%     INPUTS
%     func - function handle, anonymous function, or string naming function
%
%     OUTPUT
%     output - matching element
%
%     EXAMPLES
%     q = linq({'foo' 'bars' 'baz'});
%     q.last(@(x) numel(x)>3)
%     q.last(@(x) numel(x)>4) % non-match errors
%
%     SEE ALSO
%     lastOrDefault, first, firstOrDefault

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function output = last(self,func)

if nargin == 1
   output = lastOrDefault(self);
else
   output = lastOrDefault(self,func);
end

if isempty(output)
   error('linq:last:Invalid','No matching element');
end
