function output = firstOrDefault(self,func)

if nargin == 1
   if self.count > 0
      output = self.elementAt(1);
   else
      if isequal(self.func,@arrayfun)
         output = [];
      elseif isequal(self.func,@cellfun)
         output = {};
      end
   end
   return;
end

match = false;
if isequal(self.func,@arrayfun)
   for index = 1:self.count
      if func(self.array(index))
         match = true;
         break;
      end
   end
else
   for index = 1:self.count
      if func(self.array{index})
         match = true;
         break;
      end
   end
end

if match
   output = self.elementAt(index);
else
   if isequal(self.func,@arrayfun)
      output = [];
   elseif isequal(self.func,@cellfun)
      output = {};
   end
end
