%     Empty sequence
%
%     OUTPUT
%     self - linq object
%
%     EXAMPLES
%     q = linq({'foo' 'bar' 'baz'});
%     q.empty()
%
%     SEE ALSO
%     place

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function self = empty(self)

if iscell(self.array)
   self.place({});
else
   self.place([]);
end
