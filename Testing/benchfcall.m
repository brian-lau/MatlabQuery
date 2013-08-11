%http://stackoverflow.com/questions/1673193/slow-performance-using-anonymous-functions-in-matlab-have-others-noticed-this
%http://stackoverflow.com/questions/12522888/arrayfun-can-be-significantly-slower-than-an-explicit-loop-in-matlab-why
%http://stackoverflow.com/questions/5359720/matlab-performance-problem-with-anonymous-functions?lq=1

function benchfcall
% https://www.mathworks.com/matlabcentral/newsreader/view_thread/259040
nrun = 100000;

disp(' ');
disp('sin(i)');
tic,
     for i = 1:nrun
         sin(i);
     end;
fprintf('\t%f\n', toc)

disp('a = feval(@sin,i)');
tic
     for i = 1:nrun
         feval(@sin,i);
     end;
fprintf('\t%f\n', toc)

disp('a = feval(''sin'',i)');
tic
     for i = 1:nrun
         feval('sin',i);
     end;
fprintf('\t%f\n', toc)

disp('a = @sin');
a = @sin;
tic
     for i = 1:nrun
         a(i);
     end;
fprintf('\t%f\n', toc)

disp('a = @(x)sin(x)');
a = @(x)sin(x);
tic
     for i = 1:nrun
         a(i);
     end;
fprintf('\t%f\n', toc)

disp('arrayfun(@sin,1:nrun);');
tic
arrayfun(@sin,1:nrun);
fprintf('\t%f\n', toc)

disp('arrayfun(@(x) sin(x),1:nrun);');
tic
arrayfun(@(x) sin(x),1:nrun);
fprintf('\t%f\n', toc)

end

% Bruno