function self = takeWhile(self,func,varargin)

q = linq();
for i = 1:self.count
   if q.place(self.array(i)).where(func,varargin{:}).toArray
      continue;
   else
      break;
   end
end
if i == self.count
   i = i + 1;
end
self.take(i-1);
