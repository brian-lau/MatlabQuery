% Randomize ordering of sequence with or without replacement
%
% OPTIONAL
% withReplacement - bool indicating whether to sample with
%                   replacement (default false)
%
function self = randomize(self,withReplacement)

if nargin < 2
   withReplacement = false;
end

if withReplacement
   self.array = self.array(randi(self.count,1,self.count));
else
   self.array = self.array(randperm(self.count));
end
