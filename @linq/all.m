% Determine whether all the array elements satisfy a condition
%
function [output,ind] = all(self,func)

ind = 1;
output = true;
maxInd = self.count;
while ind <= maxInd
   if ~func(self.elementAt(ind))
      output = false;
      break;
   end
   ind = ind + 1;
end
