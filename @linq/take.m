%     Yields a given number of elements from a sequence and then skips the
%     remainder of the sequence.
%
%     INPUTS
%     n    - # of elements to take
%
%     OUTPUT
%     self - linq object
%
%     EXAMPLES
%     q = linq(1:10);
%     q.take(5)
%     q.take(0) 
%     q.take(10) % error
%
%     SEE ALSO
%     takeWhile, skip, skipWhile

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
