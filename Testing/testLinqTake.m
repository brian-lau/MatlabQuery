%https://code.google.com/p/edulinq/source/browse/src/Edulinq.Tests/TakeTest.cs
function test_suite = testLinqTake
initTestSuite;


%%
function testNegativeCount
source = [0:4];
result = linq(source).take(-5);
assertEqual(result.toArray,[]);

source = {0 1 2 3 4};
result = linq(source).take(-5);
assertEqual(result.toList,{});

function testZeroCount
source = [0:4];
result = linq(source).take(0);
assertEqual(result.toArray,[]);

source = {0 1 2 3 4};
result = linq(source).take(0);
assertEqual(result.toList,{});

function testEmptySource
l = linq([]);
f = @() l.take(10);
assertExceptionThrown(f,'linq:take:InputValue')

function testCountShorterThanSource
source = 0:4;
result = linq(source).take(3);
assertEqual(result.toArray,[0 1 2]);

function testCountEqualtoSourceLength
source = 0:4;
result = linq(source).take(5);
assertEqual(result.toArray,source);

function testCountGreaterthanSourceLength
source = 0:4;
result = linq(source).take(15);
assertEqual(result.toArray,source);
