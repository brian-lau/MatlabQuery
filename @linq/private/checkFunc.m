function func = checkFunc(func)

if isa(func,'function_handle')
   return;
elseif ischar(func)
   if any(exist(func) == [2:6])
      func = str2func(func);
   else
      error('checkFunc:InputFormat','String must indicate valid function.');
   end
else
   error('checkFunc:InputFormat',...
      'Should be function handle or string defining function');
end