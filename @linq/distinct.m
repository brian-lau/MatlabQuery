% Eliminates duplicate elements from a sequence
%
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

% TODO
%   when unique does not exist, use eq?
%   also allow passing in comparer
function self = distinct(self)

if ~ismethod(self.array,'unique')
   error('linq:distinct:InputType',...
      'Unique method does not exist for class %s',class(self.array));
end

self.array = unique(self.array,'stable');
