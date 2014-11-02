%     Enumerates the source sequence and yields those elements for which 
%     the predicate function returns true.
%
%     INPUTS
%     func - Function handle defining predicate. Must return a scalar
%            boolean for each element of collection
%
%     OUTPUT
%     self - linq object
%
%     OPTIONAL
%     Extra arguments can be passed in as for linq.select
%
%     EXAMPLES
%     q = linq();
%     % numbers from 1 to 10 greater than 5
%     q.place(1:10).where(@(x) x > 5).toArray
%     % passing arguments to predicate
%     q.place(1:10).where(@(x,y) x == y,(10:-1:1)-1).toArray
%
%     c = {'a' 1 'b' 'c' 4};
%     q.place(c).where(@ischar).toList
%
%     s(1) = struct('customer','george','purchases',[]);
%     s(1).purchases = struct('item','wrench','cost',55);
%     s(1).purchases(2) = struct('item','coat','cost',25);
%     s(2) = struct('customer','frank','purchases',[]);
%     s(2).purchases = struct('item','steak','cost',15);
%     s(2).purchases(2) = struct('item','dog','cost',250);
%     s(2).purchases(3) = struct('item','flowers','cost',50);
% 
%     q.place(s).where(@(x) any([x.purchases.cost] > 200)).toArray
%     q.place(s).where(@(x) any(strcmp({x.purchases.item},'wrench'))).toArray
%
%     SEE ALSO
%     select, selectMany

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function self = where(self,func,varargin)

if nargin < 2
   error('linq:where:InputNumber','Predicate is required');
end

if self.count == 0
   error('linq:where:InputFormat','Source matrix is empty');
end

func = checkFunc(func);

array = self.array;
ind = self.select(func,varargin{:}).toArray();
if numel(ind) ~= self.count
   error('linq:where:InputFormat',...
      'Predicate must return a scalar for each element of linq.array.');
end

if islogical(ind)
   array(~ind) = [];
   place(self,array);
else
   func = functions(func);
   error('linq:where:InputFormat',...
      '%s does not return logical outputs.',func.function);
end
