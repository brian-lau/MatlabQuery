% Reverse ordering of matrix elements
%
% TODO
% Issue warning or error if ~isvector(array)
%
function self = reverse(self)

self.array = self.array(end:-1:1);
