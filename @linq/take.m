% Yields a given number of elements from a sequence and then skips the
% remainder of the sequence.
%
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function self = take(self,n)

if self.count == 0
   error('linq:take:InputValue','Nothing to take');
   return;
end

if n <= 0
   self.empty();
elseif n >= self.count
   return;
else
   self.place(self.array(1:n));
end
