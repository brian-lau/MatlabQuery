% 
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function self = concat(self,obj)

if isrow(self.array) && isrow(obj.array)
   self.array = cat(2,self.array,obj.array);
elseif iscolumn(self.array) && iscolumn(obj.array)
   self.array = cat(1,self.array,obj.array);
else
   error('linq:concat:InputFormat','Inconsistent array formats');
end
