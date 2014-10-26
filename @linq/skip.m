function self = skip(self,n)

if self.count == 0
   error('linq:skip:InputValue','Nothing to skip');
   return;
end
if (n+1) >= self.count
   self.empty();
elseif n > 0
   self.place(self.array(n+1:end));
end
