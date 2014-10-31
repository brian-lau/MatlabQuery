%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function output = lastOrDefault(self,func)

if nargin == 1
   if self.count > 0
      output = self.elementAt(self.count);
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
   for index = self.count:-1:1
      if func(self.array{index})
         match = true;
         break;
      end
   end
else
   for index = self.count:-1:1
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
