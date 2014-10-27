% Enumerates the source sequence and yields the results of evaluating 
% the selector function for each element.
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
function self = select(self,varargin)

if nargin < 2
   error('linq:select:InputNumber','Predicate is required');
end

if self.count == 0
   self.empty();
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
   if (nargin(func{1})==2) && isempty(funcArgs)
      % Index overload
      if isequal(self.func,@cellfun)
         index = num2cell(1:self.count);
      else
         index = 1:self.count;
      end
      result = self.func(func{1},self.array,index,...
         'UniformOutput',namedArgs.UniformOutput);
   else
      result = self.func(func{1},self.array,funcArgs{:},...
         'UniformOutput',namedArgs.UniformOutput);
   end
   self.place(result);
catch err
   if strcmp(err.identifier,'MATLAB:arrayfun:NotAScalarOutput') ||...
         strcmp(err.identifier,'MATLAB:cellfun:NotAScalarOutput') ||...
         strcmp(err.identifier,'MATLAB:cellfun:UnimplementedOutputArrayType') ||...
         strcmp(err.identifier,'MATLAB:arrayfun:UnimplementedOutputArrayType')
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