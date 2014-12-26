% LINQ - Class for LINQ-like queries
%
%     ATTRIBUTES
%     array -
%     size  -
%     count - 
%
%     METHODS
%
%     EXAMPLES

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%     Released under the BSD license. The license and most recent version
%     of the code can be found on GitHub:
%     https://github.com/brian-lau/MatlabQuery

% TODO 
% multidimensional arrays?
%   probably should force vector shape, see here:
%   http://undocumentedmatlab.com/blog/setting-class-property-types/
%   above not useful, but place now forces row format, perhaps should allow
%   vectors? don't think so, since arrayfun/cellfun still bomb?

classdef(CaseInsensitiveProperties, TruncatedProperties) linq < handle
   properties(SetAccess = private)
      array
   end
   properties(SetAccess = private, Dependent = true)
      size
      count
      %StringsAreIterable % passed to flattest?
   end
   properties(SetAccess = protected, Hidden = true)
      func
      key
   end
   properties(SetAccess = protected)
      version = '0.5.0'
   end
   
   methods
      %% Constructor
      function self = linq(array)
         if nargin == 0
            self.empty();
            return;
         end
         
         if ismatrix(array) || iscell(array)
            place(self,array);
         else
            error('linq:contructor:InputFormat',...
               'Input must be a matrix or cell array');
         end
      end            
      
      %% Get Functions
      function sz = get.size(self)
         if isempty(self.array)
            sz = [0 0];
         else
            sz = size(self.array);
         end
      end
      
      function count = get.count(self)
         if isempty(self.array)
            count = 0;
         else
            count = numel(self.array);
         end
      end
      
      %%
      self = place(self,array)

      %% Concatenation
      self = concat(self,obj)

      %% Conversion
      self = ofType(self,typeName)          
      output = toArray(self)
      output = toDictionary(self,keyFunc,valFunc)
      output = toList(self)     
      
      %% Element
      output = elementAt(self,ind)      

      %% Equality
      % sequenceEqual
      
      %% Generation
      self = empty(self)
      
      %% Grouping
      self = groupBy(self,keySelector,elementSelector,resultSelector)
      
      %% Join
      self = join(self,inner,outerKeySelector,innerKeySelector,resultSelector)

      %% Ordering
      self = reverse(self)
      self = randomize(self,withReplacement)
      function self = shuffle(self)
         self.randomize(false);
      end
      self = sort(self,mode)

      %% Partition
      self = skip(self,n)
      self = skipWhile(self,func,varargin)      
      self = take(self,n)
      self = takeWhile(self,func,varargin)
            
      %% Projection
      self = select(self,varargin)
      self = selectMany(self,varargin)
      
      %% Quantifiers
      [output,ind] = any(self,func)
      [output,ind] = all(self,func)
      [output,ind] = contains(self,value)
      
      %% Restriction
      self = where(self,func,varargin)
      
      %% Set
      self = distinct(self)
            
      function B = subsref(self,S)
         % Handle the first indexing on object itself, shorcut place()
         switch S(1).type
            case '()'
               self.place(S(1).subs{:});
               if numel(S) > 1
                  B = builtin('subsref',self,S(2:end));
               end
            otherwise
               % Enable normal "." and "{}" behavior
               B = builtin('subsref',self,S);
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
      function new()
         % abstract the creation of a struct array
      end
      
      function [funcs,unnamedArgs,namedArgs] = checkArgs(args,names)
         [namedArgsList,unnamedArgs] = linq.interceptParams(args,names);
         [funcs,unnamedArgs] = linq.interceptHandle(unnamedArgs);
         
         p = inputParser;
         p.addParamValue('UniformOutput',true,@islogical)
         p.addParamValue('replicateInput',false,@islogical);
         p.addParamValue('new',{},@(x) iscell(x) && (rem(numel(x),2)==0) );
         p.parse(namedArgsList{:});
         
         namedArgs = p.Results;
         if isempty(funcs)
            % FIXME, should empty unnamedArgs
            namedArgs.new = unnamedArgs{:};
         end
      end
      
      function fInput = formatInput(func,m,n,input,replicateInput)
         % Format auxilliary inputs for cellfun or arrayfun
         %
         % func - @arrayfun or @cellfun
         % m - # row elements to format inputs according to
         % n - # column elements to format inputs according to
         % input - cell array of additional inputs for func
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
      
      function [a,b] = interceptParams(list,names)
         % Pull out expected name/value parameter pairs. Everything else is
         % treated as an input to cell/arrayfun
         % names = {'UniformOutput' 'uni' 'ErrorHandler' 'replicateInput'};
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

