% TODO 
% multidimensional arrays?
% should this be a value class?
%http://msmvps.com/blogs/jon_skeet/archive/tags/Edulinq/default.aspx
%http://apageofinsanity.wordpress.com/2013/07/29/functional-programming-in-matlab-using-query-part-iii/

% clean up use of deCell & deArray
% clean up input parsing and formatting, repeated input parsing in
% select&selectMany (calls select!?)
% fix try/catch in select to return somethign sensible when func bombs
classdef(CaseInsensitiveProperties = true) linq < handle
   
   properties(GetAccess = public, SetAccess = private)
      array
      func % hidden?
   end
   properties(GetAccess = public, SetAccess = private, Dependent = true)
      size
      count
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
         % 
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
         %
         
         if iscell(self.array)
            output = cell2mat(self.array);
         elseif ismatrix(self.array)
            output = self.array;
         else
            error('Cannot convert to matrix');
         end
      end
       
      function output = toList(self)
         % Return array as a cell array
         %
         
         if iscell(self.array)
            output = self.array;
         else
            output = num2cell(self.array);
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
      
      function output = ofType(self,typeName)
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
         %
         self.where(@(x) isa(x,typeName));
         output = self;
      end
      
      function output = sort(self)
         if ~ismethod(self.array,'sort')
            error(sprintf('Sort method does not exist for class %s',class(self.array)));
         end
         
         self.array = sort(self.array);
         output = self;
      end
      
      %% Restriction
      function self = where(self,func,varargin)
         % Returns elements for which the predicate function returns true
         %
         % INPUTS
         % func   - function handle defining predicate
         %
         % OUTPUT
         % output - linq object
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
         %
         if nargin < 2
            error('linq:where:InputNumber','Predicate is required');
         end
         if self.count == 0
            error('linq:where:InputFormat','Source matrix is empty');
         end
         
         array = self.array;
         ind = self.select(func,varargin{:}).toArray();

         if islogical(ind)
            array(~ind) = [];
            place(self,array);
            %output = self;
         else
            func = functions(func);
            error('linq:where:InputFormat',...
               sprintf('%s does not return logical outputs.',func.function));
         end
      end      
      
      %% Partition
      
      %% Projection
      function self = select(self,func,varargin)
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
         % output - linq object
         %
         % EXAMPLES
         % x = 1:10;
         % q = linq(x);
         % % square even numbers in x
         % q.where(@iseven).select(@(x) x^2).toArray()
         %
         % SEE ALSO
         % selectMany, arrayfun, cellfun
         %
         
         if nargin < 2
            error('linq:select:InputNumber','Predicate is required');
         end
         if self.count == 0
            self.place([]);
            %output = self;
            return
         end
         
         if strcmp(func,'new')
            %output = 
            select_new(self,varargin{:});
            return
         end
         
         % Pull out expected name/value parameter pairs. Everything else is
         % treated as an input to cell/arrayfun
         params = {'UniformOutput' 'ErrorHandler' 'replicateInput'};
         [toParser,input] = linq.interceptParams(params,varargin);
         
         p = inputParser;
         p.FunctionName = 'linq select';
         p.addRequired('self',@(x) isa(x,'linq') );
         p.addRequired('func',@(x) isa(x,'function_handle') );
         p.addParamValue('UniformOutput',true,@islogical)
         p.addParamValue('replicateInput',false,@islogical);
         p.parse(self,func,toParser{:});
         
         input = linq.formatInput(self.func,self.size(1),self.size(2),...
            input,p.Results.replicateInput);

         try
            temp = self.func(func,self.array,input{:},'UniformOutput',p.Results.UniformOutput);
         catch
            if p.Results.UniformOutput
               temp = self.func(func,self.array,input{:},'UniformOutput',false);
               warning('linq:select','UniformOutput set false');
            end
         end
         % Overwrite data attached to calling handle
         self.place(temp);
         % Handle can be passed back as output. Allows chaining method
         % calls, eg. self.method(<expression>).select(<expression>)
         %output = self;
         % HACK, just use self = fun(self)????
      end
      
      function self = selectMany(self,varargin)
         % 
         %
         % This only works with arrays WHY???
         % TODO how to flatten for arrays???
         % Additional arguments are passed exclusively to func
         % resultFunc can be modified by chaining select
         %http://msmvps.com/blogs/jon_skeet/archive/2010/12/27/reimplementing-linq-to-objects-part-9-selectmany.aspx
%          if ~isequal(self.func,@arrayfun)
%             error('linq:selectMany:InputFormat',...
%                'SelectMany does not work for cell arrays');
%          end
         
         %x selectMany(self,func)
         %x selectMany(self,func,resultFunc)
         %x selectMany(self,func,resultFunc,input)
         %selectMany(self,func,'new',{name func name2 func2})
         %selectMany(self,'new',{name func name2 func2})
         if nargin < 2
            error('linq:selectMany:InputNumber','At least one predicate is required');
         end

         [funcs,list] = linq.interceptHandle(varargin);
         [toParser,input] = linq.interceptParams(...
            {'new' 'replicateInput'},list);
         
         p = inputParser;
         p.FunctionName = 'linq selectMany';
         p.addRequired('self',@(x) isa(x,'linq') );
         p.addParamValue('new',[],@(x) iscell(x)  ); % TODO better validator
         p.addParamValue('replicateInput',false,@islogical);
         p.parse(self,toParser{:});

         input = linq.formatInput(self.func,self.size(1),self.size(2),...
            input,p.Results.replicateInput);

         if numel(funcs) > 2
            warning('linq:selectMany:InputNumber',...
               'Only first two function handles used.');
         end
         if numel(funcs) > 1
            if nargin(funcs{2}) ~=2
               error('Second function handle must accept two arguments');
            end
         elseif (numel(funcs) > 1) && ~isempty(p.Results.new)
            warning('linq:selectMany:InputNumber',...
               'Only first function handle used with ''new'' parameter.');
         elseif (numel(funcs) == 0)
            error('linq:selectMany:InputNumber','At least one predicate is required');
         end

         if isempty(p.Results.new)
            child = linq(self.array).select(funcs{1},input{:},'UniformOutput',false);
            if length(funcs) > 1
               parentList = self.toList;
               for i = 1:self.count
                  childSub = child.array{i};
                  if isnumeric(childSub)
                     childSub = num2cell(childSub);
                  end
                  temp{i} = cellfun(funcs{2},...
                     repmat(parentList(i),size(childSub)),childSub,...
                     'UniformOutput',false);
               end
               self.place(deCell(temp));
            else
               self.place(deArray(child.toList));
            end
            %output = self;
            return
         else
            %         keyboard
            child = linq(self.array).select(funcs{1},input{:},'UniformOutput',false);
            parent = linq(self.array).select(p.Results.new{2},'UniformOutput',false);
            
            parentField = p.Results.new{1};
            childField = p.Results.new{3};
            newArray(child.count) = struct(parentField,[],childField,[]);
            count = 1;
            for i = 1:parent.count
               childSub = linq(child.array{i})...
                  .select(p.Results.new{4},'UniformOutput',false);
               childSub.place(deArray(childSub.toList)) %%% HACK
               for j = 1:childSub.count
                  newArray(count).(parentField) = parent.array{i};
                  newArray(count).(childField) = childSub.array{j};
                  count = count + 1;
               end
            end
            self.place(newArray);
            %output = self;
            return
         end
      end
      
      %% Quantifiers
      function [output,ind] = any(self,func)
         % Determine whether any the array elements satisfy a condition
         %http://msmvps.com/blogs/jon_skeet/archive/2010/12/28/reimplementing-linq-to-objects-part-10-any-and-all.aspx
         % TODO should this accept inputs like SELECT???
         
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
      
      function output = all(self,func)
         % Determine whether all the array elements satisfy a condition
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
         self.array = self.array(end:-1:1);
         %output = self;
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
         %output = self.array;
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
         %output = self;
      end
   end
   
   methods(Static)
      
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
      
      function [a,b] = interceptParams(params,list)
         % Pull out expected name/value parameter pairs. Everything else is
         % treated as an input to cell/arrayfun
         %params = {'UniformOutput' 'uni' 'ErrorHandler' 'replicateInput'};
         count = 1;
         toRemove = [];
         a = {};
         for i = 1:length(params)
            ind = find(strcmpi(params{i},list));
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

