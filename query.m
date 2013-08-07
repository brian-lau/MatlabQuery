%http://apageofinsanity.wordpress.com/2013/07/29/functional-programming-in-matlab-using-query-part-iii/
classdef query < handle
   properties
      array_;
      func_;
   end
   methods
      function obj = query(array)
         
         if nargin == 0
            array = [];
         end
         
         if iscell(array)
            obj.func_ = @cellfun;
         elseif ismatrix(array)
            obj.func_ = @arrayfun;
         end
         obj.array_ = array;
      end
      
      function arr = toList(obj)
         arr = obj.array_;
      end
      
      function output = select(obj, func, varargin)
         % Apply function to each element of collection
         p = inputParser;
         p.KeepUnmatched= true;
         p.FunctionName = 'query select method';
         % Intercept some parameters to override defaults
         p.addParamValue('nOutput',1,@islogical);
         p.addParamValue('inputs',{},@iscell);
         p.addParamValue('replicateInputs',true,@islogical);
         p.parse(varargin{:});
         % Passed through to cellfun
         params = p.Unmatched;
         
         nInputs = numel(p.Results.inputs);
         
         if nInputs == 0
            inputs = {};
         else
            temp = p.Results.inputs;
            [m,n] = size(obj.array_);
            inputs = cell(1,nInputs);
            if isequal(obj.func_,@arrayfun)
               for j = 1:numel(temp)
                  
                  if p.Results.replicateInputs
                     %if isscalar(temp{j})
                        inputs{j} = repmat(temp{j},m,n);
                     %else
                     %   disp('how')
                     %end
                  elseif all([m,n] == size(temp{j}))
                     inputs{j} = temp{j};
                     
                  else
                     
%                   if all([m,n] == size(temp{j}))
%                      inputs{j} = temp{j};
%                   elseif isscalar(temp{j})
%                      inputs{j} = repmat(temp{j},m,n);
%                   else
                     error('');
                  end
               end
            elseif isequal(obj.func_,@cellfun)
               for j = 1:numel(temp)
%                   if all([m,n] == size(temp{j}))
%                      inputs{j} = temp{j};
%                   elseif isscalar(temp{j})
                     inputs{j} = repmat(temp(j),m,n);
%                   else
%                      error('');
%                   end
               end
            else
               error('unknown function handle');
            end
         end
         %output = obj.func_(func, obj.array_, inputs{:}, 'UniformOutput', false);
         % this creates a new query object
         %output = query(obj.func_(func, obj.array_, inputs{:}, 'UniformOutput', true));
         
         obj.array_ = obj.func_(func, obj.array_, inputs{:}, 'UniformOutput', true);
         if iscell(obj.array_)
            obj.func_ = @cellfun;
         elseif ismatrix(obj.array_)
            obj.func_ = @arrayfun;
         end
         output = obj;
         %keyboard
         % Currently Matlab OOP doesn't allow the handle to be
         % reassigned, ie self = obj, so we do a silent pass-by-value
         % http://www.mathworks.com/matlabcentral/newsreader/view_thread/268574
         %assignin('caller',inputname(1),output);
      end
      function arr = select2(obj, func, varargin)
         % monad *returns* the wrapped element for binding.
         for i = 1:length(varargin)
            if(length(varargin{i}) == 1 && strcmpi(class(varargin{i}), 'query'))
               varargin{i} = varargin{i}.toList();
            end
         end
         % monad *binding*
         if(nargin(func) == 1)
            arr = query(obj.func_(func, obj.array_, 'UniformOutput', false));
         elseif(nargin(func) >= 2)
            arr = query(obj.func_(func, obj.array_, varargin{:}, 'UniformOutput', false));
         end
      end
%       function arr = where(obj, func, varargin)
%          if(nargin(func) == 1)
%             arr = query(where(func, obj.array_));
%          elseif(nargin(func) >= 2)
%             arr = query(where(func, obj.array_, obj.gen_index(), varargin{:}));
%          end
%       end

function test(obj)
   disp('hello')
end
      
   end
end

%          p = inputParser;
%          p.KeepUnmatched= true;
%          p.FunctionName = 'pointProcess valueFun method';
%          % Intercept some parameters to override defaults
%          p.addParamValue('nOutput',1,@islogical);
%          p.addParamValue('args',{},@iscell);
%          p.parse(varargin{:});
%          % Passed through to cellfun
%          params = p.Unmatched;
% 
%          nWindow = size(self.window,1);
%          nArgs = numel(p.Results.args);
% %          if nArgs ~= nargin(fun)
% %             error('');
% %          end
% 
%          for i = 1:nWindow
%             % Construct function arguments (see cellfun) as a cell array to
%             % use comman-separated expansion
%             temp = p.Results.args;
%             args = cell(1,nArgs);
%             for j = 1:numel(temp)
%                args{j} = repmat(temp(j),1,self.count(i));
%             end
%             output{i,1} = cellfun(fun,self.windowedValues{i},args{:});
%          end
