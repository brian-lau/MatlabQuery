% Sort a sequence
%
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function self = sort(self)

if ~ismethod(self.array,'sort')
   error('linq:sort:InputType',...
      'Sort method does not exist for class %s',class(self.array));
end

self.array = sort(self.array);
