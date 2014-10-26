%https://code.google.com/p/edulinq/source/browse/src/Edulinq.Tests/SkipTest.cs
function test_suite = testLinqSkip
initTestSuite;


%%
function testNegativeCount
source = [0:4];
result = linq(source).skip(-5);
assertEqual(result.toArray,source);

source = {0 1 2 3 4};
result = linq(source).skip(-5);
assertEqual(result.toList,source);

function testZeroCount
source = [0:4];
result = linq(source).skip(0);
assertEqual(result.toArray,source);

source = {0 1 2 3 4};
result = linq(source).skip(0);
assertEqual(result.toList,source);

function testEmptySource
l = linq([]);
f = @() l.skipWhile(@(x) x > 3);
assertExceptionThrown(f,'linq:skip:InputValue')

function testCountShorterThanSource
source = 0:4;
result = linq(source).skip(3);
assertEqual(result.toArray,[3 4]);

function testCountEqualtoSourceLength
source = 0:4;
result = linq(source).skip(5);
assertEqual(result.toArray,[]);

function testCountGreaterthanSourceLength
source = 0:4;
result = linq(source).skip(15);
assertEqual(result.toArray,[]);
