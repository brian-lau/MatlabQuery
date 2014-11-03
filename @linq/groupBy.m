function self = groupBy(self,keySelector,elementSelector,resultSelector)

if nargin < 3
   elementSelector = [];
end
if nargin < 4
   resultSelector = [];
end

qkey = linq(self.array);
key = qkey.select(keySelector).toArray;

if isstruct(key)
   fnames = fieldnames(key);
   temp = [];
   for i = 1:numel(fnames)
      temp = [temp , cat(1,key.(fnames{i}))];
   end
   keyboard
else
   [key,~,IC] = unique(key,'stable');
end

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
