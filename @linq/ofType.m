%     Return elements matching type
%
%     INPUT
%     typeName - string name of type, also works for any MATLAB or Java class
%
%     OUTPUT
%     self     - linq object
%
%     EXAMPLES
%     c = {1 'a' {'b'} int64(2) struct('name',3)};
%     query = linq();
%     query.place(c).ofType('struct').toArray
%     query.place(c).ofType('int64').toArray
%     query.place(c).ofType('numeric').toList
%     query.place(c).ofType('cell')
%
%     SEE ALSO
%     isa

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function self = ofType(self,typeName)

self.where(@(x) isa(x,typeName));
