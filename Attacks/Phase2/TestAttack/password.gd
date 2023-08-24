extends Node2D

enum TestPhase {
	CREATE = 0,
	CHECK,
}
var CUR_TEST_PHASE = TestPhase.CREATE

var VALUE = ''
