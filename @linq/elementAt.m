function output = elementAt(self,ind)

if isequal(self.func,@cellfun)
   output = self.array{ind};
else
   output = self.array(ind);
end
