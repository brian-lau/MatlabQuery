function self = sort(self)

if ~ismethod(self.array,'sort')
   error('linq:sort:InputType',...
      'Sort method does not exist for class %s',class(self.array));
end

self.array = sort(self.array);
