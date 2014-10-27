% Create an array from a sequence
%
function output = toArray(self)

if iscell(self.array)
   output = [self.array{:}];
   %output = cell2mat(self.array);
   if iscell(output)
      % Likely nested cell arrays or objects
      warning('linq:toArray:OutputFormat',...
         'Could not return an array.');
   end
elseif ismatrix(self.array)
   output = self.array;
else
   error('linq:toArray:InputFormat',...
      'Cannot convert to matrix');
end
