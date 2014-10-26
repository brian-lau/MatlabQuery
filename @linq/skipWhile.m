function self = skipWhile(self,func,varargin)

q = linq();
for i = 1:self.count
   if q.place(self.array(i)).where(func,varargin{:}).toArray
      continue;
   else
      break;
   end
end
self.skip(i-1);
