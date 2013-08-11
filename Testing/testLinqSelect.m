function test_suite = testLinqSelect
initTestSuite;


%%
function testSimpleProjection

source = [1 5 2];
result = linq(source).select(@(x) x*2);
assertEqual(result.toArray,2*source);

source = {1 5 2};
result = linq(source).select(@(x) x*2);
assertEqual(result.toList,{2 10 4});

function testSimpleProjectionToDifferentType

source = [1 5 2];
result = linq(source).select(@(x) num2str(x));
assertEqual(result.toList,{'1' '5' '2'});

source = {1 5 2};
result = linq(source).select(@(x) num2str(x));
assertEqual(result.toList,{'1' '5' '2'});

function testEmptySource

source = [];
result = linq(source).select(@(x) x*2);
assertEqual(result.toArray,[]);

function testWithIndexSimpleProjection

source = [1 5 2];
result = linq(source).select(@(x,y) x + y*10,(1:length(source))-1);
assertEqual(result.toArray,[1 15 22]);
