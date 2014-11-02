%     Enumerates the source sequence and yields the results of evaluating 
%     the selector function for each element.
%
%     INPUTS
%     func - function handle, anonymous function, or string naming function
%
%     OPTIONAL
%     Arguments can be passed through to predicate
%
%     OUTPUT
%     self - linq object
%
%     EXAMPLES
%     q = linq(1:10);
%     % square even numbers in x
%     q.where(@iseven).select(@(x) x^2).toArray()
%
%     % expose index
%     q.place(1:10).select(@(x,index) x - index).toArray()
%     q.place(1:10).select(@(x,y) x + y,1:10).toArray()
%
%     % pass argument
%     q.place(1:10).select(@(x,y) x + y,1:10).toArray()
%
%     SEE ALSO
%     selectMany, arrayfun, cellfun

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

function self = select(self,func,varargin)

if nargin < 2
   error('linq:select:InputNumber','Predicate is required');
end

if self.count == 0
   self.empty();
   return
end

func = checkFunc(func);
names = {'new' 'UniformOutput' 'replicateInput'};
[~,funcArgs,namedArgs] = linq.checkArgs(varargin,names);

if ~isempty(namedArgs.new)
   select_new(self,namedArgs.new);
   return
end

funcArgs = linq.formatInput(self.func,self.size(1),self.size(2),...
   funcArgs,namedArgs.replicateInput);

if (nargin(func)==2) && isempty(funcArgs)
   % Index is passed through
   if iscell(self.array)
      index = num2cell(1:self.count);
   else
      index = 1:self.count;
   end
   array = self.func(func,self.array,index,...
      'UniformOutput',namedArgs.UniformOutput);
else
   array = self.func(func,self.array,funcArgs{:},...
      'UniformOutput',namedArgs.UniformOutput);
end

self.place(array);
