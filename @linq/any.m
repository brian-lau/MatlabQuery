% Determine whether any the array elements satisfy a condition
%http://msmvps.com/blogs/jon_skeet/archive/2010/12/28/reimplementing-linq-to-objects-part-10-any-and-all.aspx
% TODO should this accept inputs like SELECT???
%
function [output,ind] = any(self,func)

if nargin == 1
   if self.count
      output = true;
      ind = 1;
   else
      output = false;
      ind = [];
   end
   return
end

ind = 1;
output = false;
maxInd = self.count;
while ind <= maxInd
   if func(self.elementAt(ind))
      output = true;
      break;
   end
   ind = ind + 1;
end

if ~output
   ind = [];
end