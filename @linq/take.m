function self = take(self,n)

if self.count == 0
   error('linq:take:InputValue','Nothing to take');
   return;
end
if n <= 0
   self.empty();
elseif n >= self.count
   return;
else
   self.place(self.array(1:n));
end
