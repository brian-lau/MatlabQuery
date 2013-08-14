% TODO 
% multidimensional arrays?
%   probably should force vector shape, see here:
%   http://undocumentedmatlab.com/blog/setting-class-property-types/
%   above not useful, but place now forces row format, perhaps should allow
%   vectors? don't think so, since arrayfun/cellfun still bomb?
% should this be a value class?
%http://msmvps.com/blogs/jon_skeet/archive/tags/Edulinq/default.aspx
%http://apageofinsanity.wordpress.com/2013/07/29/functional-programming-in-matlab-using-query-part-iii/

% x clean up use of deCell & deArray
% clean up input parsing and formatting, repeated input parsing in select&selectMany (calls select!?)
% x fix try/catch in select to return somethign sensible when func bombs
classdef(CaseInsensitiveProperties = true) linq < handle
   
   properties(GetAccess = public, SetAccess = private)
      array
      func % hidden?
   end
   properties(GetAccess = public, SetAccess = private, Dependent = true)
      size
      count
      StringsAreIterable % passed to flattest?
      version
   end
   
   methods
      %% Constructor
      function self = linq(array)
         if nargin == 0
            array = [];
         end
         
         if ismatrix(array) || iscell(array)
            place(self,array);
         else
            error('linq:contructor:InputFormat',...
               'Input must be a matrix or cell array');
         end
      end
            
      function place(self,array)
         % Place an array into linq object
         if ~isvector(array) && ~isempty(array)
            array = array(:)';
         end
         self.array = array;
         if iscell(array)
            self.func = @cellfun;
         elseif ismatrix(array)
            self.func = @arrayfun;
         end
      end
      
      %% Get Functions
      function count = get.size(self)
         if isempty(self.array)
            count = [0 0];
         else
            count = size(self.array);
         end
      end
      
      function count = get.count(self)
         if isempty(self.array)
            count = 0;
         else
            count = numel(self.array);
         end
      end

      %% Conversion
      function output = toArray(self)
         % Return array as a matrix
         if iscell(self.array)
            output = cell2mat(self.array);
            % TODO, this will bomb if nested cell arrays or objects
         elseif ismatrix(self.array)
            output = self.array;
         else
            error('linq:toArray:InputFormat',...
               'Cannot convert to matrix');
         end
      end
       
      function output = toList(self)
         % Return array as a cell array
         if iscell(self.array)
            output = self.array;
         else
            output = num2cell(self.array);
            %StringsAreIterable?
         end
      end
      
      function output = toDictionary(self,keyFunc,valFunc)
         % Create a dictionary
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
         keys = linq(self.array).select(keyFunc,'UniformOutput',false).toList();
         if nargin == 3
            values = linq(self.array).select(valFunc,'UniformOutput',false).toList();
         else
            values = self.select(@(x) x,'UniformOutput',false).toList();
         end

         output = containers.Map(keys,values);
      end
      
      function self = ofType(self,typeName)
         % Return elements matching type
         %
         % INPUT
         % typeName - string name of type, also works for any MATLAB or
         %            Java class
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
         self.where(@(x) isa(x,typeName));
      end
      
      function self = sort(self)
         if ~ismethod(self.array,'sort')
            error('linq:sort:InputType',...
               'Sort method does not exist for class %s',class(self.array));
         end
         
         self.array = sort(self.array);
      end
      
      %% Restriction
      function self = where(self,func,varargin)
         % Returns elements for which the predicate function returns true
         %
         % INPUTS
         % func   - function handle defining predicate
         %
         % OUTPUT
         % self - linq object
         %
         % OPTIONAL
         % Extra arguments can be passed in as for linq.select
         %
         % EXAMPLES
         % % numbers from 1 to 10 greater than 5
         % linq(1:10).where(@(x) x > 5).toArray
         % % passing arguments to predicate
         % linq(1:10).where(@(x,y) x == y,(10:-1:1)-1).toArray
         %
         % c = {'a' 1 'b' 'c' 4};
         % linq(c).where(@ischar).toList
         %
         % s(1) = struct('customer','george','purchases',[]);
         % s(1).purchases = struct('item','wrench','cost',55);
         % s(1).purchases(2) = struct('item','coat','cost',25);
         % s(2) = struct('customer','frank','purchases',[]);
         % s(2).purchases = struct('item','steak','cost',15);
         % s(2).purchases(2) = struct('item','dog','cost',250);
         % s(2).purchases(3) = struct('item','flowers','cost',50);
         %
         % linq(s).where(@(x) any([x.purchases.cost] > 200)).toArray
         % linq(s).where(@(x) any(strcmp({x.purchases.item},'wrench'))).toArray
         % 
         % SEE ALSO
         % select
         if nargin < 2
            error('linq:where:InputNumber','Predicate is required');
         end
         if self.count == 0
            error('linq:where:InputFormat','Source matrix is empty');
         end
         
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
      end      
      
      %% Partition
      function self = skip()
      end
      function self = skipWhile()
      end
      function self = take()
      end
      function self = takeWhile()
      end
      
      %% Join
      function self = join(self,inner,outerKeySelector,innerKeySelector,resultSelector)
         outer = self.toList;
         outerKey = linq(outer).select(outerKeySelector);
         innerKey = linq(inner).select(innerKeySelector);
         
         count = 1;
         for i = 1:outerKey.count
            for j = 1:innerKey.count
               if isequal(outerKey.elementAt(i),innerKey.elementAt(j))
                  array{count} = resultSelector(outer{i},inner{j});
                  count = count + 1;
               end
            end
         end
         self.place(array);
      end
      
      %% Projection
      function self = select(self,varargin)
         % Returns the results of evaluating the selector function for each 
         % matrix element
         %
         % INPUTS
         % func
         %
         % OPTIONAL
         % 
         %
         % OUTPUT
         % self - linq object
         %
         % EXAMPLES
         % x = 1:10;
         % q = linq(x);
         % % square even numbers in x
         % q.where(@iseven).select(@(x) x^2).toArray()
         %
         % SEE ALSO
         % selectMany, arrayfun, cellfun
         if nargin < 2
            error('linq:select:InputNumber','Predicate is required');
         end
         if self.count == 0
            self.place([]);
            return
         end
         
         names = {'new' 'UniformOutput' 'replicateInput'};
         [func,funcArgs,namedArgs] = linq.checkArgs(varargin,names);
         
         if ~isempty(namedArgs.new)
            select_new(self,namedArgs.new);
            return
         end
         
         funcArgs = linq.formatInput(self.func,self.size(1),self.size(2),...
            funcArgs,namedArgs.replicateInput);

         try
            result = self.func(func{1},self.array,funcArgs{:},...
               'UniformOutput',namedArgs.UniformOutput);
            self.place(result);
         catch err
            if strcmp(err.identifier,'MATLAB:arrayfun:NotAScalarOutput') ||...
               strcmp(err.identifier,'MATLAB:cellfun:NotAScalarOutput')
               if namedArgs.UniformOutput
                  result = self.func(func{1},self.array,funcArgs{:},...
                     'UniformOutput',false);
                  %warning('linq:select','UniformOutput set false');
                  self.place(result);
               end
            else
               rethrow(err);
            end
         end
      end
      
      function self = selectMany(self,varargin)
         % Always returns flat list (cell array) unless new is used
         %
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
         
         child = linq(self.array).select(func{1},funcArgs{:},'UniformOutput',false);

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
            parent = linq(self.array).select(namedArgs.new{2},'UniformOutput',false);
            
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
      end
      
      %% Quantifiers
      function [output,ind] = any(self,func)
         % Determine whether any the array elements satisfy a condition
         %http://msmvps.com/blogs/jon_skeet/archive/2010/12/28/reimplementing-linq-to-objects-part-10-any-and-all.aspx
         % TODO should this accept inputs like SELECT???
         %
         if nargin == 1
            if self.count
               output = true;
               ind = 1;
            else
               output = false;
               ind = [];
            end
            return
         end
         
         ind = 1;
         output = false;
         maxInd = self.count;
         if isequal(self.func,@arrayfun)
            while ind <= maxInd
               if func(self.array(ind))
                  output = true;
                  break;
               end
               ind = ind + 1;
            end
         else
            while ind <= maxInd
               if func(self.array{ind})
                  output = true;
                  break;
               end
               ind = ind + 1;
            end
         end
         
         if ~output
            ind = [];
         end
      end
      
      function [output,ind] = all(self,func)
         % Determine whether all the array elements satisfy a condition
         %
         ind = 1;
         output = true;
         maxInd = self.count;
         if isequal(self.func,@arrayfun)
            while ind <= maxInd
               if ~func(self.array(ind))
                  output = false;
                  break;
               end
               ind = ind + 1;
            end
         else
            while ind <= maxInd
               if ~func(self.array{ind})
                  output = false;
                  break;
               end
               ind = ind + 1;
            end
         end
      end

      %% Ordering
      function self = reverse(self)
         % Reverse ordering of matrix elements
         %
         % TODO
         % Issue warning or error if ~isvector(array)
         %
         self.array = self.array(end:-1:1);
      end
      
      function self = randomize(self,withReplacement)
         % Randomize ordering of matrix elements with or without replacement
         % 
         % OPTIONAL
         % withReplacement - bool indicating whether to sample with
         %                   replacement (default false)
         % 
         if nargin < 2
            withReplacement = false;
         end
         
         if withReplacement
            self.array = self.array(randi(self.count,1,self.count));
         else
            self.array = self.array(randperm(self.count));
         end
      end
      
      %% Element
      function output = elementAt(self,ind)
         if isequal(self.func,@cellfun)
            output = self.array{ind};
         else
            output = self.array(ind);
         end
      end
      
   end
   
   methods(Access = private)
      function self = select_new(self,params)
         % Mimic Linq 'select new' behavior using struct as an anonymous
         % type.
         %
         % params - cell array of name/value pairs
         %
         % TODO better input format checking
         % why wouldn't you use selectMany for this???
         %
         nFields = numel(params)/2;
         fieldNames = params(1:2:end);
         funcs = params(2:2:end);
         for i = 1:nFields
            q(i) = linq(self.array).select(funcs{i},'UniformOutput',false);
         end
         
         newArray(self.count) = struct();
         for i = 1:self.count
            for j = 1:nFields
               newArray(i).(fieldNames{j}) = q(j).array{i};
            end
         end
         self.place(newArray);
      end
   end
   
   methods(Static)
      
      function [funcs,unnamedArgs,namedArgs] = checkArgs(args,names)
         [namedArgsList,unnamedArgs] = linq.interceptParams(names,args);
         [funcs,unnamedArgs] = linq.interceptHandle(unnamedArgs);
         
         p = inputParser;
         p.addParamValue('UniformOutput',true,@islogical)
         p.addParamValue('replicateInput',false,@islogical);
         p.addParamValue('new',{},@(x) iscell(x) && (rem(numel(x),2)==0) );
         p.parse(namedArgsList{:});
         
         namedArgs = p.Results;
      end
      
      function fInput = formatInput(func,m,n,input,replicateInput)
         % Format auxilliary inputs for cellfun or arrayfun
         %
         % func - @arrayfun or @cellfun
         % m - # row elements to format inputs according to
         % n - # column elements to format inputs according to
         % input - cell array of additional inputs for func
         %
         nInput = numel(input);
         if nInput == 0
            fInput = {};
         else
            fInput = cell(1,nInput); % wrapper for additional inputs to func
            if isequal(func,@arrayfun)
               for j = 1:nInput
                  if replicateInput
                     fInput{j} = repmat(input{j},m,n);
%                      if any([m,n] ~= size(fInput{j}))
%                         error('linq:select:InputFormat',...
%                            'Input dimensions incorrect. Did you want to set replicateInput false?');
%                      end
                  elseif all([m,n] == size(input{j}))
                     fInput{j} = input{j};
                  else
                     error('linq:select:InputFormat',...
                        'Input dimensions must conform to arrayfun');
                  end
               end
            elseif isequal(func,@cellfun)
               % Additional inputs must be cell arrays
               for j = 1:nInput
                  if replicateInput
                     fInput{j} = repmat(input(j),m,n);
                     if any([m,n] ~= size(input{j}))
                        error('linq:select:InputFormat',...
                           'Input dimensions incorrect. Did you want to set replicateInput false?');
                     end
                  elseif all([m,n] == size(input{j}))
                     if isnumeric(input{j})
                        fInput{j} = num2cell(input{j});
                     else
                        fInput{j} = input{j};
                     end
                  else
                     error('linq:select:InputFormat',...
                        'Input dimensions must conform to cellfun');
                  end
               end
            else
               error('linq:formatInput:InputFormat',...
                  'Unknown function handle');
            end
         end
      end
      
      function [a,b] = interceptParams(names,list)
         % Pull out expected name/value parameter pairs. Everything else is
         % treated as an input to cell/arrayfun
         %names = {'UniformOutput' 'uni' 'ErrorHandler' 'replicateInput'};
         %
         count = 1;
         toRemove = [];
         a = {};
         for i = 1:length(names)
            ind = find(strcmpi(names{i},list));
            if ind
               if ind ~= length(list)
                  a{count} = list{ind};
                  a{count+1} = list{ind+1};
                  count = count + 2;
                  toRemove = [toRemove , ind , ind + 1];
               else
                  error('linq:interceptParams:InputFormat',...
                     'Name missing param');
               end
            end
         end
         list(toRemove) = [];
         b = list;
      end
      
      function [a,b] = interceptHandle(list)
         count = 1;
         toRemove = [];
         a = {};
         for i = 1:length(list)
            if isa(list{i},'function_handle')
               a{count} = list{i};
               count = count + 1;
               toRemove = [toRemove , i];
            end
         end
         list(toRemove) = [];
         b = list;
      end
   end
end

