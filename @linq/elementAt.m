% Returns the element at a given index in a sequence.

function output = elementAt(self,ind)

if isequal(self.func,@cellfun)
   output = self.array{ind};
else
   output = self.array(ind);
end
