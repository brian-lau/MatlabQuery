%     Randomize ordering of sequence with or without replacement
%
%     OPTIONAL
%     withReplacement - bool indicating whether to sample with
%                       replacement (default false)

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function self = randomize(self,withReplacement)

if nargin < 2
   withReplacement = true;
end

if withReplacement
   self.array = self.array(randi(self.count,self.size));
else
   self.array = self.array(randperm(self.count));
end
