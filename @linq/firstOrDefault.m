% 
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function output = firstOrDefault(self,func)

isCell = iscell(self.array);

if nargin == 1
   if self.count > 0
      output = self.elementAt(1);
   else
      if isCell
         output = {};
      else
         output = [];
      end
   end
   return;
end

match = false;
for index = 1:self.count
   if isCell
      x = self.array{index};
   else
      x = self.array(index);
   end
   
   if func(x)
      match = true;
      break;
   end
end

if match
   output = self.elementAt(index);
else
   if isCell
      output = {};
   else
      output = [];
   end
end
