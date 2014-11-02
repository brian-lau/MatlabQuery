%http://apageofinsanity.wordpress.com/2012/02/22/functional-implementation-of-flatten/
% http://www.rqna.net/qna/kpqvwr-best-way-to-count-all-elements-in-a-cell-array.html
function flattened = flatten(nested)
flattened = {};
for i = 1:numel(nested)
   if(~iscell(nested{i}))
      % this would work even if flatTemp contains function_handle
      flattened = {flattened{:}, nested{i}};
   else
      flatTemp  = flatten(nested{i});
      
      % this would work even if flatTemp contains function_handle
      flattened = {flattened{:}, flatTemp{:}};
   end
end
