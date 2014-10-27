% Eliminates duplicate elements from a sequence
%
% TODO
%   when unique does not exist, use eq?
%   also allow passing in comparer
function self = distinct(self)

if ~ismethod(self.array,'unique')
   error('linq:distinct:InputType',...
      'Unique method does not exist for class %s',class(self.array));
end

self.array = unique(self.array,'stable');
