function self = groupBy(self,keySelector,elementSelector,resultSelector)

if nargin < 3
   elementSelector = [];
end
if nargin < 4
   resultSelector = [];
end

qkey = linq(self.array);
key = qkey.select(keySelector).toArray; % will bomb for cells...

[key,~,IC] = unique(key,'stable');

for i = 1:numel(key)
   ind = IC == i;
   if iscell(self.array)
      array{i} = self.array(ind);
   else
      array{i} = self.array(ind);
   end
end

self.key = key;
self.place(array);
if ~isempty(resultSelector)
   self.select(resultSelector);
end
