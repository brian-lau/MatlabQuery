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
         
         place(obj,array);
         
      end
      
      function arr = toList(obj)
         arr = obj.array_;
      end
      
      function place(obj,array)
         obj.array_ = array;
         if iscell(array)
            obj.func_ = @cellfun;
         elseif ismatrix(array)
            obj.func_ = @arrayfun;
         end
      end
      
      function output = where(obj, func, varargin)
         inputs = {};
         val = obj.func_(func, obj.array_, inputs{:}, 'UniformOutput', true);
         obj.array_(~logical(val)) = [];
         output = obj;
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
         % Overwrites data attached to calling handle
         obj.place(obj.func_(func, obj.array_, inputs{:}, 'UniformOutput', false));
         % Handle can be passed back as output. Allows chaining method
         % calls, eg. obj.select(<expression>).select(<expression>)
         output = obj;
      end
            
   end
end

