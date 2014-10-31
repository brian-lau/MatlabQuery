% 
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function output = firstOrDefault(self,func)

if nargin == 1
   if self.count > 0
      output = self.elementAt(1);
   else
      if iscell(self.array)
         output = {};
      else
         output = [];
      end
   end
   return;
end

match = false;
if iscell(self.array)
   for index = 1:self.count
      if func(self.array{index})
         match = true;
         break;
      end
   end
else
   for index = 1:self.count
      if func(self.array(index))
         match = true;
         break;
      end
   end
end

if match
   output = self.elementAt(index);
else
   if iscell(self.array)
      output = {};
   else
      output = [];
   end
end
