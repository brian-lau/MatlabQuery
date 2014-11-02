%     Place an sequence into linq object
%
%     INPUTS
%     array  - sequence that is either ismatrix() or iscell()
%
%     OUTPUT
%     self - linq object
%
%     EXAMPLES
%     q = linq();
%     q.place(1:10)
%     q.place({'a' 'b' 'c'})
%     s(10) = struct('a',1,'b',2,'c',3);
%     q.place(s)
%     
%     SEE ALSO
%     iscell, ismatrix

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
