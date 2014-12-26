%     Returns the element at a given index in a sequence.
%
%     INPUTS
%     ind
%
%     OUTPUT
%     output - requested element
%
%     EXAMPLES
%     q = linq({'foo' 'bar' 'baz'});
%     q.elementAt(2)
%
%     SEE ALSO
%     toArray, toList, toDictionary

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function output = elementAt(self,ind)

if iscell(self.array)
   if numel(ind) > 1
      output = cell(1,numel(ind));
      [output{:}] = deal(self.array{ind});
   else
      output = self.array{ind};
   end
else
   output = self.array(ind);
end
