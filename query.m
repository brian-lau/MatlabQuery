%http://apageofinsanity.wordpress.com/2013/07/29/functional-programming-in-matlab-using-query-part-iii/
classdef query < handle
   
   properties(GetAccess = public, SetAccess = private)
      array;
      func;
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
      
      function output = where(self, func, varargin)
         array = self.array;
         select(self,func,varargin{:});
         array(~logical(self.toList)) = [];
         place(self,array);
         output = self;
      end
      
      function output = select(self, func, varargin)
         % Apply function to each element of collection
         
         % Pull out expected name/value parameter pairs. Everything else is
         % treated as an input to cell/arrayfun
         validParams = {'UniformOutput' 'uni' 'ErrorHandler' 'replicateInput'};
         count = 1;
         toRemove = [];
         var = {};
         for i = 1:length(validParams)
            ind = find(strcmpi(validParams{i},varargin));
            if ind
               if ind ~= length(varargin)
                  var{count} = varargin{ind};
                  var{count+1} = varargin{ind+1};
                  count = count + 2;
                  toRemove = [toRemove , ind , ind + 1];
               else
                  error('cannot be last');
               end
            end
         end
         varargin(toRemove) = [];
         
         p = inputParser;
         p.FunctionName = 'query select';
         p.addRequired('self',@(x) isa(x,'query') );
         p.addRequired('func',@(x) isa(x,'function_handle') );
         % Intercept some parameters to override defaults
%         p.addParamValue('nOutput',1,@islogical);
         p.addParamValue('UniformOutput',true,@islogical)
         p.addParamValue('replicateInput',false,@islogical);
         p.parse(self,func,var{:});
         
         [m,n] = size(self.array);
         input = query.formatInput(self.func,m,n,varargin,p.Results.replicateInput);

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
      
      function output = selectMany(self, func, varargin)
         % This only works with arrays
         if ~isequal(self.func,@arrayfun)
            error('Cells dont make sense');
         end
         array = self.array;
         select(self,func,varargin{:});
         
         % child (force uniformOutput)
      end
   end
   
   methods(Static)
      function fInput = formatInput(func,m,n,input,replicateInput)
         % static
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
               error('query:select:InputFormat',...
                  'Unknown function handle');
            end
         end
      end
   end
end

