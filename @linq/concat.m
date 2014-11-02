%     Concatenate sequences
%
%     INPUTS
%     obj  - linq object. Sequence type should match.
%
%     OUTPUT
%     self - linq object
%
%     EXAMPLES
%     q1 = linq(1:5);
%     q2 = linq(6:10);
%     q1.concat(q2)
%     q1 = linq({'dog' 'cat'});
%     q2 = linq({'human'});
%     q1.concat(q2)
 
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
