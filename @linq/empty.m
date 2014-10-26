function self = empty(self)

if isequal(self.func,@cellfun)
   self.place({});
else
   self.place([]);
end
