%     Create a dictionary from a sequence
%
%     INPUTS
%     keyFunc - function handle selecting keys
%
%     OPTIONAL
%     valFunc - function handle selecting values
%
%     EXAMPLES
%     s(1) = struct('customer','george','purchases',[]);
%     s(1).purchases = struct('item','wrench','cost',55);
%     s(1).purchases(2) = struct('item','coat','cost',25);
%     s(2) = struct('customer','frank','purchases',[]);
%     s(2).purchases = struct('item','steak','cost',15);
%     s(2).purchases(2) = struct('item','dog','cost',250);
%     s(2).purchases(3) = struct('item','flowers','cost',50);
% 
%     % Dictionary of purchases keyed by customer
%     d1 = linq(s).toDictionary(@(x) x.customer,@(x) x.purchases)
%     % Dictionary of items and costs keyed by item
%     d2 = linq([s.purchases]).toDictionary(@(x) x.item,@(x) x.cost)
%
%     SEE ALSO
%     toArray, toList, containers.Map

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function output = toDictionary(self,keyFunc,valFunc)

q = linq(self.array);
keys = q.select(keyFunc,'UniformOutput',false).toList();
if nargin == 3
   q.place(self.array);
   values = q.select(valFunc,'UniformOutput',false).toList();
else
   values = self.select(@(x) x,'UniformOutput',false).toList();
end

output = containers.Map(keys,values);
