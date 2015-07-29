%     Eliminates duplicate elements from a sequence
%
%     INPUTS
%
%     OUTPUT
%     self - linq object
%
%     EXAMPLES
%     q = linq({'foo' 'bar' 'foo' 'baz'});
%     q.distinct()
%
%     SEE ALSO
%     unique, sort

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

% TODO
%   when unique does not exist, use eq?
%   also allow passing in custom comparer
function self = distinct(self)

if islogical(self.array)
   self.array = unique(self.array,'stable');
elseif ~ismethod(self.array,'unique')
   error('linq:distinct:InputType',...
      'Unique method does not exist for class %s',class(self.array));
end

self.array = unique(self.array,'stable');
