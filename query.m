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
         input = {};
         val = self.func(func, self.array, input{:}, 'UniformOutput', true);
         self.array(~logical(val)) = [];
         output = self;
      end
      
      
      function output = select(self, func, varargin)
         % Apply function to each element of collection
         p = inputParser;
         p.KeepUnmatched= true;
         p.FunctionName = 'query select';
         % Intercept some parameters to override defaults
%         p.addParamValue('nOutput',1,@islogical);
         p.addParamValue('input',{},@iscell);
         p.addParamValue('replicateInput',true,@islogical);
         p.parse(varargin{:});
         
         % Passed through to cellfun/arrayfun
         params = p.Unmatched;
         
         [m,n] = size(self.array);
         input = query.formatInput(self.func,m,n,p.Results.input,p.Results.replicateInput);
         keyboard
%          nInput = numel(p.Results.input);
%          
%          % 
%          
%          if nInput == 0
%             input = {};
%          else
%             temp = p.Results.input;
%             [m,n] = size(self.array);
%             input = cell(1,nInput); % wrapper for additional inputs to func
%             if isequal(self.func,@arrayfun)
%                for j = 1:nInput
%                   if p.Results.replicateInput
%                      input{j} = repmat(temp{j},m,n);
%                      if any([m,n] ~= size(input{j}))
%                         error('query:select:InputFormat',...
%                            'Input dimensions incorrect. Did you want to set replicateInput false?');
%                      end
%                   elseif all([m,n] == size(temp{j}))
%                      input{j} = temp{j};
%                   else
%                      error('query:select:InputFormat',...
%                         'Input dimensions must conform to arrayfun');
%                   end
%                end
%             elseif isequal(self.func,@cellfun)
%                % Additional inputs must be cell arrays
%                for j = 1:nInput
%                   if p.Results.replicateInput
%                      input{j} = repmat(temp(j),m,n);
%                      if any([m,n] ~= size(input{j}))
%                         error('query:select:InputFormat',...
%                            'Input dimensions incorrect. Did you want to set replicateInput false?');
%                      end
%                   elseif all([m,n] == size(temp{j}))
%                      input{j} = temp{j};
%                   else
%                      keyboard
%                      error('query:select:InputFormat',...
%                         'Input dimensions must conform to cellfun');
%                   end
%                end
%             else
%                error('query:select:InputFormat',...
%                   'Unknown function handle');
%             end
%          end

         if isequal(self.func,@arrayfun)
            try
               temp = self.func(func,self.array,input{:},'UniformOutput',true);
            catch
               temp = self.func(func,self.array,input{:},'UniformOutput',false);
            end
         else
            temp = self.func(func,self.array,input{:},'UniformOutput',false);
         end
         % Overwrite data attached to calling handle
         self.place(temp);
         % Handle can be passed back as output. Allows chaining method
         % calls, eg. self.method(<expression>).select(<expression>)
         output = self;
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
                     keyboard
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

