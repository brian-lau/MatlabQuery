function flattened = flattest(nested,flattenStr)

if nargin < 2
   flattenStr = false;
end

if ismatrix(nested) && ~iscell(nested)
   if ischar(nested)
      if flattenStr
         flattened = flatten(num2cell(nested));
      else
         flattened = nested;
      end
   else
      flattened = num2cell(nested);
      flattened = {flattened{:}};
   end
   return
end

nested = flatten(nested);

flattened = {};
for i = 1:numel(nested)
   if numel(nested{i}) <= 1
      flattened = {flattened{:}, nested{i}};
   elseif ischar(nested{i})
      if flattenStr
         flatTemp  = flattest(nested{i},flattenStr);
         flattened = {flattened{:}, flatTemp{:}};
      else
         flattened = {flattened{:}, nested{i}};
      end
   else
      flatTemp  = flattest(nested{i},flattenStr);
      flattened = {flattened{:}, flatTemp{:}};
   end
end
