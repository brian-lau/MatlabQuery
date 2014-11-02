for i = 1:100000
   x(i).r = i;
end

q = linq(x);
tic;y = q.where(@(x) x.r>500).toArray;toc
tic;z = x([x.r]>500);toc

clear all;
for i = 1:100
   x(i).y.z = i;
end

tic;
y = linq(x).where(@(x) x.y.z>500).toArray;
toc

tic;
temp = [x.y];
z = x([temp.z]>500);
toc

iseven = @(x) rem(x,2)==0;

tic;
y = linq(x).where(@(x) x.y.z>500 && iseven(x.y.z)).toArray;
toc

tic;
temp = [x.y];
temp = [temp.z];
z = x(temp>500 & iseven(temp));
toc

clear all;
for i = 1:100
   for j = 1:1000
      x(i).name = num2str(i);
      x(i).y(j).z = j;
      x(i).y(j).r = 1:j;
   end
end

% retrieve y.r where y.z > number, but keep track of which x.name
% 
% tic;
% y = linq(x).selectMany(@(x) x.y,'new',{'name' @(x) x.name 'y' @(y) y})...
%    .select('new',{'name' @(x) x.name 'z' @(y) y.y.z 'r' @(y) y.y.r} ).where(@(x) x.z > 50)
% new1 = linq(x)...
%    .select('new',{'name' @(x) x.name 'z' @(y) [y.y.z] 'r' @(y) {y.y.r}} )...
%    .select('new',{'name' @(x) x.name 'r' @(y) y.r(y.z>50)}).toArray;
% % new1 = linq(x)...
% %    .select('new',{'name' @(x) x.name 'z' @(y) {y.y.r([y.y.z]>50)} } )...
% %    .select('new',{'name' @(x) x.name 'r' @(y) y.r(y.z>50)}).toArray;
% toc
% 
% tic;
% for i = 1:numel(x)
%    temp = [x(i).y];
%    ind = [temp.z]>50;
%    new2(i).name = x(i).name;
%    new2(i).r = {temp(ind).r};
% end
% toc