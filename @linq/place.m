% Place an sequence into linq object

function self = place(self,array)

if ~isvector(array) && ~isempty(array)
   array = array(:)';
end
self.array = array;
if iscell(array)
   self.func = @cellfun;
elseif ismatrix(array)
   self.func = @arrayfun;
elseif isa(array,'containers.Map')
   self.func = @mapfun;
else
   error('linq:place:InputType','Not a valid source type')
end
