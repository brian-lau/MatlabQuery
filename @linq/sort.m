%     Sort a sequence
%
%     OPTIONAL
%     mode - 'ascend' or 'descend', default = 'ascend'
%
%     OUTPUT
%     self - linq object
%
%     EXAMPLES
%     q = linq(1:10);
%     q.sort('descend')
%
%     SEE ALSO
%     reverse, randomize, shuffle

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function self = sort(self,mode)

if ~ismethod(self.array,'sort')
   error('linq:sort:InputType',...
      'Sort method does not exist for class %s',class(self.array));
end

if nargin < 2
   mode = 'ascend';
end

if isrow(self.array)
   self.array = sort(self.array,2,mode);
else
   self.array = sort(self.array,1,mode);
end   
