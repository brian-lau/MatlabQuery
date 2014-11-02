%     Performs a one-to-many element projection over a sequence.
%     Always returns flat list (cell array) unless new is used
%
%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

% This only works with arrays WHY???
% TODO how to flatten for arrays???
% Additional arguments are passed exclusively to func
% resultFunc can be modified by chaining select
%http://msmvps.com/blogs/jon_skeet/archive/2010/12/27/reimplementing-linq-to-objects-part-9-selectmany.aspx
% http://www.hookedonlinq.com/SelectManyOperator.ashx

%x selectMany(self,func)
%x selectMany(self,func,resultFunc)
%x selectMany(self,func,resultFunc,input)
%x selectMany(self,func,'new',{name func name2 func2})
%selectMany(self,'new',{name func name2 func2}) NONSENSE?
function self = selectMany(self,varargin)

if nargin < 2
   error('linq:selectMany:InputNumber',...
      'At least one predicate is required');
end

names = {'new' 'replicateInput'};
[func,funcArgs,namedArgs] = linq.checkArgs(varargin,names);

if numel(func) > 2
   warning('linq:selectMany:InputNumber',...
      'Only first two function handles used.');
end

if numel(func) > 1
   if nargin(func{2}) ~=2
      error('Second function handle must accept two arguments');
   end
elseif (numel(func) > 1) && ~isempty(namedArgs.new)
   warning('linq:selectMany:InputNumber',...
      'Only first function handle used with ''new'' parameter.');
elseif numel(func) == 0
   error('linq:selectMany:InputNumber',...
      'At least one predicate is required');
end

funcArgs = linq.formatInput(self.func,self.size(1),self.size(2),...
   funcArgs,namedArgs.replicateInput);

child = linq(self.array);
child.select(func{1},funcArgs{:},'UniformOutput',false);

if isempty(namedArgs.new)
   if length(func) > 1
      parentList = self.toList();
      for i = 1:self.count
         % Evaluate second function using original array and flat
         % output of first function as inputs
         childList = flattest(child.array{i});%StringsAreIterable?
         temp{i} = cellfun(...
            func{2},repmat(parentList(i),size(childList)),childList,...
            'UniformOutput',false);
      end
      self.place(flatten(temp));
   else
      self.place(flattest(child.toList())); %StringsAreIterable?
   end
else
   parent = linq(self.array);
   parent.select(namedArgs.new{2},'UniformOutput',false);
   
   parentField = namedArgs.new{1};
   childField = namedArgs.new{3};
   newArray(child.count) = struct(parentField,[],childField,[]);
   count = 1;
   for i = 1:parent.count
      childList = flattest(child.array{i});%StringsAreIterable?
      childList = cellfun(...
         namedArgs.new{4},childList,'UniformOutput',false);
      for j = 1:numel(childList)
         newArray(count).(parentField) = parent.array{i};
         newArray(count).(childField) = childList{j};
         count = count + 1;
      end
   end
   self.place(newArray);
end