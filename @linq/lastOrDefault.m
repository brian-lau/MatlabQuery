%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function output = lastOrDefault(self,func)

isCell = iscell(self.array);

if nargin == 1
   if self.count > 0
      output = self.elementAt(self.count);
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
for index = self.count:-1:1
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
