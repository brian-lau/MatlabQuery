% Place an sequence into linq object
%
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function self = place(self,array)

if ~isvector(array) && ~isempty(array)
   array = array(:)';
end

self.array = array;

if iscell(array)
   self.func = @cellfun;
elseif ismatrix(array)
   self.func = @arrayfun;
else
   error('linq:place:InputType','Not a valid source type')
end
