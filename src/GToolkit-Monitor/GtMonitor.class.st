Class {
	#name : #GtMonitor,
	#superclass : #Object,
	#category : #'GToolkit-Monitor'
}

{ #category : #'gt-extension' }
GtMonitor >> gtProcessesFor: aView [
	<gtView>
	
	^ aView explicit
		title: 'Processes';
		priority: 5;
		stencil: [ GtMonitoredProcessesElement new ]
]

{ #category : #'gt-extension' }
GtMonitor >> gtSpacesFor: aView [
	<gtView>
	
	^ aView explicit
		title: 'Spaces';
		priority: 3;
		stencil: [ GtMonitoredBlocSpacesElement new ];
		actionStencil: [ 
			BrButton new 
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons trash asElement;
				action:  [ :aButton |
					(BlSpace allSubInstances copyWithout: aButton space) do: [ :eachSpace |
						eachSpace isOpened
							ifTrue: [ eachSpace close ] ].
					Smalltalk garbageCollect ] ]
]

{ #category : #'gt-extension' }
GtMonitor >> gtSystemInfoFor: aView [
	<gtView>
	
	^ aView explicit
		title: 'System';
		priority: 1;
		stencil: [ GtMonitorSystemInfoElement new ]
]

{ #category : #'gt-extension' }
GtMonitor >> gtTaskItServicesFor: aView [
	<gtView>
	
	^ aView explicit
		title: 'Services';
		priority: 4;
		stencil: [ GtMonitoredTaskItServicesElement new ];
		actionButtonIcon: BrGlamorousIcons trash 
			action: [ :aButton | TKTConfiguration serviceManager purge ]
			
]

{ #category : #'gt-extension' }
GtMonitor >> gtUniversesFor: aView [
	<gtView>
	
	^ aView explicit
		title: 'Universes';
		priority: 2;
		stencil: [ GtMonitoredUniversesElement new ]
]
