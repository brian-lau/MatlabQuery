% Return elements matching type
%
% INPUT
% typeName - string name of type, also works for any MATLAB or Java class
%
% OUTPUT
% output   - linq object
%
% EXAMPLES
% c = {1 'a' {'b'} int64(2) struct('name',3)};
% linq(c).ofType('struct').toArray
% linq(c).ofType('int64').toArray
% linq(c).ofType('numeric').toList
% linq(c).ofType('cell')
%
% SEE ALSO
% isa
function self = ofType(self,typeName)

self.where(@(x) isa(x,typeName));
