% Return a cell array
function output = toList(self)

if iscell(self.array)
   output = self.array;
else
   % Works for all array types
   output = num2cell(self.array);
   %StringsAreIterable?
end
