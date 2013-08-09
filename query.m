%http://apageofinsanity.wordpress.com/2013/07/29/functional-programming-in-matlab-using-query-part-iii/
classdef query < handle
   
   properties(GetAccess = public, SetAccess = private)
      array;
      func;
   end
   properties(GetAccess = public, SetAccess = private, Dependent = true)
      count
   end
   
   methods
      function self = query(array)
         
         if nargin == 0
            array = [];
         end
         
         if ismatrix(array) || iscell(array)
            place(self,array);
         else
            error('query:contructor:InputFormat',...
               'Input must be a matrix or cell array');
         end
         
      end
            
      function place(self,array)
         self.array = array;
         if iscell(array)
            self.func = @cellfun;
         elseif ismatrix(array)
            self.func = @arrayfun;
         end
      end
      
      function output = toList(self)
         output = self.array;
      end
      
      %% Get Functions
      function count = get.count(self)
         if isempty(self.array)
            count = [];
         else
            count = numel(self.array);
         end
      end
      
      function output = where(self, func, varargin)
         array = self.array;
         select(self,func,varargin{:});
         array(~logical(self.toList)) = [];
         place(self,array);
         output = self;
      end
      
      function output = select(self, func, varargin)
         
         if strcmp(func,'new')
            %keyboard
            output = select_new(self,varargin{:});
            return
         end
         
         % Apply function to each element of collection
         % Pull out expected name/value parameter pairs. Everything else is
         % treated as an input to cell/arrayfun
         params = {'UniformOutput' 'uni' 'ErrorHandler' 'replicateInput'};
         [toParser,input] = query.interceptParams(params,varargin);
         
         p = inputParser;
         p.FunctionName = 'query select';
         p.addRequired('self',@(x) isa(x,'query') );
         p.addRequired('func',@(x) isa(x,'function_handle') );
         %p.addParamValue('new',[],@(x) iscell(x)  ); % TODO better validator
         p.addParamValue('UniformOutput',true,@islogical)
         p.addParamValue('replicateInput',false,@islogical);
         p.parse(self,func,toParser{:});
         
         [m,n] = size(self.array);
         input = query.formatInput(self.func,m,n,input,p.Results.replicateInput);
         
         try
            temp = self.func(func,self.array,input{:},'UniformOutput',p.Results.UniformOutput);
         catch
            if p.Results.UniformOutput
               temp = self.func(func,self.array,input{:},'UniformOutput',false);
               warning('query:select','UniformOutput set false');
            end
         end
         % Overwrite data attached to calling handle
         self.place(temp);
         % Handle can be passed back as output. Allows chaining method
         % calls, eg. self.method(<expression>).select(<expression>)
         output = self;
      end
      
      function output = selectMany(self,func,varargin)
         % This only works with arrays
         if ~isequal(self.func,@arrayfun)
            error('query:selectMany:InputFormat',...
               'SelectMany does not work for cell arrays');
         end
         
         params = {'new'};
         [toParser,input] = query.interceptParams(params,varargin);

         p = inputParser;
         p.FunctionName = 'query select';
         p.addRequired('self',@(x) isa(x,'query') );
         p.addRequired('func',@(x) isa(x,'function_handle') );
         p.addParamValue('new',[],@(x) iscell(x)  ); % TODO better validator
         %p.addParamValue('UniformOutput',true,@islogical)
         p.addParamValue('replicateInput',false,@islogical);
         p.parse(self,func,toParser{:});

         [m,n] = size(self.array);
         input = query.formatInput(self.func,m,n,input,p.Results.replicateInput);

         if isempty(p.Results.new)
            child = query(self.array).select(func,input{:},'UniformOutput',false);
            % TODO how to flatten for arrays???
            % Flatten 
            self.place(deCell(child.toList));
            output = self;
            return
         else           
            % I think it's best not to allow any additional inputs, since we can
            % always chain a select call after the selectMany to operate on
            % the new struct
            %child = query(self.array).select(func,input{:},'UniformOutput',p.Results.UniformOutput);
            child = query(self.array).select(func,input{:},'UniformOutput',false);
            parent = query(self.array).select(p.Results.new{2},'UniformOutput',false);
            
            parentField = p.Results.new{1};
            childField = p.Results.new{3};
            newArray(child.count) = struct(parentField,[],childField,[]);
            count = 1;
            for i = 1:parent.count
               childSub = query(child.array{i})...
                  .select(p.Results.new{4},'UniformOutput',false);
               for j = 1:childSub.count
                  newArray(count).(parentField) = parent.array{i};
                  newArray(count).(childField) = childSub.array{j};
                  count = count + 1;
               end
            end
            self.place(newArray);
            output = self;
            return
         end
      end
   end
   
   methods(Access = private)
      function output = select_new(self,params)
         nFields = numel(params)/2;
         fieldNames = params(1:2:end);
         funcs = params(2:2:end);
         for i = 1:nFields
            q(i) = query(self.array).select(funcs{i},'UniformOutput',false);
         end
         
         newArray(self.count) = struct();
         for i = 1:self.count
            for j = 1:nFields
               newArray(i).(fieldNames{j}) = q(j).array{i};
            end
         end
         self.place(newArray);
         output = self;
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
                     if any([m,n] ~= size(fInput{j}))
                        error('query:select:InputFormat',...
                           'Input dimensions incorrect. Did you want to set replicateInput false?');
                     end
                  elseif all([m,n] == size(input{j}))
                     fInput{j} = input{j};
                  else
                     error('query:select:InputFormat',...
                        'Input dimensions must conform to arrayfun');
                  end
               end
            elseif isequal(func,@cellfun)
               % Additional inputs must be cell arrays
               for j = 1:nInput
                  if replicateInput
                     fInput{j} = repmat(input(j),m,n);
                     if any([m,n] ~= size(input{j}))
                        error('query:select:InputFormat',...
                           'Input dimensions incorrect. Did you want to set replicateInput false?');
                     end
                  elseif all([m,n] == size(input{j}))
                     fInput{j} = input{j};
                  else
                     error('query:select:InputFormat',...
                        'Input dimensions must conform to cellfun');
                  end
               end
            else
               error('query:formatInput:InputFormat',...
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
                  error('query:interceptParams:InputFormat',...
                     'Name missing param');
               end
            end
         end
         list(toRemove) = [];
         b = list;
      end
   end
end

