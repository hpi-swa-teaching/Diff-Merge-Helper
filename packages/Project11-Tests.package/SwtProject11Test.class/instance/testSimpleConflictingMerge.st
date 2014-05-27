running
testSimpleConflictingMerge
	"|workingCopy version methodIndex oldMethodDef newMethodDef snapshot1 snapshot2 snapshot3 merger package packageName |
	
	
	packageName := 'Project11-Core'.
	
	Transcript cr; show: '### start TestCase: testSimpleConflictingMerge'; cr.
	
	package := MCPackage new name: packageName.
	Transcript show: 'package: ', package; cr.
	
	workingCopy := MCWorkingCopy forPackage: package.
	Transcript show: 'workingCopy: ', workingCopy; cr.
	
	version := workingCopy newVersionWithName: packageName message:''.
	Transcript show: 'version ', version; cr.
	
	snapshot1 := version snapshot.
	snapshot2 := version snapshot deepCopy.
	snapshot3 := version snapshot deepCopy.
	methodIndex := 5.
	oldMethodDef := (snapshot2 definitions at: methodIndex).
	newMethodDef := MCMethodDefinition
		className: ( oldMethodDef className)
		selector: ( oldMethodDef selector )
		category: ( oldMethodDef category )
		timeStamp: ( oldMethodDef timeStamp )
		source: ( oldMethodDef source, '42' ).

	(snapshot3 definitions) remove: methodIndex ifAbsent: [].		
	
	snapshot2 definitions at: methodIndex put: newMethodDef.
	
	oldMethodDef := (snapshot1 definitions at: methodIndex).
	newMethodDef := MCMethodDefinition
		className: ( oldMethodDef className)
		selector: ( oldMethodDef selector )
		category: ( oldMethodDef category )
		timeStamp: ( oldMethodDef timeStamp )
		source: ( oldMethodDef source, '21' ).
		
	snapshot1 definitions at: methodIndex put: newMethodDef.
	
	merger := MCThreeWayMerger base: snapshot1 target: snapshot2 ancestor: snapshot3.
	self assert: merger notNil description: 'merger must not be nil'.	
	self assert: merger conflicts notNil description: 'merger conflicts must not be nil'
	"