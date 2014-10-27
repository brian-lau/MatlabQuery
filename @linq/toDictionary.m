% Create a dictionary from a sequence
%
% INPUTS
% keyFunc - function handle selecting keys
%
% OPTIONAL
% valFunc - function handle selecting values
%
% EXAMPLES
% s(1) = struct('customer','george','purchases',[]);
% s(1).purchases = struct('item','wrench','cost',55);
% s(1).purchases(2) = struct('item','coat','cost',25);
% s(2) = struct('customer','frank','purchases',[]);
% s(2).purchases = struct('item','steak','cost',15);
% s(2).purchases(2) = struct('item','dog','cost',250);
% s(2).purchases(3) = struct('item','flowers','cost',50);
%
% % Dictionary of purchases keyed by customer
% d1 = linq(s).toDictionary(@(x) x.customer,@(x) x.purchases)
% % Dictionary of items and costs keyed by item
% d2 = linq([s.purchases]).toDictionary(@(x) x.item,@(x) x.cost)
%
% SEE ALSO
% containers.Map
%
%http://msmvps.com/blogs/jon_skeet/archive/2011/01/02/reimplementing-linq-to-objects-todictionary.aspx
%http://geekswithblogs.net/BlackRabbitCoder/archive/2010/10/21/c.net-little-wonders-todictionary-and-tolist.aspx
function output = toDictionary(self,keyFunc,valFunc)

keys = linq(self.array).select(keyFunc,'UniformOutput',false).toList();
if nargin == 3
   values = linq(self.array).select(valFunc,'UniformOutput',false).toList();
else
   values = self.select(@(x) x,'UniformOutput',false).toList();
end

output = containers.Map(keys,values);
